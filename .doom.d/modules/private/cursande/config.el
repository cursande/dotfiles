;;; private/cursande/config.el -*- lexical-binding: t; -*-

;; NOTE - To reinstall this private module, run `make install` in
;; `~/.emacs.d`

(setq doom-font (font-spec :family "Go Mono"
                           :size 18))

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

