{ config, pkgs, ... }:
{
  # Install Chicago95 theme
  home.packages = with pkgs; [
    chicago95 # This includes GTK theme, icons, and fonts
  ];

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
      package = pkgs.chicago95;
    };
    iconTheme = {
      name = "Chicago95";
      package = pkgs.chicago95;
    };
  };
}
