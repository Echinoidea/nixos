{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    ./home/git.nix
    ./home/zsh.nix
    ./home/foot.nix
    ./home/fastfetch.nix
    ./home/starship.nix
    ./home/swhkd.nix
    ./home/xfce.nix
    ./home/firefox.nix
    ./home/kitty.nix
  ];

  # User packages
  home.packages = with pkgs; [ ];
}
