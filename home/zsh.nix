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
      ecnw = "emacsclient --no-window";

      fucking = "sudo";
      x = "wl-copy";
      dnb = "mpv --really-quiet https://dnbradio.com/hi.pls &";
      start-swhkd = "pkexec env XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_CONFIG_HOME=$XDG_CONFIG_HOME swhkd -c ~/.config/swhkd/swhkdrc;";
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
                  xrandr -q | grep -q "DP-1 connected" && eww open bar-dp1
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
