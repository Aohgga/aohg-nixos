{
  flake.modules.nixos.virtualisation = {
    users.extraGroups.vboxusers.members = [ "aohg" ];

    # VBoxSDL 是 setuid 程序，LD_LIBRARY_PATH 会被安全模式忽略，
    # 导致 DXVK 找不到 libvulkan.so.1（3D 开启时崩溃）。
    # 给 VBoxSDL / VBoxDxVk.so 写入 RUNPATH，setuid 下也能找到 Vulkan loader。
    nixpkgs.overlays = [
      (final: prev: {
        virtualbox = prev.virtualbox.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            for f in "$out"/libexec/virtualbox/VBoxSDL "$out"/libexec/virtualbox/VBoxDxVk.so; do
              if [ -e "$f" ]; then
                ${prev.patchelf}/bin/patchelf --add-rpath ${prev.vulkan-loader}/lib "$f"
              fi
            done
          '';
        });
      })
    ];

    systemd.units."dev-vboxguest.device".text = ''
      [Unit]
      ConditionVirtualization=oracle
    '';
    virtualisation.virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
        enableHardening = true;
        enableKvm = false;
        addNetworkInterface = true;
      };
      guest = {
        enable = true;
        use3rdPartyModules = true;
      };
    };
  };
}
