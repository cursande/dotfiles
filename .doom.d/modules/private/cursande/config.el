;;; private/cursande/config.el -*- lexical-binding: t; -*-

;; NOTE - To reinstall this private module, run `make install` in
;; `~/.emacs.d`

(setq doom-font (font-spec :family "Go Mono"
                           :size 18))

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;; rainbow-delimiters added to individual major modes as it can
;; cause problems if added globally https://github.com/Fanael/rainbow-delimiters
(add-hook 'ruby-mode #'rainbow-delimiters-mode)
(add-hook 'python-mode #'rainbow-delimiters-mode)
(add-hook 'clojure-mode #'rainbow-delimiters-mode)
(add-hook 'elixir-mode #'rainbow-delimiters-mode)
(add-hook 'javascript-mode #'rainbow-delimiters-mode)
(add-hook 'js2-mode #'rainbow-delimiters-mode)
(add-hook 'cc-mode #'rainbow-delimiters-mode)

;; For emacs 24 and above:
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
