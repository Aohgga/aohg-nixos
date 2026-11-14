{ ... }:
{
  flake.modules.nixos.nrs = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.nix-output-monitor

      # nrs [操作] [额外参数...]：把 nixos-rebuild 的日志交给 nom 渲染
      (pkgs.writeShellApplication {
        name = "nrs";
        runtimeInputs = [ pkgs.nix-output-monitor ];
        text = ''
          flake="''${NRS_FLAKE:-''$HOME/.config/aohg-nixos}"
          host="''${NRS_HOST:-$(hostname)}"
          nom_on="''${NRS_NOM:-1}"

          usage() {
            cat <<'EOF'
          用法: nrs [操作] [额外参数...]

          操作:
            switch        构建并切换到新配置（默认）
            boot          构建并设为下次启动
            test          构建并临时激活
            build         只构建
            dry-activate  只模拟激活
            update        更新 flake.lock
            check         检查配置能否求值
            write-flake   从模块重新生成 flake.nix
            help          显示本帮助

          环境变量:
            NRS_FLAKE     配置目录，默认 $HOME/.config/aohg-nixos
            NRS_HOST      主机名，默认当前 hostname
            NRS_NOM=0     关闭 nom 的输出渲染

          示例:
            nrs                    # 切换
            nrs boot               # 下次启动生效
            nrs build --print-out-paths
            nrs update             # 更新依赖
            nrs write-flake        # 改了 flake-file.inputs 后重新生成 flake.nix
          EOF
          }

          op="''${1:-switch}"
          if [ "$#" -gt 0 ]; then
            shift
          fi

          case "$op" in
            switch|boot|test|build|dry-activate)
              # 先单独认证：密码提示不能被后面的管道吞掉
              sudo -v
              if [ "$nom_on" = "0" ]; then
                sudo nixos-rebuild "$op" --flake "$flake#$host" "$@"
              else
                sudo nixos-rebuild "$op" --flake "$flake#$host" \
                  --log-format internal-json "$@" 2>&1 | nom --json
              fi
              ;;
            update)
              (cd "$flake" && nix flake update)
              ;;
            check)
              (cd "$flake" && nix flake check --no-write-lock-file)
              ;;
            write-flake)
              # 写回 flake 目录，不管当前在哪个目录
              (cd "$flake" && nix run .#write-flake)
              ;;
            help|-h|--help)
              usage
              ;;
            *)
              echo "nrs: 未知操作 '$op'" >&2
              usage >&2
              exit 2
              ;;
          esac
        '';
      })
    ];

    programs.bash.interactiveShellInit = ''
      complete -W "switch boot test build dry-activate update check write-flake help" nrs
    '';
  };

  flake.modules.homeManager.nrs = {
    xdg.dataFile."fish/vendor_completions.d/nrs.fish".text = ''
      complete -c nrs -f -n '__fish_use_subcommand' -a switch -d '构建并切换到新配置（默认）'
      complete -c nrs -f -n '__fish_use_subcommand' -a boot -d '构建并设为下次启动'
      complete -c nrs -f -n '__fish_use_subcommand' -a test -d '构建并临时激活'
      complete -c nrs -f -n '__fish_use_subcommand' -a build -d '只构建'
      complete -c nrs -f -n '__fish_use_subcommand' -a dry-activate -d '只模拟激活'
      complete -c nrs -f -n '__fish_use_subcommand' -a update -d '更新 flake.lock'
      complete -c nrs -f -n '__fish_use_subcommand' -a check -d '检查配置能否求值'
      complete -c nrs -f -n '__fish_use_subcommand' -a write-flake -d '重新生成 flake.nix'
      complete -c nrs -f -n '__fish_use_subcommand' -a help -d '显示帮助'
    '';
  };
}
