{
  # AppImage 的所有数据（设置、恢复点、最近文件）都在 $XDG_DATA_HOME/ElyOffice，
  # 源码 crates/ely-platform/src/dirs.rs 确认；AppImage 本体在 ~/Applications。
  flake.modules.homeManager.ely-office = { osConfig, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".local/lib/ely-office"
      ".local/share/ElyOffice"
    ];
  };
}
