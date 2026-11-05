# aohg-nixos

Dendritic Pattern + flake-parts 的 NixOS 配置。

`modules/` 下每个 `.nix` 文件都是 flake-parts 模块，由 `import-tree` 自动收集成
`flake.modules.<class>.<name>`；`flake.nix` 只声明 inputs 和引导。

## 目录职责

```
flake.nix                     inputs 与 mkFlake 引导，不写配置
agenix-rules.nix              agenix CLI 的接收者规则（工具要求放根目录）
config/                       纯数据/生成器（不是 flake 模块，不被自动收集）
secrets/                      agenix 密文（*.age）
modules/
├── flake-parts.nix           flake-parts 自身引导
├── profiles.nix              跨主机组合：nixos.base / nixos.desktop / homeManager.base
├── features/                 可复用模块：与具体机器无关
│   ├── <name>.nix
│   └── <domain>/<name>.nix   仅 desktop/ hardware/ shell/ 这类多模块领域
└── hosts/
    ├── machine.nix           自动发现 hosts/* → nixosConfigurations
    └── <Host>/               主机名即目录名（PascalCase，与 hostname 一致）
        ├── default.nix       flake.modules.nixos.<Host>
        ├── home.nix          flake.modules.homeManager.<Host>
        ├── hardware-configuration.nix  生成文件，保持原样
        └── <aspect>.nix      flake.modules.nixos.<Host><Aspect>
```

判断某个配置放哪：

| 内容 | 位置 |
| --- | --- |
| 与机器无关、可能被任意/多台主机启用 | `modules/features/` |
| 只对某台机器成立（硬件、GPU、分区、持久化、专属包） | `modules/hosts/<Host>/` |
| 多台主机共同启用的组合集合 | `modules/profiles.nix` |
| 不是模块的纯数据（如 umbriel 默认配置） | `config/` |
| 密钥密文 | `secrets/` |

## 命名规则

- 目录：小写 kebab-case。唯一例外：`modules/hosts/<Host>/` 用 PascalCase，必须等于 `networking.hostName`。
- 文件：小写 kebab-case，单数，见名知意。
- 文件名 = 模块名（去掉 class 前缀）：
  - `features/networking.nix` → `flake.modules.nixos.networking`
  - `features/shell/fish.nix` → `flake.modules.homeManager.fish`
  - `hosts/Mech/filesystem.nix` → `flake.modules.nixos.MechFilesystem`
  - `hosts/Mech/default.nix` → `flake.modules.nixos.Mech`（入口模块）
- 不用 `xxx/default.nix` 包单个模块；目录本身就是入口时（`hosts/<Host>/`）才用 `default.nix`。
- 类别目录只用于聚合同一领域的多个模块（`desktop/`、`hardware/`、`shell/`）；单个模块直接平铺。

## 文件内写作顺序

1. 文件头注释（可选，只写“为什么”，不写“是什么”）
2. 函数参数：按字母序，如 `{ config, inputs, lib, self, ... }`
3. `let` 绑定：按字母序
4. `flake.modules.<class>.<name>` 定义：先按 class 字母序（`homeManager` 在 `nixos` 前），
   同类按 name 字母序
5. 每个模块内部：
   1. `imports`
   2. 其余选项按 option path 字母序（`boot` < `environment` < `fileSystems` < `hardware`
      < `home-manager` < `networking` < `nix` < `programs` < `services` < `systemd` < `users` < `xdg`）
   3. 选项的 attrset 内，键按字母序
   4. 注释放在被解释的选项正上方
6. 例外：`hosts/*/impermanence.nix` 这类有执行顺序语义的大模块保留分区注释结构，
   只对列表值排序。

## 列表排序

除“顺序有语义”的列表外，一律按不区分大小写的字母序排列（等价于 `LC_ALL=C sort -f`，
点文件排在最前）：

- 包列表：`home.packages`、`environment.systemPackages`、`extraPackages`、`addons`
- 持久化清单：`directories`（含 `{ directory = ...; }` 按 directory 排）、`files`
- `imports`、`trusted-users`、`extraGroups`、`kernelParams`
- `substituters` / `trusted-public-keys`：按主机名字母序，两表保持同一顺序

不排序（顺序即语义）：

- `systemd.services.dsh-web.environment.PATH` 这类 PATH 优先级列表
- 端口列表、`systemd` 的 `after`/`before`/`requires` 依赖
- `imports` 里显式表达层次的嵌套（如果需要）

## 加东西时

- **新主机**：建 `modules/hosts/<Name>/default.nix`，定义 `flake.modules.nixos.<Name>`；
  `machine.nix` 自动发现（要求有 `default.nix` 且目录名 = 模块名）。
- **新公共特性**：`modules/features/<name>.nix` 定义 `flake.modules.nixos.<name>` 或
  `flake.modules.homeManager.<name>`；要全局启用就在 `modules/profiles.nix` 的
  `base`/`desktop` 列表里加一行（按字母序插入）。
- **主机专属模块**：`modules/hosts/<Host>/<aspect>.nix`，模块名 `<Host><Aspect>`。
- **新包**：加到 `features/apps.nix`（公共）或对应主机的 `apps.nix`，按字母序插入。
- **新持久化目录**：加到对应主机的 `impermanence.nix`，按字母序插入。

改完跑 `nix fmt`（nixfmt）和 `nix flake check`。构建两台机器：

```sh
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
```
