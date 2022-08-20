;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initilaize

;;------------------------------------------------------------------------------
;; package + use-package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;------------------------------------------------------------------------------
;; Encoding
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;;------------------------------------------------------------------------------
;; Keybind
;; auto indent for enter key
;; http://d.hatena.ne.jp/yascentur/20111126/1322267557
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)
(global-set-key "\C-ce" 'next-error)

;;------------------------------------------------------------------------------
;; View
;; hide startup message
(setq inhibit-startup-screen t)

;; hide tool-bar and scroll-bar when window
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))

;; hide menu-bar when terminal
(when (null window-system)
  (menu-bar-mode 0))

;; show line and column number
(line-number-mode t)
(column-number-mode t)

;; show file path in title bar
(setq frame-title-format "%f")

;; font-lock
(global-font-lock-mode 1)
(setq font-lock-support-mode 'jit-lock-mode)

;; show paren
(show-paren-mode t)

;; 'yes or no' -> 'y or n'
(fset 'yes-or-no-p 'y-or-n-p)

;; show region
(setq transient-mark-mode t)

;; completion ignore case
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;------------------------------------------------------------------------------
;; Input
;; tab-width
(setq-default tab-width 4)

;; hard indent
(setq-default indent-tabs-mode nil)

;; show trailing whitespace
;; http://valvallow.blogspot.jp/2010/06/emacs_02.html
(setq-default show-trailing-whitespace t)

;; add final newline
;; http://reiare.net/blog/2010/12/16/emacs-space-tab/
(setq require-final-newline t)

;;------------------------------------------------------------------------------
;; Backup
;; not use fname.txt~
(setq make-backup-files nil)

;; use #.fname.txt#
(setq auto-save-default t)

;; Auto revert file
(global-auto-revert-mode t)

;;------------------------------------------------------------------------------
;; After save hook
;; add executable if script on save
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;------------------------------------------------------------------------------
;; Custom file
;; http://extra-vision.blogspot.com/2016/10/emacs25-package-selected-packages.html
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;------------------------------------------------------------------------------
;; auto-complete.el
(use-package auto-complete :diminish auto-complete-mode
  :config
  (add-to-list 'ac-dictionary-directories (concat (package-desc-dir (cadr (assq 'auto-complete package-alist))) "/dict"))
  (require 'auto-complete-config)
  (ac-config-default)
  (global-auto-complete-mode t))

;;------------------------------------------------------------------------------
;; undo-tree.el
(use-package undo-tree :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (global-set-key (kbd "C-M-_") 'undo-tree-redo)
  (setq undo-tree-auto-save-history nil))

;;------------------------------------------------------------------------------
;; smartparens.el
(use-package smartparens :diminish smartparens-mode
  :config
  (smartparens-global-mode t)
  (setq sp-highlight-pair-overlay nil))

;;------------------------------------------------------------------------------
;; smart-newline.el
(use-package smart-newline :diminish smart-newline-mode)

;;------------------------------------------------------------------------------
;; anzu.el
(use-package anzu :diminish anzu-mode
  :config
  (global-anzu-mode 1)
  (setq anzu-deactivate-region t)
  (setq anzu-search-threshold 999))

;;------------------------------------------------------------------------------
;; visual-regexp-steroids.el
(use-package pcre2el)
(use-package visual-regexp-steroids
  :config
  (setq vr/engine 'pcre2el)
  (global-set-key (kbd "M-%") 'vr/query-replace)
  (global-set-key (kbd "C-c m") 'vr/mc-mark)
  (global-set-key (kbd "C-M-r") 'vr/isearch-backward)
  (global-set-key (kbd "C-M-s") 'vr/isearch-forward))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Majar mode

;;------------------------------------------------------------------------------
;; C/C++
(add-hook 'c-mode-common-hook
          '(lambda ()
             (c-set-style "gnu")
             (c-set-offset 'innamespace 0)
             (local-set-key "\C-m" 'reindent-then-newline-and-indent)
             ))

;;------------------------------------------------------------------------------
;; Shell
(add-to-list 'auto-mode-alist '("bashrc\\(\\.[a-zA-Z0-9_]+\\)*$" . sh-mode))

;;------------------------------------------------------------------------------
;; Diff
(add-hook 'diff-mode-hook
          '(lambda ()
             (set-face-attribute 'diff-added nil
                                 :foreground "white" :background "dark green")
             (set-face-attribute 'diff-removed nil
                                 :foreground "white" :background "dark red")
             (set-face-attribute 'diff-changed nil
                                 :foreground "white" :background "purple red")
             ))

;;------------------------------------------------------------------------------
;; JavaScript
(use-package rjsx-mode
  :mode (("\\.jsx?$" . rjsx-mode)
         ("\\.mjs$" . rjsx-mode))
  :config
  (setq js-indent-level 2)
  (setq js-switch-indent-offset 2)
  (setq js2-strict-trailing-comma-warning nil)
  (add-to-list 'ac-modes 'rjsx-mode)
  (add-hook 'rjsx-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (package-desc-dir (cadr (assq 'auto-complete package-alist))) "/dict/js-mode"))
               )))

;;------------------------------------------------------------------------------
;; TypeScript
(use-package typescript-mode :mode ("\\.tsx?$" . typescript-mode)
  :config
  (setq typescript-indent-level 2)
  (add-to-list 'ac-modes 'typescript-mode)
  (add-hook 'typescript-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (package-desc-dir (cadr (assq 'auto-complete package-alist))) "/dict/js-mode"))
               )))

