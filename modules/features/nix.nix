{
  flake.modules.nixos.nix = { pkgs, ... }: {
    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "root" "aohg" ];
        # 让 flake 里声明的 cachix 真正生效（flake nixConfig 默认会被忽略）
        substituters = [
          "https://denial.cachix.org"
          "https://noctalia.cachix.org"
          "https://umbriel.cachix.org"
          "https://deepseek-harness-nix.cachix.org"
        ];
        "trusted-public-keys" = [
          "denial.cachix.org-1:wd8YTnvPmugFrtdMJWtR1XdVknR3/g2nmBJkT+vAruo="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
          "deepseek-harness-nix.cachix.org-1:5NrkwLN9veNMhiINtU5ZeV4isXFhFsOwn6Ms7J1M+TA="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    # nix-output-monitor：直接提供 nom
    environment.systemPackages = [
      pkgs.nix-output-monitor

      # nrs [switch|boot|test|build|dry-activate ...] [额外参数...]
      # 把 nixos-rebuild 的 internal-json 日志交给 nom 渲染
      (pkgs.writeShellApplication {
        name = "nrs";
        runtimeInputs = [ pkgs.nix-output-monitor ];
        text = ''
          flake="''${NRS_FLAKE:-/home/aohg/.config/aohg-nixos}"
          host="''${NRS_HOST:-$(hostname)}"

          if [ "$#" -gt 0 ]; then
            op="$1"
            shift
          else
            op="switch"
          fi

          # 先单独认证：密码提示不能被后面的管道吞掉
          sudo -v

          sudo nixos-rebuild "$op" --flake "$flake#$host" \
            --log-format internal-json "$@" 2>&1 | nom --json
        '';
      })
    ];

    nixpkgs.config.allowUnfree = true;
    documentation.nixos.enable = false;
  };
}
