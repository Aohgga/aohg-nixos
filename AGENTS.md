# AGENTS.md

这是写给之后修改本仓库的人（也包括 AI）的规则，动手前请先读完。

## 仓库模型

- 使用 Dendritic Pattern + flake-parts：`modules/` 下每个 `.nix` 都是 flake-parts 模块，
  `import-tree` 会自动把它们收集为 `flake.modules.<class>.<name>`。
- `flake.nix` 只声明 inputs 和 `mkFlake` 启动入口，不写系统配置。
- 组合模块依靠 `flake.modules`：主机和聚合器用 `imports` 引用，不要直接 `import ./文件`。
- `modules/flake-parts.nix` 负责把 flake-parts 和 home-manager 接入 flake：引入
  flake-parts 的 `flakeModules.modules`（提供 `flake.modules` 输出）和 home-manager
  的 flake 模块；它本身不写系统配置。
- `flake.modules` 来自 flake-parts 官方 extras（`flakeModules.modules`）；
  `nix flake check` 报 `unknown flake output 'modules'` 属于正常提示。

## 目录职责

| 内容 | 位置 |
| --- | --- |
| 与机器无关、多台机器都能用 | `modules/features/` |
| 只对某台机器成立（硬件、GPU、分区、持久化、专属包/服务） | `modules/hosts/<Host>/` |
| 多台机器共用的组合 | `modules/profiles.nix` |
| flake-parts 与 home-manager 的 flake 集成 | `modules/flake-parts.nix` |
| 纯数据（不是模块，比如 umbriel 配置） | `config/` |
| agenix 密文 | `secrets/` |
| agenix CLI 规则 | `agenix-rules.nix`（必须放在根目录） |

`modules/hosts/<Host>/hardware-configuration.nix` 只放 `nixos-generate-config` 生成的内容；
手写的硬件配置放在同目录的 `<aspect>.nix`（比如 `boot.nix`、`graphics.nix`）。

## 配置边界

判断一份应用配置该不该写进 Nix，要看应用能不能自己保存设置：

- 有图形设置界面、或能在应用内修改设置的（fcitx5-configtool、Steam、浏览器、
  qBittorrent、zed、denial 等）：不要用 Nix 锁住它的设置文件。
- 没有图形界面、只能修改配置文件的（mpv、kitty、fish、yazi、swayimg、umbriel、
  mihomo 等）：把设置写进 Nix，而且只写与上游默认值不同的部分；mihomo 的配置在
  `secrets/mihomo-config.age` 里，由 Nix 引用。
- 例外：KDE 的 `kdeglobals` 由图形界面写入，但本机不使用 KDE 设置界面，只用它设置
  主题；文件已经持久化并且可写，所以保留 `qt.kde.settings`。
- 例外：nvim 的 LazyVim 在运行时还需要写锁文件，继续放在用户目录里，不搬进 Nix。
- 例外：noctalia 的 Nix 配置写入 `~/.config/noctalia/config.toml`，只作为默认值；
  在设置界面里的修改写入 `~/.local/state/noctalia/settings.toml`，两边不会互相覆盖。
- fcitx5 自己的设置交给 fcitx5-configtool；`fcitx5/rime/default.custom.yaml` 属于 rime
  的文件配置，写进 Nix 没有问题。
- 应用配置搬进 Nix 后，要把 `persistence.nix` 里不再需要的目录删掉；应用仍然需要写入
  运行数据的目录要保留（比如 yazi 仍保留 `.config/yazi` 和 `.local/state/yazi`）。
  只读的 store 链接会让图形界面保存失败，如果 GUI 应用的配置是 store 链接，就说明有 bug。

## 命名

- 目录使用小写 kebab-case；只有 `modules/hosts/<Host>/` 使用 PascalCase，并且必须等于
  `networking.hostName`。
- 文件名使用小写 kebab-case、单数；**文件名就是模块名**：
  - `features/networking.nix` → `flake.modules.nixos.networking`
  - `features/shell/fish.nix` → `flake.modules.homeManager.fish`
  - `hosts/Mech/filesystem.nix` → `flake.modules.nixos.MechFilesystem`
  - `hosts/Mech/default.nix` → `flake.modules.nixos.Mech`（入口）
- 单个模块不要使用 `xxx/default.nix`；只有目录本身是入口时才使用 `default.nix`。
- 分类目录只给确实有多个模块的领域使用：`desktop/`、`hardware/`、`shell/`。

## 模块注册与组合

