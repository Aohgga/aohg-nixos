{
  flake.modules.nixos.audio = {
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };

    local.persistence.home.directories = [ ".local/state/wireplumber" ];
  };
}
