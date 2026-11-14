{
  flake.modules.nixos.LegionAudio = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    local.persistence.home.directories = [ ".local/state/wireplumber" ];
  };
}
