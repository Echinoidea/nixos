{config, pkgs, ...}:
{
  xsession.windowManager.bspwm = {
    enable = true;

    settings = {
      border_width = 2;
      window_gap = 8;
      pointer_follows_focus = true;
      pointer_follows_monitor = true;
      focus_follows_pointer = true;
      split_ratio = 0.52;
      borderless_monocle = true;
      gapless_monocle = true;
      top_padding = 36;
    };
    
    rules = {
      "Emacs:emenu-drun" = {
        state = "floating";
        center = true;
        rectangle = "800x200+0+0";
      };
      "Emacs:emenu-url" = {
        state = "floating";
        center = true;
        rectangle = "800x200+0+0";
      };
    };
    
    extraConfig = ''
      pkill sxhkd
      sxhkd &
      xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --output DP-1 --mode 2560x1440 --rate 143.97 --pos 1920x0
      # ~/.config/sxhkd/scripts/start-sxhkd.sh &
      xset r rate 300 30
      # source ~/.cache/wal/colors
      xsetroot -cursor_name left_ptr
      ~/.fehbg &
      picom &

      bspc config border_width 2
      bspc config window_gap 8
      bspc config pointer_follows_focus true
      bspc config pointer_follows_monitor true
      bspc config focus_follows_pointer true
      bspc config split_ratio 0.52
      bspc config borderless_monocle true
      bspc config gapless_monocle true
      bspc config top_padding 26

      dunst &

      if xrandr -q | grep -q "DP-1 connected"; then
         bspc monitor eDP-1 -d 1 2 3 4
         bspc monitor DP-1 -d 5 6 7 8
      else
         bspc monitor eDP-1 -d 1 2 3 4 5
      fi
      unclutter -idle 1 -jitter 2 -root &
    '';
  };

    home.activation.reloadBspwmConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if pgrep -x bspwm >/dev/null; then
      # Source the bspwmrc to reload settings (but extraConfig won't re-run processes)
      $DRY_RUN_CMD ${pkgs.bspwm}/bin/bspc wm -r
    fi
  '';
}
