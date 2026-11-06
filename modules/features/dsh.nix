{ inputs, ... }:
{
  flake.modules.nixos.dsh = { config, lib, ... }: {
    imports = [ inputs.deepseek-harness.nixosModules.default ];
    nixpkgs.overlays = [ inputs.deepseek-harness.overlays.default ];

    # dsh WebUI 作为系统级服务运行：开机由系统 systemd 直接拉起，
    # 不依赖用户会话、linger，也不依赖 home-manager 往 tmpfs 的
    # ~/.config/systemd/user 里写 unit（那会导致开机后几十秒空窗）。
    services.dsh = {
      enable = true;
      # 复用 home-manager 组合好的包（bundles / mutable 都在里面），
      # profile 名也跟随 programs.dsh 的 materializedName。
      package = config.home-manager.users.aohg.services.dsh.package;
      user = "aohg";
      group = "users";
      dataDir = "/home/aohg/.dsh";
      homeDirectory = "/home/aohg/.dsh";
      workspace = "/home/aohg/.dsh/workspace";
      port = 3080;
      listenAddress = "127.0.0.1";
      profile = config.home-manager.users.aohg.programs.dsh.profiles.web.materializedName;
    };

    # 上游系统服务默认 ProtectHome=true、ProtectSystem=strict、NoNewPrivileges=true，
    # 但 DSH_HOME 在 /home 下，而且 dsh 会执行任意用户工具，
    # 这里放宽回原来用户服务的权限模型（保留 PrivateTmp / Restart 等）。
    systemd.services.dsh-web.serviceConfig = {
      ProtectHome = lib.mkForce false;
      ProtectSystem = lib.mkForce false;
      NoNewPrivileges = lib.mkForce false;
      # 系统服务默认只有主组；补上用户原有的附加组，
      # 否则视频、输入设备、NetworkManager 等会和以前不一致。
      SupplementaryGroups = config.users.users.aohg.extraGroups;
    };

    # 系统服务不继承登录会话的 PATH，默认只有 coreutils/findutils/systemd，
    # 导致 dsh 里执行 `nix`/`git`/`rsync` 之类会 not found。
    # 这里显式给出和 /etc/set-environment 一致的登录 PATH（顺序即优先级）。
    systemd.services.dsh-web.environment.PATH = lib.mkForce (
      lib.concatStringsSep ":" [
        "/run/wrappers/bin"
        "/home/aohg/.nix-profile/bin"
        "/home/aohg/.local/state/nix/profile/bin"
        "/etc/profiles/per-user/aohg/bin"
        "/nix/var/nix/profiles/default/bin"
        "/run/current-system/sw/bin"
      ]
    );
    systemd.tmpfiles.rules = [ "e /home/aohg/.dsh/logs - - - 7d" ];
  };

  flake.modules.homeManager.dsh = { pkgs, ... }: {
    imports = [ inputs.deepseek-harness.homeModules.default ];

    programs.dsh = {
      enable = true;
      # 用本系统 pkgs 里的 dsh（overlay 已注入），而不是
      # inputs.deepseek-harness.packages.…：后者会用 DSH 自己 pin 的
      # nixpkgs 再构建一遍，和下面的 bundles 分属两套 nixpkgs。
      package = pkgs.dsh.dsh;
      profiles.web = {
        bundles = [ pkgs.dsh.bundles.web-app ];
        # 允许运行时用 `dsh plugin` 或插件市场安装，Nix 不再覆盖 profile。
        mode = "mutable";
      };
    };
  };
}
