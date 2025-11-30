{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.emacs.enable = true;

  programs.emacs.init = {
    enable = true;
    recommendedGcSettings = true;

    prelude = ''
      ;; Disable startup message.
      (setq inhibit-startup-message t
            inhibit-startup-echo-area-message (user-login-name))

      (setq initial-major-mode 'fundamental-mode
            initial-scratch-message nil)

      ;; Disable some GUI distractions.
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (menu-bar-mode -1)
      (setq use-dialog-box nil)
      (setq use-file-dialog nil)
      (setq initial-scratch-message "")

      ;; Set up fonts early.
      (set-face-attribute 'default
                          nil
                          :height 80
                          :family "Fantasque Sans Mono")
      (set-face-attribute 'variable-pitch
                          nil
                          :family "DejaVu Sans")

      ;; Set frame title.
      (setq frame-title-format
            '("" invocation-name ": "(:eval
                                      (if (buffer-file-name)
                                          (abbreviate-file-name (buffer-file-name))
                                        "%b"))))

      ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
      (defalias 'yes-or-no-p 'y-or-n-p)

      ;; Stop creating backup and autosave files.
      (setq make-backup-files nil
            auto-save-default nil)

      ;; Always show line and column number in the mode line.
      (line-number-mode)
      (column-number-mode)

      ;; Enable some features that are disabled by default.
      (put 'narrow-to-region 'disabled nil)

      (setq-default tab-width 2)


      ;; Trailing white space are banned!
      (setq-default show-trailing-whitespace t)

      ;; Make a reasonable attempt at using one space sentence separation.
      (setq sentence-end "[.?!][]\"')}]*\\($\\|[ \t]\\)[ \t\n]*"
            sentence-end-double-space nil)

      ;; I typically want to use UTF-8.
      (prefer-coding-system 'utf-8)

      ;; Enable highlighting of current line.
      (global-hl-line-mode 1)
      (global-word-wrap-whitespace-mode)


      ;; Improved handling of clipboard in GNU/Linux and otherwise.
      (setq select-enable-clipboard t
            select-enable-primary t
            save-interprogram-paste-before-kill t)
    '';

    # meow = {
    #   enable = true;
    #   demand = true;
    #   config = ''
    #     (defun meow-setup ()
    #       (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    #       (meow-motion-define-key
    #        '("j" . meow-next)
    #        '("k" . meow-prev)
    #        '("<escape>" . ignore))
    #       (meow-leader-define-key
    #        '("1" . meow-digit-argument)
    #        '("2" . meow-digit-argument)
    #        '("3" . meow-digit-argument)
    #        '("4" . meow-digit-argument)
    #        '("5" . meow-digit-argument)
    #        '("6" . meow-digit-argument)
    #        '("7" . meow-digit-argument)
    #        '("8" . meow-digit-argument)
    #        '("9" . meow-digit-argument)
    #        '("0" . meow-digit-argument)
    #        '("/" . meow-keypad-describe-key)
    #        '("?" . meow-cheatsheet))
    #       (meow-normal-define-key
    #        '("0" . meow-expand-0)
    #        '("9" . meow-expand-9)
    #        '("8" . meow-expand-8)
    #        '("7" . meow-expand-7)
    #        '("6" . meow-expand-6)
    #        '("5" . meow-expand-5)
    #        '("4" . meow-expand-4)
    #        '("3" . meow-expand-3)
    #        '("2" . meow-expand-2)
    #        '("1" . meow-expand-1)
    #        '("-" . negative-argument)
    #        '(";" . meow-reverse)
    #        '("," . meow-inner-of-thing)
    #        '("." . meow-bounds-of-thing)
    #        '("[" . meow-beginning-of-thing)
    #        '("]" . meow-end-of-thing)
    #        '("a" . meow-append)
    #        '("A" . meow-open-below)
    #        '("b" . meow-back-word)
    #        '("B" . meow-back-symbol)
    #        '("c" . meow-change)
    #        '("d" . meow-delete)
    #        '("D" . meow-backward-delete)
    #        '("e" . meow-next-word)
    #        '("E" . meow-next-symbol)
    #        '("f" . meow-find)
    #        '("g" . meow-cancel-selection)
    #        '("G" . meow-grab)
    #        '("h" . meow-left)
    #        '("H" . meow-left-expand)
    #        '("i" . meow-insert)
    #        '("I" . meow-open-above)
    #        '("j" . meow-next)
    #        '("J" . meow-next-expand)
    #        '("k" . meow-prev)
    #        '("K" . meow-prev-expand)
    #        '("l" . meow-right)
    #        '("L" . meow-right-expand)
    #        '("m" . meow-join)
    #        '("n" . meow-search)
    #        '("o" . meow-block)
    #        '("O" . meow-to-block)
    #        '("p" . meow-yank)
    #        '("q" . meow-quit)
    #        '("Q" . meow-goto-line)
    #        '("r" . meow-replace)
    #        '("R" . meow-swap-grab)
    #        '("s" . meow-kill)
    #        '("t" . meow-till)
    #        '("u" . meow-undo)
    #        '("U" . meow-undo-in-selection)
    #        '("v" . meow-visit)
    #        '("w" . meow-mark-word)
    #        '("W" . meow-mark-symbol)
    #        '("x" . meow-line)
    #        '("X" . meow-goto-line)
    #        '("y" . meow-save)
    #        '("Y" . meow-sync-grab)
    #        '("z" . meow-pop-selection)
    #        '("'" . repeat)
    #        '("<escape>" . ignore)))

    #     (meow-setup)
    #     (meow-global-mode 1)

    #     (setq meow-two-char-escape-sequence "jk"
    #           meow-two-char-escape-delay 0.5)

    #     (defun meow--two-char-exit-insert-state (s)
    #       (when (meow-insert-mode-p)
    #         (let ((modified (buffer-modified-p)))
    #           (insert (elt s 0))
    #           (let* ((second-char (elt s 1))
    #                  (event
    #                   (if defining-kbd-macro
    #                       (read-event nil nil)
    #                     (read-event nil nil meow-two-char-escape-delay))))
    #             (when event
    #               (if (and (characterp event) (= event second-char))
    #                   (progn
    #                     (backward-delete-char 1)
    #                     (set-buffer-modified-p modified)
    #                     (meow--execute-kbd-macro "<escape>"))
    #                 (push event unread-command-events)))))))
    #   '';
    # };

    # base16-theme = {
    #   enable = true;
    # };

    # base16-hm-theme = {
    #   enable = true;
    # };
  };
}
