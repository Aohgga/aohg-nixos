# AGENTS.md

这是写给之后改这个仓库的人（也包括 AI）的规则，动手前先读完。

## 仓库模型

- 用 Dendritic Pattern + flake-parts：`modules/` 下每个 `.nix` 都是一个 flake-parts
  模块，`import-tree` 会自动把它们收成 `flake.modules.<class>.<name>`。
- `flake.nix` 只声明 inputs 和 `mkFlake` 启动，不写系统配置。
- 组合模块靠 `flake.modules`：主机和聚合器用 `imports` 引用，不要直接
  `import ./文件`。
- `flake.modules` 来自 flake-parts 官方 extras（`flakeModules.modules`）；
  `nix flake check` 报 `unknown flake output 'modules'` 是正常提示。

## 目录职责

| 内容 | 位置 |
| --- | --- |
| 跟机器无关、多台机器都能用 | `modules/features/` |
| 只对某台机器成立（硬件、GPU、分区、持久化、专属包/服务） | `modules/hosts/<Host>/` |
| 多台机器共用的组合 | `modules/profiles.nix` |
| flake-parts 自己的启动文件 | `modules/flake-parts.nix` |
| 纯数据（不是模块，比如 umbriel 配置） | `config/` |
| agenix 密文 | `secrets/` |
| agenix CLI 规则 | `agenix-rules.nix`（必须放根目录） |

- `modules/hosts/<Host>/hardware-configuration.nix` 只放 `nixos-generate-config`
  生成的内容。手写的硬件配置放到同目录的 `<aspect>.nix`（比如 `boot.nix`、
  `graphics.nix`）。

## 配置边界

判断一份应用配置该不该写进 Nix，就看这个应用能不能自己保存设置：

- 有图形设置界面、或者能在应用里改设置的（fcitx5-configtool、noctalia 设置、
  Steam、浏览器、qBittorrent、zed、denial 等）：不要用 Nix 锁它的设置文件。
- 没有图形界面、只能改配置文件的（mpv、kitty、fish、yazi、swayimg、umbriel、
  mihomo 等）：设置写进 Nix，而且只写跟上游默认不一样的部分。
- 例外：KDE 的 `kdeglobals` 虽然是 GUI 写的，但我不用 KDE 设置界面，只拿它设主题；
  这个文件已经持久化、可写，所以 `qt.kde.settings` 保留。
- 例外：nvim 的 LazyVim 运行时还要写锁文件，继续放在用户目录里，不搬进 Nix。
- 应用配置搬进 Nix 后，记得从 `persistence.nix` 里删掉对应目录；只读的 store
  链接会让 GUI 保存失败，看到 GUI 应用的配置是 store 链接就是 bug。

## 命名

- 目录用小写 kebab-case；只有 `modules/hosts/<Host>/` 用 PascalCase，而且必须和
  `networking.hostName` 一样。
- 文件名用小写 kebab-case、单数；**文件名就是模块名**：
  - `features/networking.nix` → `flake.modules.nixos.networking`
  - `features/shell/fish.nix` → `flake.modules.homeManager.fish`
  - `hosts/Mech/filesystem.nix` → `flake.modules.nixos.MechFilesystem`
  - `hosts/Mech/default.nix` → `flake.modules.nixos.Mech`（入口）
- 单个模块不要用 `xxx/default.nix`；只有目录本身是入口时才用 `default.nix`。
- 分类目录只给确实有多个模块的领域用：`desktop/`、`hardware/`、`shell/`。

## 模块注册与组合

- 加公共特性：在 `modules/features/<name>.nix` 里定义
  `flake.modules.nixos.<name>` 或 `flake.modules.homeManager.<name>`；要全局启用，
  就在 `modules/profiles.nix` 的对应层加一行。
- 加新主机：建 `modules/hosts/<Name>/default.nix`，定义
  `flake.modules.nixos.<Name>`；`machine.nix` 会自动发现（目录名 = 模块名，
  并且必须有 `default.nix`）。
- 主机专属的用户配置：`flake.modules.homeManager.<Host>`。
- 一个文件里定义多个模块时：按 class 排，**NixOS 在前、homeManager 在后**，
  同类按名字排序。
- 新文件没 `git add` 的话 flake 看不到；构建前先 `git add`。

## 排序规则

排序分三类，不要混着用：

### 1. 模块选项（NixOS / home-manager 的 option）——按功能主次，不按字母

模块顶层按这个顺序：

```
启动/硬件 → 网络 → 安全/身份 → 包管理/环境 → 本地化
→ 服务/系统 → 系统级程序 → 虚拟化 → 用户层
```

`imports` 永远放最前面。

单个选项内部的键按：

```
开关(enable) → 实现(package) → 身份与位置(user/group/dataDir/cacheDir/homeDirectory/workspace)
→ 端点(port/listenAddress/openFirewall) → 内容(settings/config/profile/profiles/scripts/plugins/mode)
→ 集成(systemd/serviceConfig/unitConfig/wantedBy) → 其他（就近放，不强行字母序）
```

`enable` 永远第一。没有 `enable` 的（比如 `hardware.nvidia`）按“实现 → 核心开关 →
子功能 → 边角”排。

聚合器（`profiles.nix`、`hosts/*/default.nix`）的 `imports` 按层级分组，组之间空一行，
不要加标题注释。

