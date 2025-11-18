{
  xdg.configFile."bspwm/bspwmrc" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      pkill sxhkd
      sxhkd -m 1 &

      xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --output DP-1 --mode 2560x1440 --rate 144 --pos 1920x0
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

      bspc rule -a Gimp desktop='^8' state=floating follow=on
      bspc rule -a Chromium desktop='^2'

      unclutter -idle 1 -jitter 2 -root &
      /home/gabriel/dmenu-scripts-x/pywal-update.sh
    '';
  };

  xdg.configFile."eww/scripts/bspwm-workspaces.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      get_workspaces() {
          focused=$(bspc query -D -d focused --names)
          desktops=$(bspc query -D --names)
          
          workspaces="["
          first=true
          
          for desktop in $desktops; do
              if [ "$first" = false ]; then
                  workspaces="$workspaces,"
              fi
              first=false
              
              if [ "$desktop" = "$focused" ]; then
                  state="focused"
              elif [ -n "$(bspc query -N -d "$desktop")" ]; then
                  state="occupied"
              elif [ -n "$(bspc query -N -d "$desktop" -n .urgent)" ]; then
                  state="urgent"
              else
                  state="empty"
              fi
              
              workspaces="$workspaces{\"name\":\"$desktop\",\"state\":\"$state\"}"
          done
          
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
