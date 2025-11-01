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
      start-swhkd = "pkexec env XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_CONFIG_HOME=$XDG_CONFIG_HOME swhkd -c ~/.config/swhkd/swhkdrc;";
    };
    history.size = 10000;

    initContent = ''
      eval "$(starship init zsh)"
      (cat ~/.cache/wal/sequences &)
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
