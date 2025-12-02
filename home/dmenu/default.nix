{pkgs, ...}:
let 
  dmenu = pkgs.dmenu.override (
    {
      patches = [
        ./patches/dmenu-xresources-4.9.diff
        ./patches/dmenu-center-5.2.diff
        ./patches/dmenu-png-images-5.3.diff
        ./patches/dmenu-fuzzymatch-5.3.diff
        ./patches/dmenu-fuzzyhighlight-5.3.diff
        ./patches/dmenu-tmenu-5.2.diff
      ];
    }
  );
in
{
  home.packages = [ dmenu ];
}
