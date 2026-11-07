# aohg-nixos

这是我的 NixOS 配置：用 Dendritic Pattern + flake-parts 组织，两台机器都靠
impermanence 管状态——系统盘上的改动重启就没了，真正要留的东西放在单独的分区里。

- **Mech**：根目录和 home 是 btrfs 子卷；每次开机会把旧子卷改名归档，再建一份空的。
  要保留的内容放 `/persistent` 和 `/persist-home`。
- **Legion**：根目录和 home 直接挂在内存里（tmpfs），重启全清。
  要保留的内容放 XFS 分区的 `/persistent`。

`modules/` 下每个 `.nix` 都是一个 flake-parts 模块，`import-tree` 会自动收进
`flake.modules`；`flake.nix` 只负责声明 inputs 和启动，不写系统配置。

动手改之前先读 [AGENTS.md](./AGENTS.md)：目录怎么分、文件怎么命名、排序和注释的
规矩、密文怎么放、改完怎么验证，都在那里。

```
modules/
├── flake-parts.nix      flake-parts 的启动文件
├── profiles.nix         跨主机组合（nixos.base / nixos.desktop / homeManager.base）
├── features/            所有机器都能用的模块
│   ├── desktop/         桌面环境、登录管理器、输入法、denial、umbriel
│   ├── hardware/        声卡、蓝牙、性能调优
│   ├── shell/           fish、kitty、ttyper、yazi
│   └── *.nix            单文件模块：持久化、主题、字体、i18n、网络、nix、dsh、
│                        mpv、swayimg、musicfox、flatpak、steam 等
└── hosts/               只属于某台机器的配置
    ├── machine.nix      扫描 hosts/* 自动生成 nixosConfigurations
    ├── Mech/
    └── Legion/

config/umbriel/          umbriel 的纯数据配置（不是模块，import-tree 不会收）
secrets/*.age            agenix 密文，接收者写在根目录 agenix-rules.nix
```

常用命令：

```sh
nix flake check --no-write-lock-file   # 只检查配置能不能求值，不构建
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
nrs                          # 切换本机配置；也能接 boot / test / build / dry-activate
nix fmt                      # 用 nixfmt 格式化；会重排整个仓库，按 AGENTS 的约定慎用
```
