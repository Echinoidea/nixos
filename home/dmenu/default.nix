{ pkgs, ... }:
let
  dmenu = pkgs.dmenu.overrideAttrs (old: {
    src = pkgs.fetchgit {
      url = "https://github.com/Echinoidea/dmenu.git";
      rev = "HEAD";
      sha256 = "sha256-Xy/jCV99ArVDRBUIJmzY75FKgSHfZbhZYkzGvVxVU1Y=";
    };
    # version = "4.9";
    # src = pkgs.fetchurl {
    #   url = "https://dl.suckless.org/tools/dmenu-4.9.tar.gz";
    #   sha256 = "sha256-s5cfTzVEdqN7KvtJhpNkkAmyAVULDHyI6GavgTK2SUU=";
    # };

    # patches = [
    #   ./patches/dmenu-center-4.8.diff
    #   ./patches/dmenu-xresources-4.9.diff
    #   # ./patches/dmenu-png-images-5.3.diff
    #   # ./patches/dmenu-fuzzymatch-5.3.diff
    #   # ./patches/dmenu-fuzzyhighlight-5.3.diff
    #   # ./patches/dmenu-tmenu-5.2.diff
    # ];
  });
in
{
  home.packages = [ dmenu ];
}
