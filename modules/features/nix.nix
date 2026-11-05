{
  flake.modules.nixos.nix = { config, pkgs, ... }: {
    # GitHub API token（PAT）。
    # 只有解析 branch/tag 时才会调用 api.github.com；匿名配额仅 60 次/小时，
    # 而且本机走代理共享出口 IP，很容易被打满。带 token 后是 5000 次/小时。
    # 内容由 agenix 开机时解密到 /run/agenix/github-token（tmpfs），格式为
    #   access-tokens = github.com=github_pat_xxx
    # 写入方式（在仓库根目录，会自动读 agenix-rules.nix）：
    #   agenix -e secrets/github-token.age
    age.secrets."github-token" = {
      file = ../../secrets/github-token.age;
      # root 读文件不受 owner 限制，这里让日常以 aohg 运行的 nix 也能读到。
      owner = "aohg";
      mode = "0400";
    };

    nix = {
      channel.enable = false;

      settings = {
        experimental-features = [ "flakes" "nix-command" ];
        # 让 flake 里声明的 cachix 真正生效（flake nixConfig 默认会被忽略）
        substituters = [
          "https://deepseek-harness-nix.cachix.org"
          "https://denial.cachix.org"
          "https://noctalia.cachix.org"
          "https://umbriel.cachix.org"
        ];
        "trusted-public-keys" = [
          "deepseek-harness-nix.cachix.org-1:5NrkwLN9veNMhiINtU5ZeV4isXFhFsOwn6Ms7J1M+TA="
          "denial.cachix.org-1:wd8YTnvPmugFrtdMJWtR1XdVknR3/g2nmBJkT+vAruo="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
        ];
        trusted-users = [ "aohg" "root" ];
        auto-optimise-store = true;
        connect-timeout = 60;
        download-attempts = 10;
        use-xdg-base-directories = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # 用 !include 而不是 nix.settings.access-tokens：
      # 后者会被写进 /nix/store 里的 /etc/nix/nix.conf，全局可读、还会被
      # nix copy 带到二进制缓存；!include 指向运行时解密的路径，文件不存在
      # 时会被静默跳过，所以 secret 还没写入时也不影响构建和 nix 使用。
      extraOptions = ''
        !include ${config.age.secrets."github-token".path}
      '';
    };

    nixpkgs.config.allowUnfree = true;

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

    documentation.nixos.enable = false;
  };
}
