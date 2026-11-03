{ inputs, ... }:
{
  flake.modules.nixos.dsh = {
    imports = [ inputs.deepseek-harness.nixosModules.default ];
  };
  flake.modules.homeManager.dsh = {
    # 显式引入 overlay，确保 home 侧 pkgs 能看到 dsh（即使 NixOS 已全局设置，加上也无害）
    nixpkgs.overlays = [ inputs.deepseek-harness.overlays.default ];

    programs.dsh = {
      enable = true;
      # 可选：指定使用的包
      # package = inputs.deepseek-harness.packages.${pkgs.system}.dsh;

      # 在此声明 bundles、presets 等用户级配置
      # bundles = [ ... ];
    };

    # 启用 WebUI 为 systemd 用户服务
    services.dsh = {
      enable = true;
      # 默认监听 127.0.0.1:3080，仅本机可访问[reference:6][reference:7]
      # listenAddress = "127.0.0.1";   # 如需局域网访问可改为 "0.0.0.0"
      # port = 3080;                   # 端口可自定义
    };
  };
}