- 增加公共特性：在 `modules/features/<name>.nix` 中定义 `flake.modules.nixos.<name>` 或
  `flake.modules.homeManager.<name>`；要全局启用，就在 `modules/profiles.nix` 的对应层
  加一行。
- 增加新主机：创建 `modules/hosts/<Name>/default.nix`，定义 `flake.modules.nixos.<Name>`；
  `machine.nix` 会自动发现（目录名 = 模块名，并且必须有 `default.nix`）。
- 主机专属的用户配置：`flake.modules.homeManager.<Host>`。
- 一个文件定义多个模块时，按 class 排序：**NixOS 在前、homeManager 在后**，同类按名字
  排序。
- 新文件如果没有执行 `git add`，flake 就看不到；构建前请先 `git add`。

## 排序规则

排序只用于新写的代码或明确要求整理时；不要为了排序重排现有文件，否则 diff 会变得
难以阅读。

### 1. 模块选项——按功能主次，不按字母

模块顶层：

```
启动/硬件 → 网络 → 安全/身份 → 包管理/环境 → 本地化
→ 服务/系统 → 系统级程序 → 虚拟化 → 用户层
```

`imports` 永远放在最前面。

单个选项内部：

```
开关(enable) → 实现(package) → 身份与位置(user/group/dataDir/cacheDir/homeDirectory/workspace)
→ 端点(port/listenAddress/openFirewall) → 内容(settings/config/profile/profiles/scripts/plugins/mode)
→ 集成(systemd/serviceConfig/unitConfig/wantedBy) → 其他（就近放置，不强行字母序）
```

`enable` 永远放在第一位。没有 `enable` 的（比如 `hardware.nvidia`）按“实现 → 核心
开关 → 子功能 → 边角”排序。

聚合器（`profiles.nix`、`hosts/*/default.nix`）的 `imports` 按层级分组，组与组之间空
一行，不要加标题注释。

### 2. 应用自己的配置——按字母

- `programs.<应用>.settings`、`programs.mpv.config`、`config/` 下的应用配置，键按字母。
- 包列表（`home.packages`、`environment.systemPackages`、`extraPackages`）按字母。
- 路径映射（`home.file`、`xdg.configFile`、`xdg.dataFile`、`environment.etc`）按路径
  字母。
- 持久化的 `directories` / `files` 按字母，`{ directory = ...; }` 按 directory。

### 3. 不排序（顺序就是语义）

`PATH` 优先级、端口、`systemd` 的 after/before/requires、`kernelParams`、
`substituters`、`boot.blacklistedKernelModules` 等。

字母序统一使用 `LC_ALL=C sort -f`（点文件排在前面）。

## let 与注释

- `let` 只在同一个值要用在多处（agenix 公钥、`fm`、Mech 的 UUID），或者确实需要做
  中间计算（`hostNames`）时使用；只用一次的值不要包成变量。
- 字体只在 `gtk.font` 写一次；`kdeglobals` 的 `font`/`menuFont`/`toolBarFont`/
  `activeFont` 用 `family,size` 短格式（`QFont::fromString` 只认 1、2 或 10–17 段），
  直接内联 `config.gtk.font.name`/`config.gtk.font.size`，`smallestReadableFont` 用
  `size - 2`，等宽字体写 `fixed`；不要另外抽 `let`，也不要抄 KDE 生成的整串
  `QFont::toString()`。
- **不要主动加注释。** 只有解释不明显的约束、已知的坑、外部耦合时才写，一般 1–2 行。
- 不要写：文件头、分组/分区标题（比如 `# 系统基础`）、编号步骤、复述代码、格式约定、
  设计取舍的长篇论证。约定写在本文件，决策写在提交信息里。
- 反例：`# 设置用户名`、`# 系统级持久化`、`# 按字母序排列`。
  正例：`# 用 !include 而不是 nix.settings.access-tokens：...`。

## 密文

- `secrets/<name>.age` 平铺存放，不建子目录。
- 三个名字保持一致：`secrets/<name>.age` ↔ `age.secrets."<name>"` ↔ `/run/agenix/<name>`。
- `agenix-rules.nix` 的条目按密文路径字母序排列，接收者使用 `admin`/`mech`/`legion`
  变量。
- 修改密文使用 `agenix -e`；不要提交明文。

## hardware / fileSystems 与 impermanence

