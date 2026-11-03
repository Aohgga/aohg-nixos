{ inputs, ... }:
{
  flake.modules.nixos.dsh = {
    imports = [ inputs.deepseek-harness.nixosModules.default ];
    nixpkgs.overlays = [ inputs.deepseek-harness.overlays.default ];

    # dsh WebUI 是用户级 systemd 服务，默认只在该用户有会话时运行。
    # 开启 linger 后开机即启动，注销或切换用户也不会把 3080 带走。
    users.users.aohg.linger = true;
  };

  flake.modules.homeManager.dsh = { config, pkgs, ... }: {
    imports = [ inputs.deepseek-harness.homeModules.default ];

    programs.dsh = {
      enable = true;
      # 用本系统 pkgs 里的 dsh（overlay 已注入），而不是
      # inputs.deepseek-harness.packages.…：后者会用 DSH 自己 pin 的
      # nixpkgs 再构建一遍，和下面的 bundles 分属两套 nixpkgs。
      package = pkgs.dsh.dsh;

      profiles.web = {
        bundles = [ pkgs.dsh.bundles.web-app ];
        # 允许运行时用 `dsh plugin` 或插件市场安装，Nix 不再覆盖 profile
        mode = "mutable";
      };

      # 官方桌面端（Electron），两台主机共享
      desktop.enable = true;
    };

    services.dsh = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 3080;
      # 默认已是 "nix-web"，显式跟随 profiles 的 materializedName，
      # 以后重命名 profile 时服务不会悄悄退回上游 web preset。
      profile = config.programs.dsh.profiles.web.materializedName;
    };
  };
}
