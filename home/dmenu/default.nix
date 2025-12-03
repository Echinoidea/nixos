{pkgs, ...}:
let 
    dmenu = pkgs.dmenu.overrideAttrs (old: {
      version = "5.3";
      src = pkgs.fetchurl {
        url = "https://dl.suckless.org/tools/dmenu-5.3.tar.gz";
        sha256 = "sha256-Go9T5v0tdJg57IcMXiez4U2lw+6sv8uUXRWeHVQzeV8=";
      };
    
      patches = [
        ./patches/dmenu-center-5.2.diff
        ./patches/dmenu-xresources-4.9.diff
        # ./patches/dmenu-png-images-5.3.diff
        # ./patches/dmenu-fuzzymatch-5.3.diff
        # ./patches/dmenu-fuzzyhighlight-5.3.diff
        # ./patches/dmenu-tmenu-5.2.diff
      ];
    }
  );
in
{
  home.packages = [ dmenu ];
}
