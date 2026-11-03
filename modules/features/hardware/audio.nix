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

  flake.modules.homeManager.audio = {
    xdg.configFile."wireplumber/wireplumber.conf.d/10-bluez.conf".text = ''
      monitor.bluez.properties = {
        bluez5.codecs = [ sbc_xq sbc ]
        bluez5.enable-sbc-xq = true
        bluez5.enable-hw-volume = false
        bluez5.hw-volume = [ ]
      }
    '';
  };
}
