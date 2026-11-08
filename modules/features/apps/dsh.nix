{ inputs, ... }:
{
  flake.modules.nixos.dsh = { config, lib, pkgs, ... }: {
    imports = [ inputs.deepseek-harness.nixosModules.default ];
    nixpkgs.overlays = [ inputs.deepseek-harness.overlays.default ];

    programs.dsh = {
      enable = true;
      package = pkgs.dsh.dsh;
      profiles.web = {
        bundles = [ pkgs.dsh.bundles.web-app ];
        mode = "mutable";
      };
    };

    services.dsh = {
      enable = true;
      user = "aohg";
      group = "users";
      dataDir = "/home/aohg/.dsh";
      homeDirectory = "/home/aohg/.dsh";
      workspace = "/home/aohg/.dsh/workspace";
      port = 3080;
      listenAddress = "127.0.0.1";
      profile = config.programs.dsh.profiles.web.materializedName;
    };

    # DSH_HOME 在 /home 下，服务还要调用用户的 nix、git 等工具，
    # 所以放宽 ProtectHome、ProtectSystem、NoNewPrivileges。
    systemd.services.dsh-web.serviceConfig = {
      ProtectHome = lib.mkForce false;
      ProtectSystem = lib.mkForce false;
      NoNewPrivileges = lib.mkForce false;
      SupplementaryGroups = config.users.users.aohg.extraGroups;
    };
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

    aohg.persistence.home.directories = [ ".dsh" ];
  };
}
