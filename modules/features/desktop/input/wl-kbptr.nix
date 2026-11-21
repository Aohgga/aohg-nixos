{
  flake.modules.nixos.wl-kbptr = { pkgs, ... }: {
    # 走 wlr-virtual-pointer 协议操作指针，不碰 /dev/uinput，与 ydotool 并行无冲突。
    environment.systemPackages = [ pkgs.wl-kbptr ];

    # 配置由用户手写，这里只声明持久化；开机时 tmpfiles 会在清单里补出空文件。
    local.persistence.home.files = [
      { file = ".config/wl-kbptr/config"; method = "symlink"; }
    ];
  };
}
