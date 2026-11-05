{ self, ... }:
{
  flake.modules.nixos.Legion = {
    imports = [
      # 系统基础
      self.modules.nixos.base

      # 本机硬件与存储
      self.modules.nixos.LegionGraphics
      self.modules.nixos.LegionHardware
      self.modules.nixos.LegionImpermanence

      # 桌面
      self.modules.nixos.desktop

      # 额外服务与程序
      self.modules.nixos.jellyfin
      self.modules.nixos.steam
    ];
    home-manager.users.aohg = {
      imports = [ self.modules.homeManager.Legion ];
    };
    networking.hostName = "Legion";
    system.stateVersion = "26.05";
  };
}
