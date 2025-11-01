{ config, pkgs, ... }:

{
  # Set GTK theme preference
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=false
    gtk-theme-name=Chicago95
    gtk-icon-theme-name=Chicago95
    gtk-font-name=Sans 9
  '';
}
