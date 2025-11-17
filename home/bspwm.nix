{
  xdg.configFile."bspwm/bspwmrc".text = ''
#! /bin/sh

# ~/.config/polybar/launch.sh  &

xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --output HDMI-1 --mode 2560x1440 --rate 144 --pos 1920x0
xset r rate 300 30

# ~/.config/polybar/launch.sh &
# polybar &

# ~/.config/sxhkd/scripts/sxhkd-listener &

source ~/.cache/wal/colors

# pgrep -x sxhkd >/dev/null || /home/gabriel/.config/sxhkd/scripts/sxhkd-start &

xsetroot -cursor_name left_ptr
~/.fehbg &
picom &

if [[ $(xrandr -q | grep "HDMI-1 connected") ]]; then
   bspc monitor eDP-1 -d 1 2 3 4
   bspc monitor HDMI-1 -d 5 6 7 8
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

bspc config padding_top 20

bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium desktop='^2'
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off

# /home/gabriel/.config/sxhkd/scripts/sxhkd-start
sxhkd &
unclutter -idle 1 -jitter 2 -root &

/home/gabriel/dmenu-scripts-x/pywal-update.sh
'';
}
