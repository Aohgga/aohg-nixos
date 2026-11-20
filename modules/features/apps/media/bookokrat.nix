{
  flake.modules.homeManager.bookokrat = { config, osConfig, pkgs, ... }:
    let
      bookokrat = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "bookokrat";
        version = "0.3.14";

        # 上游 release 只发布 musl 静态二进制；直接取用，省掉 Rust + mupdf 的构建。
        src = pkgs.fetchurl {
          url = "https://github.com/bugzmanov/bookokrat/releases/download/v${version}/bookokrat-v${version}-x86_64-unknown-linux-musl.tar.gz";
          hash = "sha256-Wx8Y+nVNdfK/tHpag3NNsesH+q8LTxclVZ9nqlkZ2+U=";
        };

        dontBuild = true;
        dontUnpack = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          tar xzf $src -C $out/bin
          chmod +x $out/bin/bookokrat
          runHook postInstall
        '';

        meta = {
          description = "Terminal EPUB/PDF/DJVU book reader with Vim-style keybindings";
          homepage = "https://github.com/bugzmanov/bookokrat";
          license = pkgs.lib.licenses.agpl3Plus;
          mainProgram = "bookokrat";
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      home.packages = [ bookokrat ];
      # 文件处理器：已有 mimeapps 默认项指向 bookokrat.desktop，保持这个名字，
      # 只带 FILE 参数（-d 与 FILE 在 bookokrat 里互斥）。
      xdg.dataFile."applications/bookokrat.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=bookokrat
        Comment=用 bookokrat 打开 EPUB/PDF/DJVU
        Exec=kitty --class bookokrat -e bookokrat %f
        Icon=x-office-document
        Terminal=false
        NoDisplay=true
        Categories=Office;Viewer;
        MimeType=application/epub+zip;application/pdf;image/vnd.djvu;
        StartupWMClass=bookokrat
      '';

      # 菜单入口：书库模式，固定书库为 ~/Documents。
      xdg.dataFile."applications/bookokrat-library.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=bookokrat
        GenericName=Terminal book reader
        Comment=在终端里阅读 EPUB/PDF/DJVU
        Exec=kitty --class bookokrat -e bookokrat -d ${config.home.homeDirectory}/Documents
        Icon=x-office-document
        Terminal=false
        Categories=Office;Viewer;
        StartupWMClass=bookokrat
      '';

      home.persistence."${osConfig.local.persistence.homeRoot}" = {
        directories = [
          { directory = ".config/bookokrat"; }
          { directory = ".local/share/bookokrat"; }
          { directory = ".local/state/bookokrat"; }
        ];
      };
    };
}
