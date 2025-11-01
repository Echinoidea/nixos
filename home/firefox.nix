{ config, pkgs, ... }:

# Configure firefox to use chicago95 stuff when on X

{
  programs.firefox = {
    enable = true;
    
    profiles.default = {
      settings = {
        # Use system window decorations (title bar with close/minimize/maximize buttons)
        "browser.tabs.inTitlebar" = 0;
        
        # Use system theme colors
        "widget.content.gtk-theme-override" = "Chicago95";
        
        # Use system colors
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
        
        # Additional Windows 95 style tweaks
        "layout.css.prefers-color-scheme.content-override" = 2; # Light theme
      };
      
      # Optional: Install a Windows 95 Firefox theme
      # You can search for "Windows 95" themes on addons.mozilla.org
    };
  };
  
  # Set GTK theme preference when in XFCE
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=false
    gtk-theme-name=Chicago95
    gtk-icon-theme-name=Chicago95
    gtk-font-name=Sans 9
  '';
}