### 2. 应用自己的配置——按字母

- `programs.<应用>.settings`、`programs.mpv.config`、`config/` 下的应用配置，键按字母。
- 包列表（`home.packages`、`environment.systemPackages`、`extraPackages`）按字母。
- 路径映射（`home.file`、`xdg.configFile`、`xdg.dataFile`、`environment.etc`）按路径
  字母。
- 持久化的 `directories` / `files` 按字母，`{ directory = ...; }` 按 directory。

### 3. 不排序（顺序就是语义）

`PATH` 优先级、端口、`systemd` 的 after/before/requires、`kernelParams`、
`substituters`、`boot.blacklistedKernelModules` 等。

字母序统一用 `LC_ALL=C sort -f`（点文件排在前面）。

## let 与注释

- `let` 只在两种情况下用：同一个值要用好几处（agenix 公钥、`fm`、Mech 的 UUID），
  或者确实要做中间计算（`hostNames`）。只用一次的值不要包成变量。
- 字体只在 `gtk.font` 写一次；`kdeglobals` 的 `font`/`menuFont`/`toolBarFont`/
  `activeFont` 用 `family,size` 短格式（`QFont::fromString` 只认 1、2 或 10–17 段），
  直接内联 `config.gtk.font.name`/`config.gtk.font.size`，`smallestReadableFont` 用
  `size - 2`，等宽字体直接写 `fixed`；不要另抽 `let`，也不要抄 KDE 生成的整串
  `QFont::toString()`。
- **不要主动加注释。** 只有解释不显然的约束、踩过的坑、外部耦合时才写，一般 1–2 行。
- 不要写：文件头、分组/分区标题（比如 `# 系统基础`）、编号步骤、复述代码、格式约定、
  设计取舍的长篇论证。约定写本文件，决策写提交信息。
- 反例：`# 设置用户名`、`# 系统级持久化`、`# 按字母序排列`。
  正例：`# 用 !include 而不是 nix.settings.access-tokens：...`。

## 密文

- `secrets/<name>.age` 平铺存放，不建子目录。
- 三个名字保持一致：`secrets/<name>.age` ↔ `age.secrets."<name>"` ↔ `/run/agenix/<name>`。
- `agenix-rules.nix` 的条目按密文路径字母序，接收者用 `admin`/`mech`/`legion` 变量。
- 改密文用 `agenix -e`；不要提交明文。

## hardware / fileSystems 与 impermanence

- `hardware-configuration.nix` 只放生成的内容，手写项移出去。
- `fileSystems` 是跨模块合并的 attrset：不同路径不冲突；同一路径重复定义必须用
  `lib.mkForce` 明确覆盖（Legion 的 `/` 就是 hardware 里的 xfs 被 impermanence 用
  `lib.mkForce` 覆盖成 tmpfs）。
- 设备 UUID 只写在 `hardware-configuration.nix`：Mech 的 `/persistent`、`/persist-home`
  从 `config.fileSystems` 的 `/`、`/home` 派生。例外是 Legion 的 `/persistent`，
  它和 hardware 的 `/` 是同一个分区，但根被换成了 tmpfs，换盘要改两处。
- 不用磁盘 swap（`swapDevices = lib.mkForce [ ]`，swap 交给 zram-generator）写在
  host 的 impermanence 模块里，不写进生成的 hardware-configuration.nix。
- `hardware-configuration.nix` 里的 `fileSystems.*.options` 是生成时从挂载状态读的，
  不是手写默认值，一般不用动。

## 修改后的验证

```sh
git add -A                     # 新文件先入 git，flake 才看得到
nix flake check --no-write-lock-file
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
```

判断是不是只改了排版：

- 纯顺序/注释调整应该保持 **system store path 不变**；变了就说明有语义变化，要查。
- 涉及持久化时，比较两台机器 `etc/systemd/system` 下 `persist-*` 和
  `home-aohg-*` 单元集合是否一致。
- 包集合用 `nix store diff-closures <旧> <新>` 确认没有增删。
- 改密码/密钥相关时，检查 `age.secrets."<name>".path` 和 `mihomo.service` 的
  `LoadCredential`。

## 常见坑

- 未经允许不要改结构：只该加一行或改一个值时，就只动那一行；不要把
  `foo.bar = [...]` 改成嵌套 attrset，也不要顺手重排、重命名。结构变了即使
  求值结果一样也算越界，先问；结构一动，commit 的 diff 就会变成整块重写，
  很难看出真正改了什么。
- 忘了 `git add`：`error: Path '...' is not tracked by Git`。
- 在 `profiles.nix` 重排 imports 时漏模块 → 包闭包会少东西（发生过，丢了
  audio/bluetooth/tuning）。
- `nixfmt` 会把整个仓库重排，没得到允许不要全量跑；`nix fmt` 由人决定。
- `config/umbriel/` 是纯数据，不会被 import-tree 收集，改它不会产生新模块。
- portal 配置（`umbriel-portals.conf`）是 umbriel 专用的，放在
  `modules/features/desktop/umbriel.nix` 的 homeManager 模块里，用 `xdg.configFile`
  手写。不要改用 home-manager 的 `xdg.portal.config`：它需要开 `xdg.portal.enable`，
  会把 portal 栈装进用户 profile、改写 `NIX_XDG_DESKTOP_PORTAL_DIR`，结果只生成同一个
  文件。
