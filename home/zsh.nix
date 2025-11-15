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

      # emacs
      doomreboot = "pkill emacs && doom sync && emacs && echo 'Doom Emacs synced and restarted'";
      ecnw = "emacsclient --no-window";

      hc = "herbstlufthc";
      fucking = "sudo";
      x = "wl-copy";
      dnb = "mpv --really-quiet https://dnbradio.com/hi.pls &";
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

    sessionVariables = {
      LSP_USE_PLISTS = "true";
    };

    initContent = ''
      eval "$(starship init zsh)"
      # (cat ~/.cache/wal/sequences &)

      # navigation
      cdf() {
        if [[ $# -gt 0 ]]; then
          builtin cd "$@"
        else
          local dir
          dir=$(find ''${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && builtin cd "$dir"
        fi
            }

      c() {
        local dir=$(
          zoxide query --list --score |
          fzf --height 40% --layout reverse --info inline \
              --nth 2.. --tac --no-sort --query "$*" \
              --bind 'enter:become:echo {2..}'
        ) && cd "$dir"
      }

      # read emacs projectile projects, fzf, and then cd into it (OC)
      p() {
          projects=$(emacsclient -e '(mapcar (lambda (dir) (abbreviate-file-name dir)) (projectile-relevant-known-projects))' | tr -d '()\"\n' | tr " " "\n" | sed "s/~/\/home\/$USER/g") \
          dir=$(echo -e "$projects" | fzf) && cd "$dir"
      }


      # startup
      start-eww() {
                  niri msg outputs | grep "(DP-1)" && eww open bar-dp1
                  eww open bar-edp1 && eww open notification-window && eww open nixos-info-window
      }

      bindkey '^R' fzf-history-widget
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "aliases" # Use command als for alias cheatsheet
        "colored-man-pages"
        "colorize"
        "history"
        "per-directory-history"
        "dirhistory" # use alt+left alt+right to navigate through dir history
        # "vi-mode"
        "fzf"
      ];
    };
  };
}
