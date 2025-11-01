{ config, pkgs, ... }:

{
  programs.git = {
    settings.user.name = "Gabriel Hooks";
    settings.user.email = "gabriel.i.hooks@gmail.com";
  };
}
