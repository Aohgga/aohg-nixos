{
  layer_rule = [
    {
      blur = true;
      blur_ignore_alpha = 0.5;
      blur_optimized = false;
      blur_popups = true;
      match = {
        namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
      };
    }
    {
      blur = true;
      blur_ignore_alpha = 0.5;
      blur_optimized = false;
      blur_popups = true;
      match = {
        namespace = "vicinae";
      };
    }
  ];
}
