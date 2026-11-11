{
  # reims-vgpu 的 QEMU 与 reims-ctl 由 install-ctl.sh 在 nix-shell 里手工构建，
  # 产物落在 home 下；impermanence 下不注册就会在重启后丢失。
  flake.modules.nixos.MechReimsVgpu = { config, ... }: {
    local.persistence.home.directories = [
      ".cargo"
      ".config/reims-ctl"
      ".local/share/reims-ctl"
      ".rustup"
    ];

    # /dev/udmabuf 平时靠 logind 的 uaccess ACL；SSH 里启动的 VM 只能靠 kvm 组。
    users.users.${config.local.primaryUser.name}.extraGroups = [ "kvm" ];

    # reims-ctl 只扫描标准 Vulkan ICD 目录，而 NixOS 把清单放在
    # /run/opengl-driver/share/vulkan/icd.d；/etc 在扫描范围内，链接一份过去。
    environment.etc."vulkan/icd.d/nvidia_icd.json".source =
      "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json";
  };

  # reims-ctl 和它拉起的 QEMU 在运行时 dlopen Vulkan、Wayland 与 X11 的客户端库，
  # 手工构建的二进制没有这些库的 rpath，用 wrapper 补上。
  flake.modules.homeManager.MechReimsVgpu = { pkgs, ... }: {
    home.packages = [
      (pkgs.writeShellScriptBin "reims-ctl" ''
        export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
          pkgs.wayland
          pkgs.libxkbcommon
          pkgs.libx11
          pkgs.libxext
          pkgs.libxrandr
          pkgs.libxcursor
          pkgs.libxi
          pkgs.libxfixes
          pkgs.libxscrnsaver
          pkgs.libxtst
          pkgs.libdecor
          pkgs.libGL
          pkgs.libdrm
          pkgs.libgbm
          pkgs.vulkan-loader
        ]}:/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
        exec "$HOME/.cargo/bin/reims-ctl" "$@"
      '')
    ];
    home.sessionPath = [ "$HOME/.cargo/bin" ];
  };
}
