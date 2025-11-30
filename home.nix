{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.stateVersion = "25.05";

  imports = [
    ./home/git.nix
    ./home/zsh.nix
    ./home/alacritty.nix
    ./home/fastfetch.nix
    ./home/starship.nix
    ./home/swhkd.nix
    ./home/firefox.nix
    ./home/bspwm.nix
    ./home/sxhkd.nix
    ./home/emacs
    ./home/btop
    ./home/vesktop
    ./home/zathura

    # ./home/eww.nix
    ./dev
  ];

  home.sessionPath = [ "$HOME/.config/emacs/bin/" ];
}
