;;; private/cursande/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "JetBrains Mono Thin" :size 14))

;; theme
(load-theme 'kaolin-valley-light  t)

(display-time-mode 1)

(setq-default indent-tabs-mode nil)

;; remap ESC to clear search highlight
(map! "ESC" #'evil-ex-nohighlight)

(map! :leader "TAB" #'ace-window)

(map! "<f8>" #'kill-buffer-and-window)

(setq-default evil-kill-on-visual-paste nil)

(map! :leader "/" #'+ivy/project-search)

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

(when (and (string-equal system-type "darwin")
           (memq window-system '(mac ns x)))
  (setq exec-path-from-shell-variables
        '("PATH"
          "MANPATH"
          "AWS_PROFILE"))
  (exec-path-from-shell-initialize))

;; modeline config
(use-package! doom-modeline
  :init
  (setq doom-modeline-buffer-file-name-style 'relative-from-project)
  (setq doom-modeline-icon nil)
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-major-mode-color-icon nil)
  (setq doom-modeline-mode nil)
  (setq doom-modeline-modal-icon nil)
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

;; *** SCHEME ***
;; geiser
(setq geiser-active-implementations '(mit guile))
(map! :localleader :map scheme-mode-map "'" #'run-geiser)
(map! :map geiser-repl-mode-map "C-l" #'geiser-repl-clear-buffer)

;; This is a hack to set the path to scheme, the brew-installed scheme isn't
;; compiling properly by default because of xcode nonsense
(setq geiser-mit-binary "/usr/local/bin/scheme")

;; *** CLOJURE ***
(defun setup-clojure-mode ()
  (interactive)
  (require 'flycheck-clj-kondo)
  (flycheck-mode +1)
  (setq nrepl-log-messages nil) ; TEMP
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

;; sayid init
;(eval-after-load 'clojure-mode '(sayid-setup-package))

(add-hook 'clojure-mode-hook #'setup-clojure-mode)

(add-hook 'clojure-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'clojure-align nil 'local)))

(map! :map cider-repl-mode-map "<f6>" #'cider-repl-history)

(after! cider
  (add-hook 'company-completion-started-hook 'custom/set-company-maps)
  (add-hook 'company-completion-finished-hook 'custom/unset-company-maps)
  (add-hook 'company-completion-cancelled-hook 'custom/unset-company-maps))

(defun custom/unset-company-maps (&rest unused)
  "Set default mappings (outside of company).
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" nil
    "<up>"   nil
    "RET"    nil
    [return] nil
    "C-n"    nil
    "C-p"    nil
    "C-j"    nil
    "C-k"    nil
    "C-h"    nil
    "C-u"    nil
    "C-d"    nil
    "C-s"    nil
    "C-S-s"   (cond ((featurep! :completion helm) nil)
                    ((featurep! :completion ivy)  nil))
    "C-SPC"   nil
    "TAB"     nil
    [tab]     nil
    [backtab] nil))

(defun custom/set-company-maps (&rest unused)
  "Set maps for when you're inside company completion.
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" #'company-select-next
    "<up>" #'company-select-previous
    "RET" #'company-complete
    [return] #'company-complete
    "C-w"     nil  ; don't interfere with `evil-delete-backward-word'
    "C-n"     #'company-select-next
    "C-p"     #'company-select-previous
    "C-j"     #'company-select-next
    "C-k"     #'company-select-previous
    "C-h"     #'company-show-doc-buffer
    "C-u"     #'company-previous-page
    "C-d"     #'company-next-page
    "C-s"     #'company-filter-candidates
    "C-S-s"   (cond ((featurep! :completion helm) #'helm-company)
                    ((featurep! :completion ivy)  #'counsel-company))
    "C-SPC"   #'company-complete-common
    "TAB"     #'company-complete-common-or-cycle
    [tab]     #'company-complete-common-or-cycle
    [backtab] #'company-select-previous))

;; *** RUBY ***
;; ruby version management
(defun setup-ruby-mode ()
  (interactive)
  (setq tab-width 2)
  (setq indent-line-function 'insert-tab)
  (flycheck-mode -1)
  (chruby-use-corresponding))

(add-hook 'enh-ruby-mode-hook 'setup-ruby-mode)

(map! "C-c '" #'ruby-toggle-string-quotes)

;; Just for unit testing with Ruby
(defun file-path-and-line-number ()
  (interactive)
  (setq filename (+default/yank-buffer-path))
  (setq line-num (substring (what-line) 5 nil))
  (setq result (concat (substring filename 26 nil) ":" line-num))
  (message result)
  (kill-new result))

(map! "<f5>" #'file-path-and-line-number)

;; *** WEB + JS/TS ***
(defun web-mode-tweaks ()
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2))

(setq js-indent-level 2)

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

;; *** SHELL ***
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")

(defun setup-shell-mode ()
  (interactive)
  (if (string= (file-name-nondirectory (buffer-file-name)) ".env")
      (flycheck-mode -1)
    (flycheck-mode +1)) ; For ShellCheck
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(add-hook 'sh-mode-hook #'setup-shell-mode)

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

;; *** Docker ***
(defun setup-dockerfile-mode ()
  (interactive)
  (flycheck-mode +1))

(add-hook 'dockerfile-mode-hook #'setup-dockerfile-mode)
