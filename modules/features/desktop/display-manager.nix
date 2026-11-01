{
  flake.modules.nixos.display-manager = {
    services.displayManager = {
      plasma-login-manager.enable = true;
      autoLogin = {
        enable = true;
        user = "aohg";
      };
      defaultSession = "umbriel";
    };
  };
}
