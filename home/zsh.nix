{ config, pkgs, ... }:

{
  programs.zsh = {
    enableCompletion = true;
    autosuggest.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos#nixos";
      nrt = "sudo nixos-rebuild test --flake ~/nixos#nixos";
    };
    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };
}
