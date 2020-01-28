;;; private/cursande/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "IBM Plex Mono Text" :size 14))

(display-time-mode 1)

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

(setq-default indent-tabs-mode nil)

;; remap ESC to clear search highlight
(map! "ESC" #'evil-ex-nohighlight)

(map! :leader "TAB" #'ace-window)

(map! "<f8>" #'kill-buffer-and-window)

(setq-default evil-kill-on-visual-paste nil)

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

;; be prompted to use VLF when opening large files
(require 'vlf-setup)
(custom-set-variables '(vlf-tune-enabled nil))

;; Stop evil mode from doing annoying stuff,  recording macros I don't want
(add-hook 'view-mode-hook 'evil-motion-state)

;; Don't let primary clipboard override system clipboard
(fset 'evil-visual-update-x-selection 'ignore)

;; modeline config
(def-package! doom-modeline
  :init
  (setq doom-modeline-buffer-file-name-style 'relative-from-project)
  (setq doom-modeline-icon nil)
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-minor-modes t)
   :hook (after-init . doom-modeline-init))

;; Don't use popups for certain buffers, don't fuck up my REPL
(set-popup-rule! "^\\* Mit" :ignore t)
(set-popup-rule! "^\\*Python" :ignore t)

;; Fall back on auto complete using dynamic abbreviations
;; (add-to-list 'company-backends 'company-dabbrev-code)

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

;; *** SHELL ***
(setq shell-file-name "bash")

(defun setup-shell-mode ()
  (interactive)
  (flycheck-mode +1) ; For ShellCheck
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(add-hook 'sh-mode-hook #'setup-shell-mode)


;; *** SCHEME ***
;; geiser
(setq geiser-active-implementations '(mit guile))
(map! :localleader :map scheme-mode-map "'" #'run-geiser)
(map! :map geiser-repl-mode-map "C-l" #'geiser-repl-clear-buffer)


;; *** CLOJURE ***
(defun setup-clojure-mode ()
  (interactive)
  (require 'flycheck-clj-kondo)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(add-hook 'clojure-mode-hook #'setup-clojure-mode)

(map! :map cider-repl-mode-map "<f6>" #'cider-repl-history)

;; *** RUBY ***
;; ruby version management
(defun setup-ruby-mode ()
  (interactive)
  (chruby-use-corresponding))

(add-hook 'enh-ruby-mode-hook 'setup-ruby-mode)

(map! "C-c '" #'ruby-toggle-string-quotes)

;; Just for unit testing with Ruby
(defun file-path-and-line-number ()
  (interactive)
  (setq filename (+default/yank-buffer-filename))
  (setq line-num (substring (what-line) 5 nil))
  (setq result (concat filename ":" line-num))
  (message result)
  (kill-new result))

(map! "<f5>" #'file-path-and-line-number)

;; *** WEB + JS/TS ***
(defun web-mode-tweaks ()
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        js-indent-level 2))

(add-hook 'web-mode-hook 'web-mode-tweaks)

;; Tide configuration for TypeScript
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq tide-format-options '(:indentSize 2 :tabSize 2))
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

;; *** PYTHON ***

(setq python-shell-interpreter "python3")

(map! :localleader
      :map python-mode-map
        "r" #'python-shell-send-region
        "'" #'+python/open-repl
      )

;; *** C ***
(defun setup-c-mode ()
  (interactive)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(add-hook 'c-mode-hook #'setup-c-mode)

(setq-default c-basic-offset 2)

;; *** GO ***
(defun setup-go-mode ()
  (interactive)
  ;; Set go path env vars so go tools know where to look
  (setq exec-path (append '("/usr/local/go/bin") exec-path))
  (setenv "PATH" (concat "/usr/local/go/bin:" (getenv "PATH"))))

(add-hook 'go-mode-hook #'gorepl-mode)
(add-hook 'go-mode-hook #'setup-go-mode)

;; *** ORG ***
(defun setup-org-mode ()
  (interactive)
  (setq org-hide-emphasis-markers t))

(add-hook 'org-mode-hook #'setup-org-mode)

;; *** TF ***
(defun setup-tf-mode ()
  (interactive)
  (flycheck-mode +1) ; tflint
  (company-terraform-init))

(add-hook 'terraform-mode-hook #'setup-tf-mode)

;; theme
(load-theme 'doom-nord t)
