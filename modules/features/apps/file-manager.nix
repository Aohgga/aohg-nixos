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

  # Strata 没有“预览字体”设置：预览固定使用内置的 JetBrains Mono（见其 src/style.css
  # 里 .preview-text / .preview-source-lines 的 font-family）。上游提供了用户样式表
  # ~/.config/strata/style.css，优先级高于自带样式，用它把预览字体交还给 fontconfig 的
  # monospace（Legion 上为 Terminess Nerd Font）。
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
