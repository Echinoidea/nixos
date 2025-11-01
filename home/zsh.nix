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
      ];
    };
  };
}
