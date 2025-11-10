{
  home.file.".emacs-profiles.el".text = ''
    (("doom" . ((user-emacs-directory . "~/.config/emacs")
                (env . (("DOOMDIR" . "~/.config/doom")))))
     ("custom" . ((user-emacs-directory . "~/.config/emacs-custom"))))
  '';

  home.file.".emacs-profile".text = "custom"; # default profile
}
