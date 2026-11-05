{
  flake.modules.nixos.audio = {
    services = {
      pipewire = {
        alsa.enable = true;
        enable = true;
        pulse.enable = true;
      };
      pulseaudio.enable = false;
    };
  };
}
