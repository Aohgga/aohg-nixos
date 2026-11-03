{
  flake.modules.nixos.audio = {
    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };
  };
}
