# aohg-nixos

Dendritic Pattern + flake-parts 的 NixOS 配置。

`modules/` 下每个 `.nix` 文件都是 flake-parts 模块，由 `import-tree` 自动收集成
`flake.modules.<class>.<name>`；`flake.nix` 只声明 inputs 和引导。

## 目录职责

```
flake.nix                     inputs 与 mkFlake 引导，不写配置；inputs 按字母序
agenix-rules.nix              agenix CLI 的接收者规则；条目按密文路径字母序
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

- 目录：小写 kebab-case。唯一例外：`modules/hosts/<Host>/` 用 PascalCase，必须等于
  `networking.hostName`。
- 文件：小写 kebab-case，单数，见名知意。
- 文件名 = 模块名（去掉 class 前缀）：
  - `features/networking.nix` → `flake.modules.nixos.networking`
  - `features/shell/fish.nix` → `flake.modules.homeManager.fish`
  - `hosts/Mech/filesystem.nix` → `flake.modules.nixos.MechFilesystem`
  - `hosts/Mech/default.nix` → `flake.modules.nixos.Mech`（入口模块）
- 不用 `xxx/default.nix` 包单个模块；目录本身就是入口时（`hosts/<Host>/`）才用
  `default.nix`。
- 类别目录只用于聚合同一领域的多个模块（`desktop/`、`hardware/`、`shell/`）。
- 密文放在 `secrets/` 根下，不建子目录：`secrets/<name>.age`，其中 `<name>` 同时是
  `age.secrets."<name>"` 和解密后的 `/run/agenix/<name>`。

## 排序总则

排序分两套，不要混用：

- **NixOS 模块**（`flake.modules.nixos.*`）按**功能主次**排，见下一节。
- **应用与用户级配置**（`flake.modules.homeManager.*`、`config/` 里的应用配置）
  按**名字母序**排。

纯字符串列表在同类内部按 `LC_ALL=C sort -f`（不区分大小写，点文件在前）排序。

## NixOS 模块的顺序（功能主次）

一个 NixOS 模块内，选项按下面的层级从底到顶排列；同一层内按表中从左到右的顺序，
表里没有的选项排在最后并按字母序：

| 层级 | 选项 |
| --- | --- |
| 1. 启动与硬件 | `boot`、`hardware`、`fileSystems`、`swapDevices`、`zramSwap` |
| 2. 网络 | `networking` |
| 3. 安全与身份 | `security`、`age`、`users` |
| 4. 包管理与环境 | `nix`、`nixpkgs`、`environment`、`documentation` |
| 5. 本地化 | `i18n`、`time`、`fonts` |
| 6. 服务与系统管理 | `services`、`systemd`、`system` |
| 7. 系统级程序 | `programs` |
| 8. 虚拟化 | `virtualisation` |
| 9. 用户层 | `home-manager`、`xdg` |

`imports` 永远排在最前。一个文件同时定义两类模块时，先 NixOS、后 homeManager。

聚合器（`modules/profiles.nix`、`modules/hosts/*/default.nix`）的 `imports` 也按层级
分组，组内按字母序，组间用一句注释说明：

```nix
imports = [
  # 系统基础
  self.modules.nixos.base

  # 本机硬件与存储
  self.modules.nixos.MechGraphics
  self.modules.nixos.MechHardware

  # 桌面
  self.modules.nixos.desktop

  # 额外服务与程序
  self.modules.nixos.flatpak
];
```

`hosts/*/impermanence.nix` 这类有执行顺序语义的大模块保留分区注释结构，只对列表值
排序。

## 应用级配置的顺序

- 包列表（`home.packages`、`environment.systemPackages`、`extraPackages`）按字母序。
- 应用配置（`programs.<应用>.settings`、`config/` 下的应用配置）内部键按字母序。
- 多个应用并列时按应用名字母序（`programs.fish` < `programs.kitty` …）。
- 持久化清单（`directories` / `files`）按字母序，`{ directory = ...; }` 按 directory 排。

不排序（顺序即语义）：

- `PATH` 这类优先级列表、端口列表
- `systemd` 的 `after` / `before` / `requires` 依赖
- `kernelParams`、`substituters` 这类需要人工控制优先级的列表

## 加东西时

- **新主机**：建 `modules/hosts/<Name>/default.nix`，定义
  `flake.modules.nixos.<Name>`；`machine.nix` 自动发现（要求有 `default.nix` 且目录名
  = 模块名）。
- **新公共特性**：`modules/features/<name>.nix` 定义对应 class 的模块；要全局启用就在
  `modules/profiles.nix` 对应层级里加一行（组内按字母序插入）。
- **主机专属模块**：`modules/hosts/<Host>/<aspect>.nix`，模块名 `<Host><Aspect>`。
- **新包**：加到 `features/apps.nix`（公共）或对应主机的 `apps.nix`，按字母序插入。
- **新持久化目录**：加到对应主机的 `impermanence.nix`，按字母序插入。
- **新应用配置**：放 `modules/features/<app>.nix`，配置键按字母序。

改完跑 `nix fmt`（nixfmt）和 `nix flake check`。构建两台机器：

```sh
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
```
