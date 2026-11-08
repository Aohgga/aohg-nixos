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
      file = ../../../secrets/github-token.age;
      # root 读文件不受 owner 限制，这里让日常以 aohg 运行的 nix 也能读到。
      owner = "aohg";
      mode = "0400";
    };

    nix = {
      channel.enable = false;

      settings = {
        experimental-features = [ "flakes" "nix-command" ];
        trusted-users = [ "aohg" "root" ];
        auto-optimise-store = true;
        connect-timeout = 60;
        download-attempts = 10;
        use-xdg-base-directories = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
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

    documentation.nixos.enable = false;

    aohg.persistence.system.directories = [ "/var/lib/nixos" ];
  };
}
