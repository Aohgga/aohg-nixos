{
  flake.modules.nixos.ydotool =
    { config, ... }:
    {
      # ydotoold 以 root 运行并监听 /run/ydotoold/socket；
      # 客户端 ydotool 需要在该 socket 的属组里才能访问。
      programs.ydotool.enable = true;
      users.users."${config.local.primaryUser.name}".extraGroups = [ config.programs.ydotool.group ];

      # 开机加载 uinput 内核模块并准备好 /dev/uinput（ydotoold 打开它注入事件）。
      hardware.uinput.enable = true;
    };
}
