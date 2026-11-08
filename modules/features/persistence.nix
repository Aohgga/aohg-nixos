{ ... }:
let
  # 没有应用模块认领的路径放在这里。新应用的持久化应注册在自己的模块里，
  # 不要加到这个列表。
  baseFiles = [
    { file = ".bash_history"; method = "symlink"; }
    { file = ".config/kglobalshortcutsrc"; method = "symlink"; }
    { file = ".config/mimeapps.list"; method = "symlink"; }
    { file = ".local/share/recently-used.xbel"; method = "symlink"; }
  ];

  baseSystemDirectories = [ "/var/lib/systemd" ];

  baseDirectories = [
    ".config/ELYTerminal"
    ".config/Ladybird"
    ".config/aohg-nixos"
    ".config/autostart"
    ".config/environment.d"
    ".config/libaccounts-glib"
    ".config/menus"
    ".config/net.imput.helium"
    ".local/share/ElyOffice"
    ".local/share/Ladybird"
    ".local/share/app.getlux.com.sakuracat.app"
    ".local/share/applications"
    ".local/share/gpu-screen-recorder"
    ".local/share/org.localsend.localsend_app"
    ".local/share/pki"
    "Desktop"
    "Projects"
  ];
in
{
  flake.modules.nixos.persistence = { config, lib, ... }: {
    options.aohg.persistence = {
      homeRoot = lib.mkOption {
        type = lib.types.str;
        default = "/persistent";
        description = "用户 home 的持久化根目录；Mech 覆盖为 /persist-home。";
      };

      home = {
        directories = lib.mkOption {
          type = lib.types.listOf (lib.types.either lib.types.str (lib.types.submodule {
            options = {
              directory = lib.mkOption { type = lib.types.str; };
              mode = lib.mkOption { type = lib.types.str; default = "0755"; };
            };
          }));
          default = [ ];
          description = "nixos 模块注册的 home 持久化目录。";
        };
        files = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule {
            options = {
              file = lib.mkOption { type = lib.types.str; };
              method = lib.mkOption {
                type = lib.types.enum [ "auto" "symlink" ];
                default = "symlink";
              };
            };
          });
          default = [ ];
          description = "nixos 模块注册的 home 持久化单文件。";
        };
      };

      system.directories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "各模块注册的系统持久化目录。";
      };
    };

    config = {
      environment.persistence = lib.mkMerge [
        {
          "/persistent".directories =
            config.aohg.persistence.system.directories ++ baseSystemDirectories;
        }
        {
          "${config.aohg.persistence.homeRoot}" = {
            users.aohg = {
              directories = config.aohg.persistence.home.directories ++ baseDirectories;
              files = config.aohg.persistence.home.files ++ baseFiles;
            };
          };
        }
      ];

      # 目标文件不存在时应用写入会静默丢失；开机先按清单补出空文件，
      # 新加的条目不用手动 touch。
      systemd.tmpfiles.rules =
        map (f: "f ${config.aohg.persistence.homeRoot}/home/aohg/${f.file} 0600 aohg users -")
          (config.aohg.persistence.home.files ++ baseFiles);
    };
  };
}
