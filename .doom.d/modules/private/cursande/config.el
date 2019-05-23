;;; private/cursande/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Go Mono"
                           :size 18))

(display-time-mode 1)

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;; remap ESC to clear search highlight
(map! "ESC" #'evil-ex-nohighlight)

;; Copy file path to kill-ring
(map! "<f5>" (lambda () (interactive)
               (message buffer-file-name)
               (kill-new buffer-file-name)))

(map! :leader "TAB" #'ace-window)

;; Have flycheck disabled by default
(global-flycheck-mode -1)

;; Line numbers off by default
(setq display-line-numbers-type nil)

;; Don’t compact font caches during GC (doom-modeline)
(setq inhibit-compacting-font-caches t)

;; run whitespace-cleanup before each save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; ...but keep final newline
(setq require-final-newline t)
(setq mode-require-final-newline t)

;; truncate lines by default
(set-default 'truncate-lines t)

;; Don't use popups for certain buffers, don't fuck up my REPL
(set-popup-rule! "^\\* Mit" :ignore t)
(set-popup-rule! "^\\*Python" :ignore t)

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
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

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
