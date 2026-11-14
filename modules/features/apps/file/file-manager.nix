{ inputs, ... }:
{
  flake-file.inputs.strata = {
    url = "github:lgse/strata";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.file-manager =
    { pkgs, ... }:
    let
      strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      environment.systemPackages = [ strata ];
      local.persistence.home.directories = [
        ".config/strata"
        ".local/share/strata"
        ".local/share/Trash"
        ".local/state/strata"
      ];
      services.dbus.packages = [ strata.fileManagerService ];
      xdg.portal.extraPortals = [ strata.fileChooserPortal ];
    };

  flake.modules.homeManager.file-manager = {
    xdg.configFile."strata/style.css".text = ''
      /* 文件预览（纯文本 / 源码 / 行号）改用系统等宽字体，
         由 fontconfig 的 monospace 决定具体字体。 */
      .preview-text,
      .preview-text text,
      .preview-source-lines,
      .preview-source-row,
      .preview-source-row text {
        font-family: monospace;
      }
    '';
  };
}
