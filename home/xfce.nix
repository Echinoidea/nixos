{ config, pkgs, chicago95, ... }:
{
  # Install Chicago95 theme
  home.packages = [ chicago95 ];
  
  # Configure XFCE to use Chicago95
  xfconf.settings = {
    xfwm4 = {
      "general/theme" = "Chicago95";
      "general/title_font" = "Sans Bold 8";
      "general/button_layout" = "O|HMC";
    };
    
    xsettings = {
      "Net/ThemeName" = "Chicago95";
      "Net/IconThemeName" = "Chicago95";
      "Gtk/FontName" = "Sans 9";
    };
    
    # Panel configuration for Windows 95 look
    xfce4-panel = {
      "panels" = [ 1 ];
      "panels/panel-1/position" = "p=8;x=0;y=0";  # p=8 is bottom, p=6 is top
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/length" = 100;
      "panels/panel-1/size" = 30;
      "panels/panel-1/autohide-behavior" = 0;
      "panels/panel-1/background-style" = 0;
      "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 ];
      
      # Start menu button (applications menu)
      "plugins/plugin-1" = "applicationsmenu";
      "plugins/plugin-1/button-title" = "Start";
      "plugins/plugin-1/show-button-title" = true;
      
      # Separator
      "plugins/plugin-2" = "separator";
      "plugins/plugin-2/style" = 0;
      
      # Window buttons (taskbar)
      "plugins/plugin-3" = "tasklist";
      "plugins/plugin-3/flat-buttons" = false;
      "plugins/plugin-3/show-labels" = true;
      
      # Separator
      "plugins/plugin-4" = "separator";
      "plugins/plugin-4/expand" = true;
      "plugins/plugin-4/style" = 0;
      
      # System tray
      "plugins/plugin-5" = "systray";
      
      # Clock
      "plugins/plugin-6" = "clock";
      "plugins/plugin-6/digital-format" = "%I:%M %p";
    };
    
    # Desktop settings
    xfce4-desktop = {
      "desktop-icons/style" = 2;  # Windows 95 style icons
      "desktop-icons/icon-size" = 48;
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
    font = {
      name = "Sans";
      size = 9;
    };
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Chicago95_Cursor_Black";
    package = chicago95;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
