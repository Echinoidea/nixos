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
    # ./home/xfce.nix
    ./home/firefox.nix
    ./home/kitty.nix
    # ./home/herbstluftwm.nix
    # ./home/emacs.nix
  ];

  # User packages
  home.packages = with pkgs; [
    devenv
    (pkgs.writeShellScriptBin "niri-spawn-left" ''
      #!/usr/bin/env bash
      kitty &
      sleep 0.1
      niri msg action consume-or-expel-window-left
    '')
  ];

  # services.emacs = {
  #   enable = true;
  #   package = (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs: [
  #     epkgs.treesit-grammars.with-all-grammars
  #     epkgs.vterm
  #   ]);
  #   client.enable = true;
  #   defaultEditor = true;
  #   startWithUserSession = "graphical";
  #   # socketActivation.enable = true; # This is key!
  # };

  home.sessionPath = [ "$HOME/.config/emacs/bin/" ];
}
