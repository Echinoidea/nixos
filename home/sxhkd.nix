{
  home.file.".config/sxhkd/scripts/start-sxhkd.sh" = {
    executable = true;
    text = ''
      #!/bin/sh

      # Start sxhkd with status FIFO for keychord tracking
      export XDG_RUNTIME_DIR="/run/user/1000/"
      export SXHKD_FIFO="$XDG_RUNTIME_DIR/sxhkd.fifo"

      declare -a proc=("sxhkd" "sxhkd-status-watch" "sxhkd-bindings-update")

      # Terminate existing sxhkd and related scripts
      if [[ -n $(pidof sxhkd) ]]; then
          for i in "''${proc[@]}"; do
              kill -15 "$(ps -ef \
              | grep "$i" \
              | awk 'NR==1 {print $2}')" >/dev/null 2>&1
              # Wait until the processes have been shut down
              while pidof -x "$i" >/dev/null; do
                  sleep 0.2
                  break
              done
          done
      fi

      # Remove old FIFO if it exists
      [[ -e $SXHKD_FIFO ]] && rm -f "$SXHKD_FIFO"
      sleep 0.5

      if [[ -n $(pidof bspwm) ]]; then
          # Create FIFO
          mkfifo "$SXHKD_FIFO"
          
          # Launch sxhkd with status output (-t 5 sets timeout for chord chains)
          sxhkd -t 5 \
              -s "$SXHKD_FIFO" \
              -c "$HOME/.config/sxhkd/sxhkdrc" &
          
          # Start the bindings updater
          "$HOME/.config/eww/scripts/sxhkd-bindings-update.sh" &
          
          notify-send 'sxhkd' 'hotkeys daemon ready'
      else
          exit 127
      fi

      exit
    '';
  };

  home.file.".config/sxhkd/scripts/sxhkd-status-watch.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Watch sxhkd status FIFO and output mode for eww
      # The FIFO path should match what sxhkd was started with

      XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/1000}"
      FIFO="$XDG_RUNTIME_DIR/sxhkd.fifo"

      # Initial state
      echo "normal"

      # Read from the FIFO and parse keychord state
      while IFS= read -r line; do
          # SXHKD outputs lines like:
          # H<hotkey>  - when a chord is being built (e.g., "Hsuper + space ")
          # E<hotkey>  - when a hotkey is executed
          # C<count>   - when chord ends
          
          if [[ "$line" =~ ^H ]]; then
              # Extract the hotkey being built
              hotkey="''${line#H}"
              
              # Parse the mode from the hotkey
              # "super + space " -> initial keychord state
              if [[ "$hotkey" =~ super\ \+\ space\ \;\ ([^\ ]+) ]]; then
                  # Second level chord: "super + space ; d" -> mode "d"
                  mode="''${BASH_REMATCH[1]}"
                  echo "$mode"
              elif [[ "$hotkey" =~ super\ \+\ space\ $ ]]; then
                  # First level: just "super + space " pressed
                  echo "space"
              fi
          elif [[ "$line" =~ ^E ]] || [[ "$line" =~ ^C ]]; then
              # Command executed or chord ended - return to normal
              echo "normal"
          fi
      done < "$FIFO"
    '';
  };

  # sxhkd configuration
  home.file.".config/sxhkd/sxhkdrc".text = ''
    #
    # wm independent hotkeys
    #

    # terminal emulator
    super + shift + Return
      emacsclient -s emenu -c -a ' ' --eval '(my/vterm-new)'

    super + Return
    		alacritty

    super + shift + equal
    		bsp-layout next --layouts tall,wide,rwide,grid,even,tiled,monocle

    super + shift + minus
    		bsp-layout previous --layouts tall,wide,rwide,grid,even,tiled,monocle

    super + space ; l ; t
    		bsp-layout once tall

    super + space ; l ; w
    		bsp-layout once wide

    super + space ; l ; e
    		bsp-layout once even

    super + space ; l ; g
    		bsp-layout once grid

    super + space ; l ; k
    		bsp-layout once tiled

    # program launcher
    super + space ; space
    	emacsclient -s emenu -c -F '((name . "emenu-drun") (minibuffer . only) (width . 100) (height . 1) (undecorated . t))' -e '(emenu-drun)'

    # make sxhkd reload its configuration files:
    super + ctrl + r
      pkill -USR1 -x sxhkd
    		
    #
    # bspwm hotkeys
    #

    # quit/restart bspwm
    super + alt + {q,r}
    	bspc {quit,wm -r}

    # close window 
    super + w
      bspc node -c

    # alternate between the tiled and monocle layout
    super + m
    	bspc desktop -l next

    # send the newest marked node to the newest preselected node
    super + y
    	bspc node newest.marked.local -n newest.!automatic.local

    # swap the current node and the biggest window
    super + g
    	bspc node -s biggest.window

    #
    # state/flags
    #

    # set the window state
    super + {t,shift + t,s,f}
    	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

    # set the node flags
    super + ctrl + {m,x,y,z}
    	bspc node -g {marked,locked,sticky,private}

    #
    # focus/swap
    #

    # focus the node in the given direction
    super + {_,shift + }{h,j,k,l}
    	bspc node -{f,s} {west,south,north,east}

    # focus the node for the given path jump
    super + {p,b,comma,period}
    	bspc node -f @{parent,brother,first,second}

    # focus the next/previous window in the current desktop
    super + {_,shift + }n
    	bspc node -f {next,prev}.local.!hidden.window

    # focus the next/previous OCCUPIED desktop in the current monitor
    super + bracket{left,right}
    	bspc desktop -f {prev,next}.local.occupied

    super + alt + bracket{left,right}
    	bspc desktop -f {prev,next}.local

    # Move window to the next/previous workspace and follow
    super + shift + bracket{left,right}
    	bspc node -d {prev,next}.local --follow

    # focus the last node/desktop
    super + {grave,Tab}
    	bspc {node,desktop} -f last

    # focus next monitor
    super + shift + period
      bspc monitor --focus next

    # focus prev monitor
    super + shift + comma
      bspc monitor --focus prev

    # focus the older or newer node in the focus history
    super + {o,i}
    	bspc wm -h off; \
    	bspc node {older,newer} -f; \
    	bspc wm -h on

    # focus or send to the given desktop
    super + {_,shift + }{1-9,0}
    	bspc {desktop -f,node -d} '^{1-9,10}'

    # send to desktop and follow it
    super + shift + ctrl + {1-9,0}
    	bspc node -d '^{1-9,10}' --follow

    #
    # preselect
    #

    # preselect the direction
    super + ctrl + {h,j,k,l}
    	bspc node -p {west,south,north,east}

    # preselect the ratio
    super + alt + {1-9}
    	bspc node -o 0.{1-9}

    # cancel the preselection for the focused node
    super + ctrl + space
    	bspc node -p cancel

    # cancel the preselection for the focused desktop
    super + ctrl + shift + space
    	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

    #
    # move/resize
    #

    # # rotate windows
    # super + {_, shift + } + r
    # 	bspc node @/ -C {forward,backward} --focus

    super + {_, shift + } + r
        id=$(bspc query -N -n focused); \
        bspc node @/ -C {forward,backward}; \
        bspc node $id -f

    # expand a window by moving one of its side outward
    super + alt + {h,j,k,l}
    	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

    # contract a window by moving one of its side inward
    super + alt + shift + {h,j,k,l}
    	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

    # move a floating window
    super + {Left,Down,Up,Right}
    	bspc node -v {-20 0,0 20,0 -20,20 0}


    #
    # extra
    #

    # show sxhkd help
    super + slash
    	  ~/.config/sxhkd/scripts/sxhkd-help.sh

    # maim
    super + Print
       maim ~/Pictures/screenshots/bspwm/$(date '+%Y-%m-%d_%H-%M-%S').png

    # main --select
    super + shift + @Print
       maim --select ~/Pictures/screenshots/bspwm/$(date '+%Y-%m-%d_%H-%M-%S').png

    #
    # Keychords
    #

    # dmenu M-x 
    super + x 
      ~/dmenu-scripts-x/dmenu-m-x.sh

    # emacs org agenda
    super + space ; e ; a
      emacsclient -r -e "(org-agenda-list)"

    # dmenu/emacs todo
    super + space ; d ; t
      ~/dmenu-scripts-x/dmenu-todo.sh

    # dmenu yt-dlp
    super + space ; d ; y
    		notify-send "Hello"
      # ~/dmenu-scripts-x/dmenu-ytdlp.sh

    # dmenu mpc
    super + space ; d ; m
      ~/dmenu-scripts-x/dmenu-mpc.sh

    # dmenu power
    super + space ; d ; p 
      /home/gabriel/dmenu-scripts-x/dmenu-power.sh

    # dmenu config
    super + space ; d ; c 
      ~/dmenu-scripts-x/dmenu-dots.sh

    # dmenu wal 
    super + space ; d ; w 
      /home/gabriel/dmenu-scripts-x/dmenu-wal.sh

    # dmenu record screenshare
    super + space ; d ; r 
      ~/dmenu-scripts-x/dmenu-record.sh

    # dmenu goto to window (bspwm)
    super + space ; d ; g
      ~/dmenu-scripts-x/dmenu-bspwm-goto-window.sh

    # dmenu read book with zathura
    super + space ; d ; b
          ~/dmenu-scripts-x/dmenu-books.sh

    # dmenu select soundcard
    super + space ; d ; a
          ~/dmenu-scripts-x/dmenu-soundcard.sh

    super + space ; d ; Print
          ~/dmenu-scripts-x/dmenu-screenshot.sh

    # 
    # emacs
    # 

    # emacsclient
    super + space ; o ; e 
      emacsclient -a \'\' -c


    # emacs open calendar
    super + space ; e ; c
      emacsclient -r -e \"(=calendar)\"

    # # emacs everywhere
    # super + e
    #   emacsclient --eval "(emacs-everywhere)"

    # dmenu emacs open project
    super + space ; d ; e ; p 
      ~/dmenu-scripts-x/dmenu-emacs-project.sh

    # dmenu manage emacs
    super + space ; d ; e ; m
      ~/dmenu-scripts-x/dmenu-emacs-manage.sh

    # dmenu notes
    super + space ; d ; n
      ~/dmenu-scripts-x/dmenu-notes.sh

    super + space ; e ; u
       emacsclient -s emenu -c -F '((name . "emenu-url") (minibuffer . only) (width . 100) (height . 1) (undecorated . t))' -e '(emenu-url)'


    #
    # dirvish
    # 

    # dirvish wallpapers
    super + space ; y ; w 
      emacsclient -c -e "(dirvish \"~/Pictures/wallpapers/\")"

    # dirvish documents
    super + space ; y ; d 
      emacsclient -c -e "(dirvish \"~/Documents/\")"

    # dirvish pictures
    super + space ; y ; p 
      emacsclient -c -e "(dirvish \"~/Pictures/\")"

    # dirvish books
    super + space ; y ; b 
      emacsclient -c -e "(dirvish \"~/Documents/books\")"

    # dirvish videos
    super + space ; y ; v
      emacsclient -c -e "(dirvish \"~/Videos\")"

    #
    # open program
    #

    # firefox
    super + space ; o ; f
      firefox

    # discord
    super + space ; o ; d
      vesktop

    # rmpc
    super + space ; o ; m
      kitty -e bash -c 'cat ~/.cache/wal/sequences && rmpc'


    # volume and brightness control

    # volume up
    XF86AudioRaiseVolume
      pactl set-sink-volume @DEFAULT_SINK@ +2%

    # volume down
    XF86AudioLowerVolume
      pactl set-sink-volume @DEFAULT_SINK@ -2%

    # brightness up
    XF86MonBrightnessUp
      brightnessctl set +10%

    # brightness down
    XF86MonBrightnessDown
      brightnessctl set 10%-
  '';
}
