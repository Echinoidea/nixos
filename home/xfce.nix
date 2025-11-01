{
  config,
  pkgs,
  chicago95,
  ...
}:
{
  # Install Chicago95 theme
  home.packages = [ chicago95 ];

  # Configure XFCE to use Chicago95
  xfconf.settings = {
    xfwm4 = {
      "general/theme" = "Chicago95";
    };
    xsettings = {
      "Net/ThemeName" = "Chicago95";
      "Net/IconThemeName" = "Chicago95";
    };
  };

  # GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "Chicago95";
      package = chicago95;
    };
    iconTheme = {
      name = "Chicago95";
      package = chicago95;
    };
  };

  # Optional: cursor theme
  home.pointerCursor = {
    name = "Chicago95_Cursor_Black";
    package = chicago95;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
