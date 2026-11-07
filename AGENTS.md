# AGENTS.md

本文件是给后续修改此仓库的 AI / 维护者的规范。改配置前先读完。

## 仓库模型

- Dendritic Pattern + flake-parts：`modules/` 下每个 `.nix` 都是 flake-parts 模块，
  由 `import-tree` 自动收集为 `flake.modules.<class>.<name>`。
- `flake.nix` 只声明 inputs 和 `mkFlake` 引导，不写系统配置。
- 组合靠 `flake.modules`：主机/聚合器用 `imports` 引用模块，不直接 `import ./文件`。
- `flake.modules` 来自 flake-parts 官方 extras（`flakeModules.modules`），
  `nix flake check` 的 `unknown flake output 'modules'` 属正常提示。

## 目录职责

| 内容 | 位置 |
| --- | --- |
| 与机器无关、可被多台主机启用 | `modules/features/` |
| 只对某台机器成立（硬件、GPU、分区、持久化、专属包/服务） | `modules/hosts/<Host>/` |
| 多台主机共同的组合集合 | `modules/profiles.nix` |
| flake-parts 自身引导 | `modules/flake-parts.nix` |
| 纯数据（不是模块，例如 umbriel 配置） | `config/` |
| agenix 密文 | `secrets/` |
| agenix CLI 规则 | `agenix-rules.nix`（必须在根目录） |

- `modules/hosts/<Host>/hardware-configuration.nix` 只允许放 `nixos-generate-config`
  生成的内容。手写的硬件相关配置放 `modules/hosts/<Host>/<aspect>.nix`
  （例如 `boot.nix`、`graphics.nix`）。

## 配置边界

判断应用配置该不该写进 Nix，看应用能不能自己保存设置：

- 有图形设置界面、或能在应用内改设置的应用（fcitx5-configtool、noctalia 设置、
  Steam、浏览器、qbittorrent、zed、denial 等）：不用 Nix 锁它的设置文件。
- 没有图形设置界面、只能改配置文件的应用（mpv、kitty、fish、yazi、swayimg、
  umbriel、mihomo 等）：设置写进 Nix，只写与上游默认不同的部分。
- 例外：KDE 的 `kdeglobals` 由 GUI 写入，但本机不用 KDE 设置界面，只借它设置主题；
  文件已持久化且可写，`qt.kde.settings` 保留。
- 例外：nvim 的 LazyVim 要在运行时写锁文件，保持用户目录管理，不迁进 Nix。
- 应用配置写进 Nix 后，从 `persistence.nix` 移除对应目录；只读 store 链接会让
  GUI 保存失败，发现 GUI 应用的配置是 store 链接就是 bug。

## 命名

- 目录小写 kebab-case；唯一例外 `modules/hosts/<Host>/` 用 PascalCase，必须等于
  `networking.hostName`。
- 文件名小写 kebab-case、单数；**文件名 = 模块名**：
  - `features/networking.nix` → `flake.modules.nixos.networking`
  - `features/shell/fish.nix` → `flake.modules.homeManager.fish`
  - `hosts/Mech/filesystem.nix` → `flake.modules.nixos.MechFilesystem`
  - `hosts/Mech/default.nix` → `flake.modules.nixos.Mech`（入口）
- 单模块不要用 `xxx/default.nix`；目录本身是入口时才用 `default.nix`。
- 类别目录只用于多模块领域：`desktop/`、`hardware/`、`shell/`。

## 模块注册与组合

- 新增公共特性：`modules/features/<name>.nix`，定义 `flake.modules.nixos.<name>` 或
  `flake.modules.homeManager.<name>`；要全局启用就在 `modules/profiles.nix` 对应
  层级加一行。
- 新增主机：建 `modules/hosts/<Name>/default.nix` 定义 `flake.modules.nixos.<Name>`；
  `machine.nix` 自动发现（目录名 = 模块名，且必须有 `default.nix`）。
- 主机专属用户配置：`flake.modules.homeManager.<Host>`。
- 一个文件定义多个模块时：按 class 排，**NixOS 在前、homeManager 在后**，同类按名字
  母序。
- 未 `git add` 的新文件不会被 flake 看到；构建前先 `git add`。

## 排序规则

排序分三类，不要混：

### 1. 模块选项（NixOS / home-manager 的 option）——按功能主次，不按字母

模块顶层按层级：

```
启动/硬件 → 网络 → 安全/身份 → 包管理/环境 → 本地化
→ 服务/系统 → 系统级程序 → 虚拟化 → 用户层
```

`imports` 永远第一。

单个选项内部的键按：

```
开关(enable) → 实现(package) → 身份与位置(user/group/dataDir/cacheDir/homeDirectory/workspace)
→ 端点(port/listenAddress/openFirewall) → 内容(settings/config/profile/profiles/scripts/plugins/mode)
→ 集成(systemd/serviceConfig/unitConfig/wantedBy) → 其他（就近放置，不强行字母序）
```

`enable` 永远第一。没有 `enable` 的（如 `hardware.nvidia`）按“实现 → 核心开关 →
子功能 → 边角”。

