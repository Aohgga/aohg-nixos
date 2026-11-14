{ inputs, ... }:
{
  flake-file.inputs.app-manager.url = "github:kem-a/AppManager";

  flake.modules.nixos.appimage = { pkgs, ... }: {
    programs.appimage = {
      enable = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.libepoxy
        ];
      };
      binfmt = true;
    };

    environment.systemPackages = [
      inputs.app-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # sandbox 挂载需要 setuid 的 fusermount3，由 wrapper 提供
    programs.fuse.enable = true;

    local.persistence.home.directories = [
      ".cache/appimage-run"
      ".local/share/app-manager"
      ".local/share/icons"
      "Applications"
    ];
  };
}
