# aohg-nixos

Dendritic Pattern + flake-parts 的 NixOS 配置。`modules/` 下每个 `.nix` 都是
flake-parts 模块，由 `import-tree` 自动收集；`flake.nix` 只声明 inputs 和引导。

**改配置前请先读 [AGENTS.md](./AGENTS.md)**：目录职责、命名、排序规则、let/注释规则、
密文约定、验证命令都在那里。

```
modules/
├── flake-parts.nix       flake-parts 引导
├── profiles.nix          跨主机组合（nixos.base / nixos.desktop / homeManager.base）
├── features/             可复用模块（与机器无关）
└── hosts/                主机专属
    ├── machine.nix       自动发现 hosts/* → nixosConfigurations
    ├── Mech/
    └── Legion/
```

常用命令：

```sh
nix flake check
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
nrs                       # 本机切换（仓库内提供的 wrapper）
```
