{
  flake.modules.nixos.display-manager = {
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "aohg";
      };
      defaultSession = "umbriel";
      plasma-login-manager.enable = true;
    };
  };
}
