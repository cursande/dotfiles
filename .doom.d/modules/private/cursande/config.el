;;; private/cursande/config.el -*- lexical-binding: t; -*-

;; NOTE - To reinstall this private module, run `make install` in
;; `~/.emacs.d`

(setq doom-font (font-spec :family "Go Mono"
                           :size 18))

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;; remap ESC to clear search highlight
(map! "ESC" #'evil-ex-nohighlight)

;; *** Tide configuration for TypeScript ***
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; *** For .tsx files ***
   (when (symbol-function 'flycheck-add-mode)
     ((require 'web-mode)
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
    (add-hook 'web-mode-hook
              (lambda ()
                (when (string-equal "tsx" (file-name-extension buffer-file-name))
                  (setup-tide-mode))))
    ;; enable typescript-tslint checker
    (flycheck-add-mode 'typescript-tslint 'web-mode)))

;; *** rainbow-delimiters ***

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

;; geiser
(setq geiser-active-implementations '(mit guile))

;; theme
(load-theme 'doom-dracula t)
