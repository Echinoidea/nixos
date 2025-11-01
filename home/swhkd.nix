{
  xdg.configFile."swhkd/swhkdrc".text = ''
    # make sxhkd reload its configuration files:
    super + escape
    	pkexec pkill -USR1 -x swhkd

    # Enter main menu mode
    super + space
    	@enter main_menu && echo -n "main menu" > ~/.config/waybar/swhkd-mode

    mode main_menu swallow oneoff

    # Emacs submenu
    e
    	@escape && @enter emacs_menu && echo -n "emacs [c]alendar [a]genda" > ~/.config/waybar/swhkd-mode 
    # Dmenu submenu  
    d
    	@escape && @enter dmenu_menu && echo -n "dmenu" > ~/.config/waybar/swhkd-mode
    # Open submenu
    o
    	@escape && @enter open_menu && echo -n "open" > ~/.config/waybar/swhkd-mode
    # Dirvish submenu
    y
    	@escape && @enter dirvish_menu && echo -n "dirvish" > ~/.config/waybar/swhkd-mode

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Emacs menu mode
    mode emacs_menu swallow oneoff

    # emacs org agenda
    a
    	emacsclient -r -e "(org-agenda-list)" & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # emacs open calendar
    c
    	emacsclient -r -e "(=calendar)" & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Dmenu menu mode
    mode dmenu_menu swallow oneoff

    # dmenu todo
    t
    	~/dmenu-scripts/dmenu-todo.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu yt-dlp
    y
    	~/dmenu-scripts/dmenu-ytdlp.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu mpc
    m
    	~/dmenu-scripts/dmenu-mpc.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu power
    p 
    	~/dmenu-scripts/dmenu-power.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu config
    c 
    	~/dmenu-scripts/dmenu-dots.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu wal
    w 
    	/home/gabriel/dmenu-scripts/dmenu-wal.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu read book with zathura
    b
    	~/dmenu-scripts/dmenu-books.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu emacs submenu
    e
    	@enter dmenu_emacs_menu && echo -n "dmenu_emacs" > ~/.config/waybar/swhkd-mode 
    # dmenu notes
    n
    	~/dmenu-scripts/dmenu-notes.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    s
    	~/dmenu-scripts/dmenu-rsync.sh &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Dmenu Emacs submenu
    mode dmenu_emacs_menu swallow  oneoff

    # dmenu emacs open project
    p 
    	~/dmenu-scripts/dmenu-emacs-project.sh && echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu manage emacs
    m
    	~/dmenu-scripts/dmenu-emacs-manage.sh && echo -n "normal" > ~/.config/waybar/swhkd-mode  && @escape

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Open menu mode
    mode open_menu swallow oneoff

    # emacsclient
    e 
    	emacsclient -a \'\' -c & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # firefox
    f
    	firefox && echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # discord
    d
        vesktop && echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # rmpc
    m
    	foot -e zsh -c 'cat ~/.cache/wal/sequences && rmpc' &&   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Dirvish menu mode
    mode dirvish_menu swallow oneoff

    # dirvish wallpapers
    w 
    	emacsclient -c -e "(dirvish \"~/Pictures/wallpapers/\")" & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dirvish documents
    d 
    	emacsclient -c -e "(dirvish \"~/Documents/\")" &   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dirvish pictures
    p 
    	emacsclient -c -e "(dirvish \"~/Pictures/\")" &   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dirvish books
    b 
    	emacsclient -c -e "(dirvish \"~/Documents/books\")" &   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dirvish videos
    v
    	emacsclient -c -e "(dirvish \"~/Videos\")" &   echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode
  '';
}
