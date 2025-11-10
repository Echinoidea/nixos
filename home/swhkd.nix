{
  xdg.configFile."swhkd/swhkdrc".text = ''
    # make sxhkd reload its configuration files:
    super + escape
    	pkexec pkill -USR1 -x swhkd

    # Enter main menu mode
    super + space
    	@enter leader && echo -n "leader" > ~/.config/waybar/swhkd-mode

    mode leader swallow oneoff

    # +emacs
    e
    	@escape && @enter emacs && echo -n "emacs" > ~/.config/waybar/swhkd-mode 
    # +dmenu
    d
    	@escape && @enter dmenu && echo -n "dmenu" > ~/.config/waybar/swhkd-mode
    # +open program
    o
    	@escape && @enter open && echo -n "open" > ~/.config/waybar/swhkd-mode
    # +dirvish
    y
    	@escape && @enter dirvish && echo -n "dirvish" > ~/.config/waybar/swhkd-mode

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Emacs menu mode
    mode emacs swallow oneoff

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
    mode dmenu swallow oneoff

    # dmenu todo
    t
    	~/dmenu-scripts/dmenu-todo.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu yt-dlp
    y
    	~/dmenu-scripts/dmenu-ytdlp.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu mpc
    m
    	~/dmenu-scripts/dmenu-mpc.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu power
    p
    	~/dmenu-scripts/dmenu-power.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu config
    c 
    	~/dmenu-scripts/dmenu-dots.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu wal
    w 
    	/home/gabriel/dmenu-scripts/dmenu-wal.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu read book with zathura
    b
    	~/dmenu-scripts/dmenu-books.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # +dmenu emacs
    e
    	@enter dmenu_emacs && echo -n "dmenu_emacs" > ~/.config/waybar/swhkd-mode 
    # dmenu notes
    n
    	~/dmenu-scripts/dmenu-notes.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # rsync backup
    s
    	~/dmenu-scripts/dmenu-rsync.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # (linux) nixos
    l
      ~/dmenu-scripts/dmenu-nix.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Dmenu Emacs submenu
    mode dmenu_emacs swallow  oneoff

    # dmenu emacs open project
    p 
    	~/dmenu-scripts/dmenu-emacs-project.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # dmenu manage emacs
    m
    	~/dmenu-scripts/dmenu-emacs-manage.sh & echo -n "normal" > ~/.config/waybar/swhkd-mode  && @escape

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Open menu mode
    mode open swallow oneoff

    # emacsclient
    e 
    	emacsclient -a \'\' -c & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # firefox
    f
    	firefox & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # discord
    d
        vesktop & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape
    # rmpc
    m
    	foot -e zsh -c 'cat ~/.cache/wal/sequences && rmpc' & echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    Escape
    	  echo -n "normal" > ~/.config/waybar/swhkd-mode && @escape

    endmode

    # Dirvish menu mode
    mode dirvish swallow oneoff

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
