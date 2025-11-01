{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;

    settings = {

      main = {
        term = "xterm-256color";

        font = "Maple Mono NF:size=9";
        dpi-aware = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