- `hardware-configuration.nix` 只放生成的内容，手写项移到其他文件。
- `fileSystems` 是跨模块合并的 attrset：不同路径不会冲突；同一路径重复定义必须用
  `lib.mkForce` 明确覆盖（Legion 的 `/` 就是 hardware 里的 xfs 被 impermanence 用
  `lib.mkForce` 覆盖成 tmpfs）。
- 设备 UUID 只写在 `hardware-configuration.nix`：Mech 的 `/persistent`、`/persist-home`
  从 `config.fileSystems` 的 `/`、`/home` 派生。例外是 Legion 的 `/persistent`，它和
  hardware 的 `/` 是同一个分区，但根被换成了 tmpfs，换盘时要改两处。
- 不使用磁盘 swap（`swapDevices = lib.mkForce [ ]`，swap 由 zram-generator 提供）写在
  host 的 impermanence 模块里，不写进生成的 hardware-configuration.nix。
- `hardware-configuration.nix` 里的 `fileSystems.*.options` 是生成时从挂载状态读取的，
  不是手写默认值，一般不需要改动。
- 不要整目录持久化 `/etc` 下由 NixOS 生成的目录（比如 `/etc/tuned`）：bind mount 会
  盖住 NixOS 生成的配置，服务可能无法启动。只持久化运行时状态文件，并确认生成的配置
  仍然存在。

## 改完怎么验证、怎么提交

```sh
git diff                       # 先确认只动了应该改的行
git add -A                     # 新文件先加入 git，flake 才能看到
nix flake check --no-write-lock-file
nix build .#nixosConfigurations.Mech.config.system.build.toplevel
nix build .#nixosConfigurations.Legion.config.system.build.toplevel
```

纯文档/注释改动不需要重新 build。

判断是否只是排版改动：

- 纯顺序/注释调整应该保持 **system store path 不变**；如果变了，说明有语义变化，
  需要检查。
- 涉及持久化时，比较两台机器 `etc/systemd/system` 下 `persist-*` 和 `home-aohg-*`
  单元集合是否一致。
- 包集合用 `nix store diff-closures <旧> <新>` 确认没有增删。
- 修改密码/密钥相关配置时，检查 `age.secrets."<name>".path` 和 `mihomo.service` 的
  `LoadCredential`。

提交：

- 只有用户明确要求提交时才 commit/push，不要顺便提交。
- 一次提交只做一件事；提交信息写清楚做了什么、为什么，不要只写“更新配置”。

## 写 AGENTS 和 README

两个文件分工不同，不要互相抄：

- `README.md` 给第一次看仓库的人：这个仓库是什么、两台机器怎么保存状态、目录结构、
  常用命令，最后指向 AGENTS。不写具体规则。
- `AGENTS.md` 给要改仓库的人（和 AI）：目录职责、命名、排序、配置边界、密文、
  持久化、验证、提交和常见坑。不写仓库导览。

写作要求：

- 用精确、易懂的书面表达，不要为了短而压缩；也不要用“要留的”“规矩”这类过于口语
  的说法。
- 术语要准确：比如 `modules/flake-parts.nix` 是“把 flake-parts 和 home-manager 接入
  flake”，不是笼统的“启动文件”。
- 新增规则前先检查是否和已有规则冲突（例如“按字母排序”和“不要重排现有文件”）；有
  冲突就写清楚适用条件。
- 目录结构、模块名、持久化范围变化时，同步更新 README 的目录树和 AGENTS 的对应条目。
- 文档改动只改相关段落，不要顺手重排全文；改完用 `git diff` 检查。

## 常见坑

- 未经允许不要改结构：如果只需要加一行或改一个值，就只动那一行；不要把
  `foo.bar = [...]` 改成嵌套 attrset，也不要顺便重排或重命名。即使求值结果相同，
  结构改动也算越界，请先询问；结构一旦改动，commit 的 diff 会变成整块重写，很难
  看出真正改了什么。
- 忘记执行 `git add`：`error: Path '...' is not tracked by Git`。
- 在 `profiles.nix` 重排 imports 时漏掉模块 → 包闭包会缺少内容（曾经发生过，丢了
  audio/bluetooth/tuning）。
- `nixfmt` 会把整个仓库重排，没有得到允许不要全量运行；`nix fmt` 由人决定。
- `config/umbriel/` 是纯数据，不会被 import-tree 收集，修改它不会产生新模块。
- `umbriel-portals.conf` 放在 `modules/features/desktop/umbriel.nix`，使用
  `xdg.configFile` 手写；不要使用 `xdg.portal.config`，它会多装一套 portal 栈并改写
  环境变量，却只生成同一个文件。
