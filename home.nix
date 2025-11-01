{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    ./home/git.nix
    ./home/zsh.nix
    ./home/foot.nix
    ./home/fastfetch.nix
  ];

  # User packages
  home.packages = with pkgs; [ ];

  # Dotfile management
  home.file = {
    # ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
    # ".config/bspwm/bspwmrc".source = ./dotfiles/bspwmrc;
    # etc...
  };

  # # Or use programs.* for supported apps
  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     # your alacritty config in nix
  #   };
  # };
}
