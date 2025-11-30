{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.emacs.extraPackages = epkgs: [
    (pkgs.emacs.pkgs.treesit-grammars.with-all-grammars)
  ];
  programs.emacs.enable = true;

  programs.emacs.init = {
    enable = true;
    recommendedGcSettings = true;

    earlyInit = ''
      (setq read-process-output-max (* 10 1024 1024)) ;; 10mb
      (setq gc-cons-threshold (* 100 1024 1024))
      (setq lsp-log-io nil)
    '';

    prelude = ''

      ;; Disable startup message and GUI elements
      (setq inhibit-startup-message t
      inhibit-startup-echo-area-message (user-login-name))

      (setq initial-major-mode 'fundamental-mode
      initial-scratch-message "")

      ;; Disable GUI distractions
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (setq use-dialog-box nil)
      (setq use-file-dialog nil)
      (setq use-short-answers t)

      ;; Global modes
      (global-hl-line-mode)
      (global-word-wrap-whitespace-mode)

      ;; Set up fonts
      (add-to-list 'default-frame-alist
      '(font . "FantasqueSansM Nerd Font-10"))

      (let ((mono-spaced-font "FantasqueSansM Nerd Font") 
      (proportionately-spaced-font "Sans"))
      (set-face-attribute 'default nil :family mono-spaced-font :height 100)
      (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
      (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))

      ;; Accept 'y' and 'n' rather than 'yes' and 'no'
      (defalias 'yes-or-no-p 'y-or-n-p)

      ;; Backup and autosave configuration
      (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
      (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/" t)))
      (make-directory "~/.emacs.d/backups" t)
      (make-directory "~/.emacs.d/auto-saves" t)

      ;; Line and column numbers
      (line-number-mode)
      (column-number-mode)
      (global-display-line-numbers-mode 1)

      ;; Disable line numbers in certain modes
      (dolist (mode '(org-mode-hook
      term-mode-hook
      shell-mode-hook
      eshell-mode-hook
      dashboard-mode-hook
      vterm-mode-hook
      treemacs-mode-hook))
      (add-hook mode (lambda () (display-line-numbers-mode 0))))

      ;; Enable some disabled features
      (put 'narrow-to-region 'disabled nil)

      ;; Tab width
      (setq-default tab-width 2)

      ;; Trailing whitespace
      (setq-default show-trailing-whitespace t)

      ;; Sentence separation
      (setq sentence-end "[.?!][]\"')}]*\\($\\|[ \t]\\)[ \t\n]*"
      sentence-end-double-space nil)

      ;; UTF-8
      (prefer-coding-system 'utf-8)

      ;; Clipboard handling
      (setq select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t)

      ;; Recentf exclude bookmarks

      ;; Unset keys
      (global-unset-key (kbd "C-t"))
      (global-unset-key (kbd "C-o"))

      ;; Org directory
      (setq org-directory "~/org/")

      ;; Auth sources
      (setq auth-sources '("~/.authinfo.gpg"))
    '';

    usePackage = {

      meow = {
        enable = true;
        demand = true;
        config = ''
          (defun meow-setup ()
          (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
          (meow-motion-define-key
          '("j" . meow-next)
          '("k" . meow-prev)
          '("<escape>" . ignore))
          (meow-leader-define-key
          '("1" . meow-digit-argument)
          '("2" . meow-digit-argument)
          '("3" . meow-digit-argument)
          '("4" . meow-digit-argument)
          '("5" . meow-digit-argument)
          '("6" . meow-digit-argument)
          '("7" . meow-digit-argument)
          '("8" . meow-digit-argument)
          '("9" . meow-digit-argument)
          '("0" . meow-digit-argument)
          '("/" . meow-keypad-describe-key)
          '("?" . meow-cheatsheet))
          (meow-normal-define-key
          '("0" . meow-expand-0)
          '("9" . meow-expand-9)
          '("8" . meow-expand-8)
          '("7" . meow-expand-7)
          '("6" . meow-expand-6)
          '("5" . meow-expand-5)
          '("4" . meow-expand-4)
          '("3" . meow-expand-3)
          '("2" . meow-expand-2)
          '("1" . meow-expand-1)
          '("-" . negative-argument)
          '(";" . meow-reverse)
          '("," . meow-inner-of-thing)
          '("." . meow-bounds-of-thing)
          '("[" . meow-beginning-of-thing)
          '("]" . meow-end-of-thing)
          '("a" . meow-append)
          '("A" . meow-open-below)
          '("b" . meow-back-word)
          '("B" . meow-back-symbol)
          '("c" . meow-change)
          '("d" . meow-delete)
          '("D" . meow-backward-delete)
          '("e" . meow-next-word)
          '("E" . meow-next-symbol)
          '("f" . meow-find)
          '("g" . meow-cancel-selection)
          '("G" . meow-grab)
          '("h" . meow-left)
          '("H" . meow-left-expand)
          '("i" . meow-insert)
          '("I" . meow-open-above)
          '("j" . meow-next)
          '("J" . meow-next-expand)
          '("k" . meow-prev)
          '("K" . meow-prev-expand)
          '("l" . meow-right)
          '("L" . meow-right-expand)
          '("m" . meow-join)
          '("n" . meow-search)
          '("o" . meow-block)
          '("O" . meow-to-block)
          '("p" . meow-yank)
          '("q" . meow-quit)
          '("Q" . meow-goto-line)
          '("r" . meow-replace)
          '("R" . meow-swap-grab)
          '("s" . meow-kill)
          '("t" . meow-till)
          '("u" . meow-undo)
          '("U" . meow-undo-in-selection)
          '("v" . meow-visit)
          '("w" . meow-mark-word)
          '("W" . meow-mark-symbol)
          '("x" . meow-line)
          '("X" . meow-goto-line)
          '("y" . meow-save)
          '("Y" . meow-sync-grab)
          '("z" . meow-pop-selection)
          '("'" . repeat)
          '("<escape>" . ignore)))

          (meow-setup)
          (meow-global-mode 1)

          ;; Set up jk escape sequence
          (setq meow-two-char-escape-sequence "jk"
          meow-two-char-escape-delay 0.5)

          (defun meow--two-char-exit-insert-state (s)
          (when (meow-insert-mode-p)
          (let ((modified (buffer-modified-p)))
          (insert (elt s 0))
          (let* ((second-char (elt s 1))
          (event
          (if defining-kbd-macro
          (read-event nil nil)
          (read-event nil nil meow-two-char-escape-delay))))
          (when event
          (if (and (characterp event) (= event second-char))
          (progn
          (backward-delete-char 1)
          (set-buffer-modified-p modified)
          (meow--execute-kbd-macro "<escape>"))
          (push event unread-command-events)))))))

          (defun meow-two-char-exit-insert-state ()
          "Exit insert mode with two-key sequence."
          (interactive)
          (if (derived-mode-p 'vterm-mode)
          (self-insert-command 1)
          (meow--two-char-exit-insert-state meow-two-char-escape-sequence)))

          ;; Bind the first character of the escape sequence
          (define-key meow-insert-state-keymap (substring meow-two-char-escape-sequence 0 1)
          #'meow-two-char-exit-insert-state)

          (meow-leader-define-key
          '("w h" . windmove-left)
          '("w l" . windmove-right)
          '("w j" . windmove-down)
          '("w k" . windmove-up)
          '("w H" . windmove-swap-states-left)
          '("w J" . windmove-swap-states-down)
          '("w K" . windmove-swap-states-up)
          '("w L" . windmove-swap-states-right)
          '("w v" . split-window-horizontally)
          '("w s" . split-window-vertically)
          '("w d" . delete-window)
          '("f f" . find-file)
          '("b b" . consult-buffer)
          '("z z" . recenter-top-bottom)
          )

        '';
      };

      perspective = {
        enable = true;
        bind = {
          "C-x C-b" = "persp-list-buffers";
          "C-<tab> b" = "persp-switch-to-buffer*";
          "C-<tab> k" = "persp-kill-buffer*";
          "C-<tab> <tab>" = "persp-switch";
        };
        custom = {
          persp-suppress-no-prefix-key-warning = "t";
        };
        init = ''
          (persp-mode)
        '';
      };

      which-key = {
        enable = true;
        command = [
          "which-key-mode"
          "which-key-add-major-mode-key-based-replacements"
        ];
        diminish = [ "which-key-mode" ];
        defer = 3;
        config = ''
          (which-key-mode)
        '';
      };

      doom-modeline = {
        enable = true;
        hook = [ "(after-init . doom-modeline-mode)" ];
        config = ''
          (setq doom-modeline-buffer-file-name-style 'truncate-except-project)
        '';
      };

      dashboard = {
        enable = true;
        demand = true;
        config = ''
                  (setq dashboard-banner-logo-title "Minimacs")
                  (setq dashboard-startup-banner 'logo)
                  (setq dashboard-center-content t)
                  (setq dashboard-vertically-center-content t)
                  (setq dashboard-show-shortcuts t)
          	      (setq dashboard-display-icons-p t)
          	      (setq dashboard-icon-type 'nerd-icons)
          	      (setq dashboard-set-heading-icons t)
          	      (setq dashboard-set-file-icons t)
                  (setq dashboard-items '((recents   . 5)
                  (bookmarks . 5)
                  (projects  . 5)
                  (agenda    . 5)
                  (registers . 5)))
                  (setq dashboard-projects-backend 'projectile)
                  (setq dashboard-projects-switch-function 'projectile-switch-project-by-name)
                  (setq dashboard-item-shortcuts '((recents   . "r")
                  (bookmarks . "m")
                  (projects  . "p")
                  (agenda    . "a")))
                  (dashboard-setup-startup-hook)
        '';
      };

      all-the-icons = {
        enable = true;
      };

      vertico = {
        enable = true;
        # init = "(vertico-mode)";
        config = ''
          (vertico-mode)
        '';
      };

      marginalia = {
        enable = true;
        init = ''
          (marginalia-mode 1)
        '';
      };

      all-the-icons-completion = {
        enable = true;
        after = [
          "all-the-icons"
          "marginalia"
        ];
        hook = [ "(marginalia-mode . all-the-icons-completion-marginalia-setup)" ];
        init = ''
          (all-the-icons-completion-mode 1)
        '';
      };

      orderless = {
        enable = true;
        custom = {
          completion-styles = "'(orderless basic)";
          completion-category-defaults = "nil";
          orderless-matching-styles = "'(orderless-flex orderless-regexp)";
          orderless-component-separator = "#'orderless-escapable-split-on-space";
        };
      };

      savehist = {
        enable = true;
        init = "(savehist-mode)";
      };

      emacs = {
        enable = true;
        init = ''
          (keymap-global-set "C-h C-t" 'consult-theme)
        '';
      };

      yasnippet = {
        enable = true;
        config = ''
          (yas-global-mode 1)
        '';
      };

      # Optional: add yasnippet-snippets for a collection of snippets
      yasnippet-snippets = {
        enable = true;
        after = [ "yasnippet" ];
      };

      lsp-mode = {
        enable = true;
        diminish = [ "LSP" ];
        hook = [
          "(lsp-mode . lsp-diagnostics-mode)"
          "(lsp-mode . lsp-enable-which-key-integration)"
          "(tsx-ts-mode . lsp-deferred)"
          "(typescript-ts-mode . lsp-deferred)"
          "(js-ts-mode . lsp-deferred)"
        ];
        custom = {
          lsp-completion-provider = ":none";
          lsp-diagnostics-provider = ":flycheck";
          lsp-session-file = ''(locate-user-emacs-file ".lsp-session")'';
          lsp-log-io = "nil";
          lsp-keep-workspace-alive = "nil";
          lsp-idle-delay = "0.5";
          # core
          lsp-enable-xref = "t";
          lsp-auto-configure = "t";
          lsp-eldoc-enable-hover = "t";
          lsp-enable-dap-auto-configure = "t";
          lsp-enable-file-watchers = "nil";
          lsp-enable-folding = "nil";
          lsp-enable-imenu = "t";
          lsp-enable-indentation = "nil";
          lsp-enable-links = "nil";
          lsp-enable-on-type-formatting = "nil";
          lsp-enable-suggest-server-download = "t";
          lsp-enable-symbol-highlighting = "t";
          lsp-enable-text-document-color = "nil";
          lsp-ui-sideline-show-hover = "nil";
          lsp-ui-sideline-diagnostic-max-lines = "20";
          # completion
          lsp-completion-enable = "t";
          lsp-completion-enable-additional-text-edit = "t";
          lsp-enable-snippet = "t";
          lsp-completion-show-kind = "t";
          # headerline
          lsp-headerline-breadcrumb-enable = "t";
          lsp-headerline-breadcrumb-enable-diagnostics = "nil";
          lsp-headerline-breadcrumb-enable-symbol-numbers = "nil";
          lsp-headerline-breadcrumb-icons-enable = "nil";
          # modeline
          lsp-modeline-code-actions-enable = "nil";
          lsp-modeline-diagnostics-enable = "nil";
          lsp-modeline-workspace-status-enable = "nil";
          lsp-signature-doc-lines = "1";
          lsp-ui-doc-use-childframe = "t";
          lsp-eldoc-render-all = "nil";
          # lens
          lsp-lens-enable = "nil";
          # semantic
          lsp-semantic-tokens-enable = "nil";
          lsp-use-plists = "t";
          lsp-clients-typescript-prefer-use-project-ts-server = "t";
        };
        init = ''
          (defun lsp-booster--advice-json-parse (old-fn &rest args)
                "Try to parse bytecode instead of json."
                (or
                 (when (equal (following-char) ?#)
                   (let ((bytecode (read (current-buffer))))
                     (when (byte-code-function-p bytecode)
                       (funcall bytecode))))
                 (apply old-fn args)))

              (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
                "Prepend emacs-lsp-booster command to lsp CMD."
                (let ((orig-result (funcall old-fn cmd test?)))
                  (if (and (not test?)
                           (not (file-remote-p default-directory))
                           (executable-find "emacs-lsp-booster"))
                      (progn
                        (message "Using emacs-lsp-booster for %s!" orig-result)
                        (cons "emacs-lsp-booster" orig-result))
                    orig-result)))
        '';
        config = ''
          (require 'json)
          (advice-add (if (fboundp 'json-parse-buffer)
                          'json-parse-buffer
                        'json-read)
                      :around
                      #'lsp-booster--advice-json-parse)
          (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
        '';
      };

      lsp-ui = {
        enable = true;
        command = [ "lsp-ui-mode" ];
        bind = {
          "C-c r d" = "lsp-ui-doc-show";
          "C-c f s" = "lsp-ui-find-workspace-symbol";
        };
        config = ''
          (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
          (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
        '';
      };

      lsp-ui-flycheck = {
        enable = true;
        command = [ "lsp-flycheck-enable" ];
        #   after = [ "flycheck" "lsp-ui" ];
      };

      lsp-modeline = {
        enable = true;
      };

      lsp-headerline = {
        enable = true;
        after = [ "lsp-mode" ];
      };

      lsp-eslint = {
        enable = true;
      };

      consult-lsp = {
        enable = true;
        after = [ "lsp-mode" ];
        bind = { };
        config = ''
          (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols)
        '';
      };

      corfu = {
        enable = true;
        config = ''
          (add-hook 'after-init-hook #'global-corfu-mode)
        '';
      };

      direnv = {
        enable = true;
        demand = true;
        config = ''
          (direnv-mode)
        '';
      };

      lsp-rust = {
        enable = true;
        defer = true;
        after = [
          "lsp-mode"
          "rustic"
        ];
        config = lib.mkForce ''
          (setq lsp-rust-server 'rust-analyzer)
          (setf (lsp--client-priority (gethash 'rust-analyzer lsp-clients)) 100)
          (setq lsp-disabled-clients '(rls))
        '';
      };

      lsp-typescript = {
        enable = true;
        defer = true;
        after = [ "lsp-mode" ];
        config = ''
          ;; Configure language IDs for tree-sitter modes
          (add-to-list 'lsp-language-id-configuration '(tsx-ts-mode . "typescriptreact"))
          (add-to-list 'lsp-language-id-configuration '(typescript-ts-mode . "typescript"))
          (add-to-list 'lsp-language-id-configuration '(js-ts-mode . "javascript"))

          ;; Register TypeScript language server client
          (lsp-register-client
           (make-lsp-client
            :new-connection (lsp-stdio-connection
                             (lambda ()
                               (list (or (executable-find "typescript-language-server")
                                         "/run/current-system/sw/bin/typescript-language-server")
                                     "--stdio")))
            :activation-fn (lsp-activate-on "typescript" "typescriptreact" "javascript")
            :priority 1
            :server-id 'ts-ls
            :major-modes '(typescript-mode typescript-ts-mode tsx-ts-mode js-mode js-ts-mode)))
        '';
      };

      projectile = {
        enable = true;
        config = ''
            (projectile-mode +1)
          	(setq projectile-switch-project-action #'projectile-find-file)
        '';
      };

      persp-projectile = {
        after = [
          "perspective"
          "projectile"
        ];
      };

      counsel-projectile = {
        enable = true;
        demand = true;
        after = [
          "counsel"
          "projectile"
        ];
        bind = {
          "C-c p p" = "counsel-projectile-switch-project";
        };
        config = ''
          (counsel-projectile-mode 1)
        '';
      };

      # Prog modes
      nix-mode = {
        enable = true;
        hook = [ "(nix-mode . subword-mode)" ];
      };

      # tuareg-mode = {
      #   enable = true;
      # };

      yuck-mode = {
        enable = true;
      };

      treesit = {
        enable = true;
        mode = [
          ''("\\.tsx\\'" . tsx-ts-mode)''
          ''("\\.js\\'" . typescript-ts-mode)''
          ''("\\.mjs\\'" . typescript-ts-mode)''
          ''("\\.mts\\'" . typescript-ts-mode)''
          ''("\\.cjs\\'" . typescript-ts-mode)''
          ''("\\.ts\\'" . typescript-ts-mode)''
          ''("\\.lua\\'" . lua-ts-mode)''
          ''("\\.jsx\\'" . tsx-ts-mode)''
          ''("\\.json\\'" . json-ts-mode)''
          ''("\\.Dockerfile\\'" . dockerfile-ts-mode)''
          ''("\\.prisma\\'" . prisma-ts-mode)''
        ];
        init = ''
          (dolist (mapping
          '((python-mode . python-ts-mode)
            (css-mode . css-ts-mode)
            (typescript-mode . typescript-ts-mode)
            (js-mode . typescript-ts-mode)
            (js2-mode . typescript-ts-mode)
            (c-mode . c-ts-mode)
            (c++-mode . c++-ts-mode)
            (c-or-c++-mode . c-or-c++-ts-mode)
            (bash-mode . bash-ts-mode)
            (css-mode . css-ts-mode)
            (json-mode . json-ts-mode)
            (js-json-mode . json-ts-mode)
            (sh-mode . bash-ts-mode)
            (sh-base-mode . bash-ts-mode)))
            (add-to-list 'major-mode-remap-alist mapping))
        '';
      };
    };
  };
}
