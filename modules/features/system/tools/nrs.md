# nrs 使用指南

`nrs` 是 `nixos-rebuild` + `nix-output-monitor`（nom）的包装，默认作用于本机配置。

- 配置目录：`$HOME/.config/aohg-nixos`
- 默认主机：当前 `hostname`（`Mech` / `Legion`）

## 基本用法

```sh
nrs                 # 构建并切换（默认 switch）
nrs boot            # 构建并设为下次启动
nrs test            # 构建并临时激活（不写 boot）
nrs build           # 只构建
nrs dry-activate    # 只模拟激活
```

额外参数会透传给 `nixos-rebuild`：

```sh
nrs build --print-out-paths
nrs switch --show-trace
```

## 维护命令

| 命令 | 作用 |
|---|---|
| `nrs update` | 更新 `flake.lock`（`nix flake update`） |
| `nrs check` | 检查配置能否求值（`nix flake check`） |
| `nrs write-flake` | 从模块的 `flake-file.inputs` 重新生成 `flake.nix` |
| `nrs help` | 显示用法 |

## 环境变量

| 变量 | 默认 | 作用 |
|---|---|---|
| `NRS_FLAKE` | `$HOME/.config/aohg-nixos` | 配置目录 |
| `NRS_HOST` | 当前 hostname | 目标主机 |
| `NRS_NOM=0` | 未设置 | 关闭 nom 渲染，直接输出原始日志 |

示例：

```sh
NRS_HOST=Legion nrs check
NRS_NOM=0 nrs build
```

## 工作流

### 日常切换

```sh
cd ~/.config/aohg-nixos
git add -A
nrs
```

### 新增或删除 flake input

```sh
# 在模块里改 flake-file.inputs...
nrs write-flake
nrs check
nrs
```

### 更新依赖

```sh
nrs update
nrs check
nrs
```

## 补全

- **fish**：`nrs <Tab>` 会列出子命令，并在右侧显示中文说明。
- **bash**：`nrs <Tab>` 只列出候选，没有说明——bash 的补全列表本身不支持在候选后显示描述。

## 注意

- `switch` / `boot` / `test` / `build` / `dry-activate` 会先执行 `sudo -v`，密码提示不会被管道吞掉。
- `update` / `check` / `write-flake` 不需要 sudo。
- `flake.nix` 是生成的，不要手改；改 `flake-file.inputs` 后跑 `nrs write-flake`。
- 改了模块文件后记得 `git add`，flake 只读取 git 跟踪的文件。
