{ self, ... }:
{
  flake.modules.nixos.Mech = {
    imports = [
      # 系统基础
      self.modules.nixos.base

      # 本机硬件与存储
      self.modules.nixos.MechFilesystem
      self.modules.nixos.MechGraphics
      self.modules.nixos.MechHardware
      self.modules.nixos.MechImpermanence

      # 桌面
      self.modules.nixos.desktop

      # 额外服务与程序
      self.modules.nixos.flatpak
      self.modules.nixos.virtualisation
    ];
    networking.hostName = "Mech";
    system.stateVersion = "26.11";
    home-manager.users.aohg = {
      imports = [ self.modules.homeManager.Mech ];
    };
  };
}
