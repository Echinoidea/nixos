{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos#nixos";
      nrt = "sudo nixos-rebuild test --flake ~/nixos#nixos";
      nso = "sudo nix-store --optimize -vv";
      ngc = "sudo nix-collect-garbage -d";
      start-swhkd = "pkexec env XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_CONFIG_HOME=$XDG_CONFIG_HOME swhkd -c ~/.config/swhkd/swhkdrc;";
      kitty-help = ''
        echo -e "\033[1;36m════════════════════════════════════════════════════════════════\033[0m" && \
        echo -e "              \033[1;35mKitty Terminal Keybindings\033[0m                    " && \
        echo -e "\033[1;36m════════════════════════════════════════════════════════════════\033[0m" && \
        echo -e " \033[1;33mTabs\033[0m                                                          " && \
        echo -e "   \033[1;32mCtrl+Shift+T\033[0m      New Tab                                 " && \
        echo -e "   \033[1;32mCtrl+Shift+Q\033[0m      Close Tab                               " && \
        echo -e "   \033[1;32mAlt+Shift+H/L\033[0m     Previous/Next Tab                       " && \
        echo -e "   \033[1;32mCtrl+,/.\033[0m          Move Tab Backward/Forward               " && \
        echo -e "                                                                " && \
        echo -e " \033[1;33mWindows\033[0m                                                       " && \
        echo -e "   \033[1;32mCtrl+Shift+Enter\033[0m  New Window                              " && \
        echo -e "   \033[1;32mCtrl+W\033[0m            Close Window                            " && \
        echo -e "   \033[1;32mCtrl+[/]\033[0m          Previous/Next Window                    " && \
        echo -e "                                                                " && \
        echo -e " \033[1;33mSplits\033[0m                                                        " && \
        echo -e "   \033[1;32mCtrl+Shift+-\033[0m      Horizontal Split                        " && \
        echo -e "   \033[1;32mCtrl+Shift+\\\\\033[0m     Vertical Split                          " && \
        echo -e "   \033[1;32mCtrl+H/J/K/L\033[0m      Navigate Splits (Vim-style)             " && \
        echo -e "   \033[1;32mCtrl+Shift+R\033[0m      Resize Mode                             " && \
        echo -e "                                                                " && \
        echo -e " \033[1;33mOther\033[0m                                                         " && \
        echo -e "   \033[1;32mCtrl+Shift+Space\033[0m  Vim Scrollback Mode                     " && \
        echo -e "\033[1;36m════════════════════════════════════════════════════════════════\033[0m"
      '';
    };
    history.size = 10000;

    initContent = ''
      eval "$(starship init zsh)"
      # (cat ~/.cache/wal/sequences &)
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "aliases" # Use command als for alias cheatsheet
        "emacs"
        "colored-man-pages"
        "colorize"
        "history"
        "per-directory-history"
        "dirhistory" # use alt+left alt+right to navigate through dir history
      ];
    };
  };
}
