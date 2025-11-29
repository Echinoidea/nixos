{
  xdg.configFile."bspwm/bspwmrc" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      pkill sxhkd

      xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --output DP-1 --mode 2560x1440 --rate 143.97 --pos 1920x0

      emacs --daemon
      emacs --daemon=emenu

      ~/.config/sxhkd/scripts/start-sxhkd.sh &

      if xrandr -q | grep -q "DP-1 connected"; then
         eww open bar-dp1
         eww open which-key-popup-dp1
         eww open notification-window
      elif xrandr -q | grep -q "eDP-1 connected"; then
        eww open bar-edp1
        eww open which-key-popup-edp1
      fi

      ~/.config/eww/scripts/notif-listener.sh &

      xset r rate 300 30

      source ~/.cache/wal/colors
      xsetroot -cursor_name left_ptr
      ~/.fehbg &
      picom &

      if xrandr -q | grep -q "DP-1 connected"; then
         bspc monitor eDP-1 -d 1 2 3 4
         bspc monitor DP-1 -d 5 6 7 8
      else
         bspc monitor eDP-1 -d 1 2 3 4 5
      fi

      bspc rule -a Emacs:emenu-drun state=floating center=true rectangle=800x200+0+0
      bspc rule -a Emacs:emenu-url state=floating center=true rectangle=800x200+0+0

      bspc config border_width 0
      bspc config window_gap 8
      bspc config pointer_follows_focus true
      bspc config pointer_follows_monitor true
      bspc config focus_follows_pointer true
      bspc config focused_border_color "$(sed -n '3p' ~/.cache/wal/colors)"
      bspc config normal_border_color "$(sed -n '1p' ~/.cache/wal/colors)"
      bspc config split_ratio 0.52
      bspc config borderless_monocle true
      bspc config gapless_monocle true
      bspc config top_padding 36

      unclutter -idle 1 -jitter 2 -root &
      # /home/gabriel/dmenu-scripts-x/pywal-update.sh
    '';
  };

  xdg.configFile."eww/scripts/bspwm-workspaces.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      get_workspaces() {
          focused=$(bspc query -D -d focused --names)
          
          workspaces="["
          first=true
          
          # Get all monitors and their desktops
          while IFS= read -r monitor; do
              desktops=$(bspc query -D -m "$monitor" --names)
              
              for desktop in $desktops; do
                  if [ "$first" = false ]; then
                      workspaces="$workspaces,"
                  fi
                  first=false
                  
                  # Check if this desktop is focused
                  if [ "$desktop" = "$focused" ]; then
                      state="focused"
                  # Check if desktop has windows
                  elif [ -n "$(bspc query -N -d "$desktop")" ]; then
                      state="occupied"
                  # Check for urgent windows
                  elif [ -n "$(bspc query -N -d "$desktop" -n .urgent)" ]; then
                      state="urgent"
                  else
                      state="empty"
                  fi
                  
                  workspaces="$workspaces{\"name\":\"$desktop\",\"state\":\"$state\",\"monitor\":\"$monitor\"}"
              done
          done < <(bspc query -M --names)
          
          workspaces="$workspaces]"
          echo "$workspaces"
      }

      get_workspaces
      bspc subscribe desktop_focus node_add node_remove node_transfer | while read -r _; do
          get_workspaces
      done
    '';
  };
}
