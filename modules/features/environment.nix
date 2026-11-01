{
  flake.modules.nixos.environment = {
    environment = {
      variables = {
        EDITOR = "nvim";
        GTK_CSD = "0";
        QT_QPA_PLATFORMTHEME = "kde";
        MOZ_ENABLE_WAYLAND = "1";
      };
      sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
      };
    };
    programs.nix-ld = {
      enable = true;
    };
  };
}