聚合器（`profiles.nix`、`hosts/*/default.nix`）的 `imports` 按层级分组，
组间用空行分隔，不加标题注释。

### 2. 应用自己的配置——按字母

- `programs.<应用>.settings`、`programs.mpv.config`、`config/` 下的应用配置，键按字母。
- 包列表（`home.packages`、`environment.systemPackages`、`extraPackages`）按字母。
- 路径映射（`home.file`、`xdg.configFile`、`xdg.dataFile`、`environment.etc`）按路径
  字母。
- 持久化 `directories` / `files` 按字母，`{ directory = ...; }` 按 directory。

### 3. 不排序（顺序即语义）

`PATH` 优先级、端口、`systemd` 的 after/before/requires、`kernelParams`、
`substituters`、`boot.blacklistedKernelModules` 等。

字母序统一用 `LC_ALL=C sort -f`（点文件在前）。

## let 与注释

- `let` 只用于：同一值多处复用（agenix 公钥、`fm`、Mech 的 UUID），或真正的中间
  计算（`hostNames`）。只有一个使用点的值不要包成变量。
- 字体只在 `gtk.font` 声明一次；`kdeglobals` 的 `font`/`menuFont`/`toolBarFont`/
  `activeFont` 用 `family,size` 短格式（`QFont::fromString` 只认 1、2 或 10–17 段），
  内联 `config.gtk.font.name`/`config.gtk.font.size`，`smallestReadableFont` 用
  `size - 2`，等宽字体直接写 `fixed`；不抽 `let`，也不要抄 KDE 生成的整串
  `QFont::toString()`。
- **不要主动加注释。** 只有解释非显然的约束、踩坑原因、外部耦合时才写，通常 1–2 行。
- 禁止写：文件头、分组/分区标题（如 `# 系统基础`）、编号步骤、复述代码、格式约定、
  设计取舍的长篇论证。约定写本文件，决策写提交信息。
- 反例：`# 设置用户名`、`# 系统级持久化`、`# 按字母序排列`。
  正例：`# 用 !include 而不是 nix.settings.access-tokens：...`。

## 密文

- `secrets/<name>.age` 扁平存放，不建子目录。
- 三者基名一致：`secrets/<name>.age` ↔ `age.secrets."<name>"` ↔ `/run/agenix/<name>`。
- `agenix-rules.nix` 条目按密文路径字母序，接收者用 `admin`/`mech`/`legion` 变量。
- 改密文用 `agenix -e`；不要提交明文。

## hardware / fileSystems 与 impermanence

- `hardware-configuration.nix` 只放生成内容，手写项移出去。
- `fileSystems` 是跨模块合并的 attrset：不同路径不冲突；同一路径重复定义必须用
  `lib.mkForce` 明确覆盖（Legion 的 `/` 就是 hardware 的 xfs 被 impermanence 用
  `lib.mkForce` 覆盖成 tmpfs）。
- 设备 UUID 只写在 `hardware-configuration.nix`：Mech 的 `/persistent`、`/persist-home`
  从 `config.fileSystems` 的 `/`、`/home` 派生。例外是 Legion 的 `/persistent` 与
  hardware 的 `/` 同分区但根被换成了 tmpfs，换盘要改两处。
- 不用磁盘 swap（`swapDevices = lib.mkForce [ ]`，swap 由 zram-generator 提供）写在
  host 的 impermanence 模块里，不写进生成的 hardware-configuration.nix。
- `hardware-configuration.nix` 里的 `fileSystems.*.options` 是生成时从挂载状态读的，
  不是手写默认值，一般不用动。

## 修改后的验证

```sh
git add -A                     # 新文件必须先入 git，flake 才看得到
nix flake check --no-write-lock-file
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
```

判断是否只是“排版改动”：

- 纯顺序/注释调整应保持 **system store path 不变**；变了就说明有语义变化，要查。
- 涉及持久化时，比较两台机器 `etc/systemd/system` 下 `persist-*` 与
  `home-aohg-*` 单元集合是否一致。
- 包集合用 `nix store diff-closures <旧> <新>` 确认没有增删。
- 修改密码/密钥相关时检查 `age.secrets."<name>".path` 与 `mihomo.service` 的
  `LoadCredential`。

## 常见坑

- 忘了 `git add`：`error: Path '...' is not tracked by Git`。
- 在 `profiles.nix` 重排 imports 时漏模块 → 包闭包会少东西（曾发生，丢了
  audio/bluetooth/tuning）。
- `nixfmt` 会把整个仓库重排，不要未经允许全量跑；`nix fmt` 由人决定。
- `config/umbriel/` 是纯数据，不被 import-tree 收集，改它不会产生新模块。
- portal 配置（`umbriel-portals.conf`）是 umbriel 专属，放
  `modules/features/desktop/umbriel.nix` 的 homeManager 模块里，用 `xdg.configFile`
  手写。不要改用 home-manager 的 `xdg.portal.config`：它需要开启 `xdg.portal.enable`，
  会把 portal 栈装进用户 profile、改写 `NIX_XDG_DESKTOP_PORTAL_DIR`，却只生成同一个
  文件。
