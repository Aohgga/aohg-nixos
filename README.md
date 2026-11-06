# aohg-nixos

Dendritic Pattern + flake-parts 的 NixOS 配置，两台主机都用 impermanence 管理状态
（系统盘上的改动重启后不保留，用户数据靠单独的分区持久化）：

- **Mech**：根目录和 home 是 btrfs 子卷，每次开机把旧子卷改名归档，再新建一份空的；
  需要保留的内容放在 `/persistent` 和 `/persist-home`。
- **Legion**：根目录和 home 直接挂在内存里（tmpfs），重启即清空；
  需要保留的内容放在 XFS 分区的 `/persistent`。

`modules/` 下每个 `.nix` 都是 flake-parts 模块，由 `import-tree` 自动收集；
`flake.nix` 只声明 inputs 和引导。

**改配置前请先读 [AGENTS.md](./AGENTS.md)**：目录职责、命名、排序规则、let/注释规则、
密文约定、验证命令都在那里。

```
modules/
├── flake-parts.nix       flake-parts 引导
├── profiles.nix          跨主机组合（nixos.base / nixos.desktop / homeManager.base）
├── features/             可复用模块（与机器无关）
│   ├── desktop/          桌面环境、登录管理器、输入法、umbriel
│   ├── hardware/         声卡、蓝牙、性能调优
│   ├── shell/            fish、kitty、ttyper、yazi
│   └── *.nix             持久化、主题、字体、i18n、网络、nix、dsh 等
└── hosts/                主机专属
    ├── machine.nix       自动扫描 hosts/* 生成 nixosConfigurations
    ├── Mech/
    └── Legion/

config/umbriel/           umbriel 的纯数据配置（不是模块，不会被 import-tree 收集）
secrets/*.age             agenix 密文，接收者写在根目录的 agenix-rules.nix
```

常用命令：

```sh
nix flake check --no-build   # 只检查两台主机的配置能否求值，不构建
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
nrs                          # 切换本机配置；也可以接 boot / test / build / dry-activate
nix fmt                      # 用 nixfmt 格式化；会重排整个仓库，按 AGENTS 的约定慎用
```
