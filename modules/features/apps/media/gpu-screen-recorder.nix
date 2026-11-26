{
  flake.modules.nixos.gpu-screen-recorder = { pkgs, ... }: {
    # noctalia 的 screen_recorder 插件从 PATH 里调用 gpu-screen-recorder；KMS / region
    # 捕获依赖 setcap wrapper，所以包必须装在系统层。slurp 供 region 模式选区。
    programs.gpu-screen-recorder = {
      enable = true;
      # 6.1.7 把 portal 送来的光标位图一律按 RGBA 上传，而 umbriel 的 portal 发的是
      # BGRA，录出来的光标红蓝反了（miku 的青色头发变黄）。补丁按声明格式交换红蓝
      # 通道；上游把 pipewire_video.c 里的 TODO 修掉后可以删除。
      package = pkgs.gpu-screen-recorder.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./gpu-screen-recorder/cursor-bgra.patch ];
      });
    };
    environment.systemPackages = [ pkgs.slurp ];
  };
}
