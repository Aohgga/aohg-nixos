{ inputs, ... }:
{
  flake-file.inputs.deepseek-harness.url = "github:moraxyc/deepseek-harness.nix";

  flake.modules.nixos.dsh =
    { config, lib, pkgs, ... }:
    let
      userName = config.local.primaryUser.name;
      home = config.users.users.${userName}.home;
    in
    {
      imports = [ inputs.deepseek-harness.nixosModules.default ];
      nixpkgs.overlays = [ inputs.deepseek-harness.overlays.default ];

      nix.settings = {
        substituters = [ "https://deepseek-harness-nix.cachix.org" ];
        "trusted-public-keys" = [
          "deepseek-harness-nix.cachix.org-1:5NrkwLN9veNMhiINtU5ZeV4isXFhFsOwn6Ms7J1M+TA="
        ];
      };

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
        user = userName;
        group = "users";
        dataDir = "${home}/.dsh";
        homeDirectory = "${home}/.dsh";
        workspace = "${home}/.dsh/workspace";
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
        SupplementaryGroups = config.users.users.${userName}.extraGroups;
      };
      systemd.services.dsh-web.environment.PATH = lib.mkForce (
        lib.concatStringsSep ":" [
          "/run/wrappers/bin"
          "${home}/.nix-profile/bin"
          "${home}/.local/state/nix/profile/bin"
          "/etc/profiles/per-user/${userName}/bin"
          "/nix/var/nix/profiles/default/bin"
          "/run/current-system/sw/bin"
        ]
      );
      systemd.tmpfiles.rules = [ "e ${home}/.dsh/logs - - - 7d" ];

      local.persistence.home.directories = [ ".dsh" ];
    };
}
