{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.emacs.extraPackages = epkgs: [
    (pkgs.emacs.pkgs.treesit-grammars.with-all-grammars)
    epkgs.vterm
  ];

  programs.emacs.enable = true;

  home.file.".emacs.d/early-init.el".source = ./early-init.el;
  home.file.".emacs.d/init.el".source = ./init.el;
}
