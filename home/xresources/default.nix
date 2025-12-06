{ config, ... }:
{
  stylix.targets.xresources.enable = true;

  xresources.properties = {
    "dmenu.foreground" = config.lib.stylix.colors.withHashtag.base05;
    "dmenu.background" = config.lib.stylix.colors.withHashtag.base00;
    "dmenu.selforeground" = config.lib.stylix.colors.withHashtag.base00;
  };
}
