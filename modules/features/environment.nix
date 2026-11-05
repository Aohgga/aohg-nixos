{
  flake.modules.nixos.environment = {
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
    };
    environment.variables = {
      EDITOR = "nvim";
      GTK_CSD = "0";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORMTHEME = "kde";
    };
    programs.nix-ld.enable = true;
  };
}
