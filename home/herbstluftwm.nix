{ config, pkgs, ... }:

{
  xdg.configFile."herbstluftwm/autostart" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh

      herbstclient set_monitors 1920x1080+0+0 2560x1440+1920+0

      hc() {
        herbstclient "$@"
      }

      hc emit_hook reload

      # Remove all existing keybindings
      hc keyunbind --all

      # Set mod key (Mod4 = Super/Windows key)
      Mod=Mod4

      # === ESSENTIAL KEYBINDS ===

      # Terminal
      hc keybind $Mod-Return spawn alacritty

      # Application launcher
      hc keybind $Mod-d spawn rofi -show drun

      # Close window
      hc keybind $Mod-w close

      # Reload config
      hc keybind $Mod-Shift-r reload

      # Quit herbstluftwm
      hc keybind $Mod-Shift-q quit

      # === FOCUS MOVEMENT ===
      hc keybind $Mod-h focus left
      hc keybind $Mod-j focus down
      hc keybind $Mod-k focus up
      hc keybind $Mod-l focus right

      # === WINDOW MOVEMENT ===
      hc keybind $Mod-Shift-h shift left
      hc keybind $Mod-Shift-j shift down
      hc keybind $Mod-Shift-k shift up
      hc keybind $Mod-Shift-l shift right

      # === SPLITTING FRAMES ===
      hc keybind $Mod-u split bottom 0.5
      hc keybind $Mod-o split right 0.5

      # Remove frame
      hc keybind $Mod-r remove

      # === RESIZING ===
      resizestep=0.05
      hc keybind $Mod-Control-h resize left +$resizestep
      hc keybind $Mod-Control-j resize down +$resizestep
      hc keybind $Mod-Control-k resize up +$resizestep
      hc keybind $Mod-Coerbstclientntrol-l resize right +$resizestep

      # === LAYOUTS ===
      hc keybind $Mod-space cycle_layout 1
      hc keybind $Mod-f fullscreen toggle
      hc keybind $Mod-Shift-f floating toggle
      hc keybind $Mod-p pseudotile toggle

      # === TAGS (WORKSPACES) ===
      tag_names=( {1..9} )
      tag_keys=( {1..9} 0 )

      hc rename default "''${tag_names[0]}" || true
      for i in ''${!tag_names[@]} ; do
        hc add "''${tag_names[$i]}"
        key="''${tag_keys[$i]}"
        if ! [ -z "$key" ] ; then
          hc keybind "$Mod-$key" use_index "$i"
          hc keybind "$Mod-Shift-$key" move_index "$i"
        fi
      done

      # Cycle through tags
      hc keybind $Mod-period use_index +1 --skip-visible
      hc keybind $Mod-comma  use_index -1 --skip-visible

      # === MOUSE BINDINGS ===
      hc mouseunbind --all
      hc mousebind $Mod-Button1 move
      hc mousebind $Mod-Button2 zoom
      hc mousebind $Mod-Button3 resize

      # === THEME ===
      hc attr theme.tiling.reset 1
      hc attr theme.floating.reset 1

      hc set frame_border_active_color '#222222'
      hc set frame_border_normal_color '#101010'
      hc set frame_bg_normal_color '#565656'
      hc set frame_bg_active_color '#345F0C'
      hc set frame_border_width 1
      hc set show_frame_decorations 'focused_if_multiple'
      hc set frame_bg_transparent on
      hc set frame_transparent_width 0
      hc set frame_gap 4

      hc attr theme.active.color '#9fbc00'
      hc attr theme.normal.color '#454545'
      hc attr theme.urgent.color orange
      hc attr theme.inner_width 1
      hc attr theme.inner_color black
      hc attr theme.border_width 3
      hc attr theme.floating.border_width 4
      hc attr theme.floating.outer_width 1
      hc attr theme.floating.outer_color black
      hc attr theme.active.inner_color '#3E4A00'
      hc attr theme.active.outer_color '#3E4A00'
      hc attr theme.background_color '#141414'

      hc set window_gap 4
      hc set frame_padding 0
      hc set smart_window_surroundings off
      hc set smart_frame_surroundings on
      hc set mouse_recenter_gap 0

      # === RULES ===
      hc unrule -F
      hc rule focus=on
      hc rule floatplacement=smart
      hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on
      hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
      hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off

      # === PANEL/BAR (optional) ===
      # Uncomment if you want to use a panel
      hc pad 0 32 # Reserve space at top for bar

      # Unlock, just to be sure
      hc unlock

      # Start compositor (optional but recommended)
      pkill picom; picom &
    '';
  };
}
