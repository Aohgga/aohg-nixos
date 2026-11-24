{
  flake.modules.nixos.localsend = {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };

    local.persistence.home.directories = [ ".local/share/org.localsend.localsend_app" ];
  };
}
