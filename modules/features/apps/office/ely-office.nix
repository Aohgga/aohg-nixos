{ inputs, ... }:
{
  flake-file.inputs.ely-office = {
    url = "github:ELY-Open-Source/ElyOffice";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # AppImage 的所有数据（设置、恢复点、最近文件）都在 $XDG_DATA_HOME/ElyOffice，
  # 源码 crates/ely-platform/src/dirs.rs 确认；.local/lib/ely-office 是运行时解包。
  flake.modules.homeManager.ely-office = { osConfig, pkgs, ... }: {
    home.packages = [
      inputs.ely-office.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".local/lib/ely-office"
      ".local/share/ElyOffice"
    ];
  };
}
