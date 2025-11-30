;;; early-init.el --- -*- lexical-binding: t; -*-
(setq package-enable-at-startup nil)

(setq lsp-use-plists t)
(setenv "LSP_USE_PLISTS" "true")

;; (require 'chemacs
;;          (expand-file-name "chemacs.el"
;;                            (file-name-directory
;;                             (file-truename load-file-name))))
;; (chemacs-load-user-early-init)


