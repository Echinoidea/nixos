{ config, pkgs, ... }:

{
  # Install required packages
  home.packages = with pkgs; [
    sxhkd
    xdotool
    wmctrl
    maim
  ];

  # sxhkd configuration
  home.file.".config/sxhkd/sxhkdrc".text = ''
    #
    # XFCE + sxhkd hotkeys (niri-inspired)
    #

    # Terminal emulator
    super + Return
      foot

    # Application launcher
    super + d
      

    # Close window
    super + w
      xdotool getactivewindow windowkill

    # Reload sxhkd
    super + Escape
      pkill -USR1 -x sxhkd

    #
    # Window focus/movement (vim-like)
    #

    # Cycle windows (j/k for up/down in stack)
    super + {j,k}
      xdotool key {alt+Tab,alt+shift+Tab}

    # Focus left/right workspace
    super + {h,l}
      xdotool set_desktop --relative {-1,1}

    # Move window between workspaces left/right
    super + shift + {h,l}
      xdotool getactivewindow set_desktop_for_window $(xdotool getactivewindow) \
        $(($(xdotool get_desktop) {-,+} 1))

    # Move window up/down in stack (swap)
    super + shift + {j,k}
      xdotool key {alt+shift+Tab,alt+Tab}

    #
    # Window states
    #

    # Fullscreen
    super + shift + f
      wmctrl -r :ACTIVE: -b toggle,fullscreen

    # Maximize
    super + f
      wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz

    # Toggle floating (unmaximize)
    super + v
      wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz

    #
    # Workspace navigation
    #

    # Switch to workspace 1-9
    super + {1-9}
      xdotool set_desktop {0-8}

    # Move window to workspace 1-9
    super + shift + {1-9}
      xdotool getactivewindow set_desktop_for_window $(xdotool getactivewindow) {0-8}

    # Focus next/previous workspace
    super + {u,i}
      xdotool set_desktop --relative {-1,1}

    # Move window to next/previous workspace
    super + ctrl + {u,i}
      xdotool getactivewindow set_desktop_for_window $(xdotool getactivewindow) \
        $(($(xdotool get_desktop) {-,+} 1))

    #
    # Window resizing
    #

    # Tile window to half screen
    super + alt + h
      wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && \
      wmctrl -r :ACTIVE: -e 0,0,0,960,1080

    super + alt + l
      wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && \
      wmctrl -r :ACTIVE: -e 0,960,0,960,1080

    #
    # Screenshots
    #

    Print
      maim ~/Pictures/screenshots/xfce/Screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png

    ctrl + Print
      maim -i $(xdotool getactivewindow) ~/Pictures/screenshots/xfce/Screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png

    alt + Print
      maim -s ~/Pictures/screenshots/xfce/Screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png

    #
    # Media keys
    #

    XF86AudioRaiseVolume
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+

    XF86AudioLowerVolume
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-

    XF86AudioMute
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    XF86AudioMicMute
      wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    XF86MonBrightnessUp
      brightnessctl --class=backlight set +10%

    XF86MonBrightnessDown
      brightnessctl --class=backlight set 10%-

    #
    # Lock screen
    #

    super + alt + l
      xflock4

    #
    # Custom keychords
    #

    # dmenu M-x
    super + x
      ~/dmenu-scripts/dmenu-m-x.sh

    # Help overlay
    super + shift + slash
      ~/.config/sxhkd/scripts/sxhkd-help.sh
  '';

  # Autostart sxhkd
  home.file.".config/autostart/sxhkd.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=sxhkd
    Exec=${pkgs.sxhkd}/bin/sxhkd
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
  '';

  # Create screenshots directory
  home.activation.createScreenshotDir = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/Pictures/screenshots/xfce
  '';
}
