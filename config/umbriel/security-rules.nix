{
  security_context_rule = [
    {
      allow_globals = [
        "ext_data_control_manager_v1"
        "zwlr_data_control_manager_v1"
      ];
      match = {
        app_id = "org\\.example\\.ClipboardManager";
        sandbox_engine = "org\\.flatpak";
      };
    }
  ];
}
