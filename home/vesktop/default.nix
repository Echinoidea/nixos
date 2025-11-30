{ pkgs, ... }:
{
  stylix.targets.vesktop.enable = true;
  programs.vesktop = {
    enable = true;

    vencord.themes = {
      "system24.css" = builtins.readFile (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/refact0r/system24/main/theme/system24.theme.css";
          hash = "sha256-6Qx+10/3Nf7IF3VQmf/r76qOuHHlOOU0RpxppVe4slI=";
        }
      );
    };
    vencord.settings = {
      enabledThemes = [ "system24.css" ];
    };
  };
}
