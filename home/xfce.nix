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
      "general/title_font" = "Sans Bold 8";
      "general/button_layout" = "O|HMC";
    };
    xsettings = {
      "Net/ThemeName" = "Chicago95";
      "Net/IconThemeName" = "Chicago95";
      "Gtk/FontName" = "Sans 9";
    };
    # Panel configuration for Windows 95 look - one panel per monitor
    xfce4-panel = {
      "panels" = [
        1
        2
      ]; # Create two panels (adjust number for more monitors)
      # First panel (Monitor 1)
      "panels/panel-1/position" = "p=8;x=0;y=0";
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/length" = 100;
      "panels/panel-1/size" = 30;
      "panels/panel-1/autohide-behavior" = 0;
      "panels/panel-1/background-style" = 0;
      "panels/panel-1/output-name" = "Primary"; # Pin to primary monitor
      "panels/panel-1/span-monitors" = false; # Don't span across monitors
      "panels/panel-1/plugin-ids" = [
        1
        2
        3
        4
        5
        6
      ];
      # Second panel (Monitor 2)
      "panels/panel-2/position" = "p=8;x=0;y=0";
      "panels/panel-2/position-locked" = true;
      "panels/panel-2/length" = 100;
      "panels/panel-2/size" = 30;
      "panels/panel-2/autohide-behavior" = 0;
      "panels/panel-2/background-style" = 0;
      "panels/panel-2/output-name" = "Monitor-2"; # Use actual monitor name
      "panels/panel-2/span-monitors" = false;
      "panels/panel-2/plugin-ids" = [
        7
        8
        9
        10
        11
        12
      ];
      # Plugins for Panel 1
      "plugins/plugin-1" = "applicationsmenu";
      "plugins/plugin-1/button-title" = "Start";
      "plugins/plugin-1/show-button-title" = true;
      "plugins/plugin-2" = "separator";
      "plugins/plugin-2/style" = 0;
      "plugins/plugin-3" = "tasklist";
      "plugins/plugin-3/flat-buttons" = false;
      "plugins/plugin-3/show-labels" = true;
      "plugins/plugin-4" = "separator";
      "plugins/plugin-4/expand" = true;
      "plugins/plugin-4/style" = 0;
      "plugins/plugin-5" = "systray";
      "plugins/plugin-6" = "clock";
      "plugins/plugin-6/digital-format" = "%I:%M %p";
      # Plugins for Panel 2 (same layout)
      "plugins/plugin-7" = "applicationsmenu";
      "plugins/plugin-7/button-title" = "Start";
      "plugins/plugin-7/show-button-title" = true;
      "plugins/plugin-8" = "separator";
      "plugins/plugin-8/style" = 0;
      "plugins/plugin-9" = "tasklist";
      "plugins/plugin-9/flat-buttons" = false;
      "plugins/plugin-9/show-labels" = true;
      "plugins/plugin-10" = "separator";
      "plugins/plugin-10/expand" = true;
      "plugins/plugin-10/style" = 0;
      "plugins/plugin-11" = "systray";
      "plugins/plugin-12" = "clock";
      "plugins/plugin-12/digital-format" = "%I:%M %p";
    };
    # Desktop settings
    xfce4-desktop = {
      "desktop-icons/style" = 2;
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

  # Conditionally start xfce4-notifyd only in XFCE session
  systemd.user.services.xfce4-notifyd = {
    Unit = {
      Description = "XFCE notification daemon";
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=XFCE";
    };
    Service = {
      ExecStart = "${pkgs.xfce.xfce4-notifyd}/libexec/xfce4-notifyd";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
