{
  flake.modules.homeManager.swayimg = {
    xdg.configFile."swayimg/init.lua".text = ''
      swayimg.text.size = 16

      swayimg.viewer.set_window_background(0x99000000)
      swayimg.gallery.window_color = 0x99000000

      swayimg.viewer.on_key("q", function() swayimg.exit() end)
      swayimg.slideshow.on_key("q", function() swayimg.exit() end)
      swayimg.gallery.on_key("q", function() swayimg.exit() end)

      swayimg.viewer.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
      swayimg.gallery.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)

      swayimg.viewer.on_key("period", function() swayimg.viewer.open("next") end)
      swayimg.viewer.on_key("comma", function() swayimg.viewer.open("prev") end)
    '';
  };
}
