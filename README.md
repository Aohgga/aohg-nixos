# aohg-nixos

我的 NixOS 配置，使用 Dendritic Pattern + flake-parts。两台机器都用 impermanence 管理
系统状态：系统盘上的改动在重启后不会保留，需要保留的文件或文件夹放在单独的分区里。

- **Mech**：根目录和 home 是 btrfs 子卷，每次开机把旧子卷改名归档，再新建一份空的；
  需要保留的内容放在 `/persistent` 和 `/persist-home`。
- **Legion**：根目录和 home 直接挂在内存里（tmpfs），重启后清空；
  需要保留的内容放在 XFS 分区的 `/persistent`。

`modules/` 下每个 `.nix` 都是 flake-parts 模块，`import-tree` 会自动把它们收集为
`flake.modules`；`flake.nix` 由 flake-file 从各模块的 `flake-file.inputs` 生成，
输出入口在 `outputs.nix`。

修改之前请先读 [AGENTS.md](./AGENTS.md)：目录职责、命名、排序、密文、验证和提交的
规则都在那里。

```
modules/
├── flake-file.nix       引入 flake-file 并声明基础 inputs
├── flake-parts.nix      引入 flake-parts 的 flake.modules 输出和 home-manager 集成
├── profiles.nix         跨主机组合（nixos.base / nixos.desktop / homeManager.base）
├── features/            多台机器通用的模块
│   ├── system/          系统层：启动、网络、代理、安全、nix、环境、用户、本地化、
│   │                    服务、agenix、flatpak、虚拟化等
│   ├── desktop/         桌面环境、登录管理器、输入法、主题、字体、denial、umbriel
│   ├── apps/            应用：编辑器、文件管理器、播放器、音乐、终端工具等
│   ├── shell/           fish、kitty、ttyper、yazi
│   ├── hardware/        声卡、蓝牙、显卡、硬件与系统调优
│   ├── home.nix         用户层基础（username、homeDirectory、xdg）
│   └── persistence.nix  持久化选项、base 清单和汇总
└── hosts/               只属于某台机器的配置
    ├── machine.nix      扫描 hosts/* 自动生成 nixosConfigurations
    ├── Mech/
    └── Legion/

config/umbriel/          umbriel 的纯数据配置（不是模块，不会被 import-tree 收集）
secrets/*.age            agenix 密文，接收者写在 agenix-rules.nix
```

常用命令：

```sh
nix flake check --no-write-lock-file   # 只检查配置能否求值，不构建
nix run .#write-flake                   # 改了 flake-file.inputs 后重新生成 flake.nix
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
nrs                          # 切换本机配置；也可以接 boot / test / build / dry-activate
nix fmt                      # 用 nixfmt 格式化；会重排整个仓库，按 AGENTS 的规则慎用
```
