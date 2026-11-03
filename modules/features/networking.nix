{
  flake.modules.nixos.networking = {
    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = true;

        # 只在家里这个网段开放服务端口（ssh / jellyfin / localsend），
        # 公共 Wi-Fi 上等同于全部关闭；loopback 仍由防火墙默认放行。
        # 注意：家里路由器换了网段（目前 192.168.2.0/24）要同步改这里。
        # jellyfin 的 8096/tcp、1900/udp、7359/udp 在这里统一放行，
        # 对应 jellyfin.nix 里 openFirewall = false。
        extraInputRules = ''
          ip  saddr 192.168.2.0/24 tcp dport { 22, 8096, 53317 } accept
          ip  saddr 192.168.2.0/24 udp dport { 1900, 7359, 53317 } accept
          ip6 saddr { fe80::/10, fc00::/7 } tcp dport { 22, 8096, 53317 } accept
          ip6 saddr { fe80::/10, fc00::/7 } udp dport { 1900, 7359, 53317 } accept
        '';

        trustedInterfaces = [ "mihomo" ];
      };
      nftables.enable = true;
    };
    systemd.services.NetworkManager-wait-online.enable = false;
    services.openssh = {
      enable = true;
      # 22 端口由上面的 extraInputRules 按网段放行，不用全局 openFirewall
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
