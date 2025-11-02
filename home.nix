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
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "niri-spawn-left" ''
      #!/usr/bin/env bash
      kitty &
      sleep 0.1
      niri msg action consume-or-expel-window-left
    '')
  ];
}
