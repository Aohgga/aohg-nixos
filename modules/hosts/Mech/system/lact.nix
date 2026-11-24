{
  flake.modules.nixos.MechLact = {
    services.lact.enable = true;

    local.persistence = {
      home.directories = [ ".config/lact" ];
      system.directories = [ "/etc/lact" ];
    };
  };
}