;;------------------------------------------------------------------------------
;; CoffeeScript
(use-package coffee-mode :mode ("\\.coffee$" . coffee-mode)
  :config
  (setq coffee-tab-width 2)
  (add-to-list 'ac-modes 'coffee-mode)
  (add-hook 'coffee-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (package-desc-dir (cadr (assq 'auto-complete package-alist))) "/dict/js-mode"))
               )))

;;------------------------------------------------------------------------------
;; Go
(use-package go-mode :mode ("\\.go$" . go-mode)
  :config
  (add-hook 'go-mode-hook
            '(lambda ()
               (add-hook 'before-save-hook 'gofmt-before-save)
               )))

;;------------------------------------------------------------------------------
;; Ruby
;; cf. http://blog.10rane.com/2014/09/01/set-up-ruby-mode-of-emacs/
(use-package ruby-mode
  :mode (("\\.rb$" . ruby-mode)
         ("\\.rake$" . ruby-mode)
         ("\\.gemspec$" . ruby-mode)
         ("Capfile$" . ruby-mode)
         ("Gemfile$" . ruby-mode)
         ("Rakefile$" . ruby-mode))
  :config
  (setq ruby-deep-indent-paren-style nil)
  (setq ruby-insert-encoding-magic-comment nil)
  (defadvice ruby-indent-line (after unindent-closing-paren activate)
    (let ((column (current-column))
          indent offset)
      (save-excursion
        (back-to-indentation)
        (let ((state (syntax-ppss)))
          (setq offset (- column (current-column)))
          (when (and (eq (char-after) ?\))
                     (not (zerop (car state))))
            (goto-char (cadr state))
            (setq indent (current-indentation)))))
      (when indent
        (indent-line-to indent)
        (when (> offset 0) (forward-char offset)))))
  (add-to-list 'ac-modes 'ruby-mode))
(use-package ruby-end :diminish ruby-end-mode)

;;------------------------------------------------------------------------------
;; PHP
(use-package php-mode :mode ("\\.php$" . php-mode)
  :config
  (add-hook 'php-mode-hook
            '(lambda ()
               (php-enable-drupal-coding-style)
               ))
  (add-hook 'php-mode-hook 'rainbow-mode))

;;------------------------------------------------------------------------------
;; Web (HTML)
(use-package web-mode :mode ("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'" . web-mode)
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-css-colorization t)
  (custom-set-faces
   '(web-mode-doctype-face ((t :inherit font-lock-constant-face)))
   '(web-mode-html-tag-face ((t :inherit font-lock-keyword-face)))
   '(web-mode-html-attr-name-face ((t :inherit font-lock-constant-face)))
   )
  (add-hook 'web-mode-hook
            '(lambda ()
               (setq emmet-preview-default nil) ;don't show preview when expand code
               (emmet-mode)
               )))
(use-package emmet-mode :diminish emmet-mode)

;;------------------------------------------------------------------------------
;; Haml
(use-package haml-mode :mode ("\\.haml$" . haml-mode))

;;------------------------------------------------------------------------------
;; Jade
(use-package jade-mode :mode (("\\.pug$" . jade-mode) ("\\.jade$" . jade-mode)))

;;------------------------------------------------------------------------------
;; CSS/SCSS
(use-package scss-mode :mode ("\\.s?css$" . scss-mode)
  :config
  (setq css-indent-offset 2)
  (setq scss-compile-at-save nil)
  (add-to-list 'ac-modes 'scss-mode)
  (add-hook 'scss-mode-hook
            '(lambda ()
               (setq comment-start "// ")
               (setq comment-end "")
               (add-to-list 'ac-dictionary-files (concat (package-desc-dir (cadr (assq 'auto-complete package-alist))) "/dict/css-mode"))
               ))
  (add-hook 'scss-mode-hook 'rainbow-mode))

;;------------------------------------------------------------------------------
;; Stylus
(use-package stylus-mode :mode ("\\.styl$" . stylus-mode)
  :config
  (add-to-list 'ac-modes 'stylus-mode)
  (add-hook 'stylus-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (package-desc-dir (cadr (assq 'auto-complete package-alist))) "/dict/css-mode"))
               ))
  (add-hook 'stylus-mode-hook 'rainbow-mode))

;;------------------------------------------------------------------------------
;; JSON
(use-package json-mode :mode ("\\.json$" . json-mode)
  :config
  (setq js-indent-level 2))

;;------------------------------------------------------------------------------
;; YAML
(use-package yaml-mode :mode ("\\.yml$" . yaml-mode))

;;------------------------------------------------------------------------------
;; Markdown
(use-package markdown-mode :mode ("\\.md$" . gfm-mode))

;;------------------------------------------------------------------------------
;; Dockerfile
(use-package dockerfile-mode :mode ("Dockerfile\\(\\.[a-zA-Z0-9_]+\\)*$" . dockerfile-mode))

;;------------------------------------------------------------------------------
;; ssh-config
(use-package ssh-config-mode
  :mode ((".ssh/config$"  . ssh-config-mode)
         ("sshd?_config$" . ssh-config-mode)
         ("sshd?-config$" . ssh-config-mode))
  )
