# flake-parts 自身的引导：提供 flake.modules.<class> 命名空间，
# 以及 home-manager 的 flake 级模块。具体的 NixOS/用户配置不放这里。
{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];
}
