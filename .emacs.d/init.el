;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initilaize

;;------------------------------------------------------------------------------
;; cl
(require 'cl-lib)
(eval-when-compile (require 'cl))

;;------------------------------------------------------------------------------
;; Packages
(when (or (require 'cask nil t)
          (require 'cask "~/.cask/cask.el" t))
  (defconst my-bundle (cask-initialize)))
(require 'use-package)

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

;; show buffer list in mini buffer (C-x b)
(iswitchb-mode 1)

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
;; Indent
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

;;------------------------------------------------------------------------------
;; After save hook
;; add executable if script on save
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;------------------------------------------------------------------------------
;; auto-complete.el
(use-package auto-complete :ensure t :diminish auto-complete-mode
  :config
  (add-to-list 'ac-dictionary-directories (concat (cask-dependency-path my-bundle 'auto-complete) "/dict"))
  (require 'auto-complete-config)
  (ac-config-default)
  (global-auto-complete-mode t))

;;------------------------------------------------------------------------------
;; undo-tree.el
(use-package undo-tree :ensure t :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (global-set-key (kbd "C-M-_") 'undo-tree-redo))

;;------------------------------------------------------------------------------
;; smartparens.el
(use-package smartparens :ensure t :diminish smartparens-mode
  :config
  (smartparens-global-mode t)
  (setq sp-highlight-pair-overlay nil))

;;------------------------------------------------------------------------------
;; smart-newline.el
(use-package smart-newline :ensure t :diminish smart-newline-mode)

;;------------------------------------------------------------------------------
;; anzu.el
(use-package anzu :ensure t :diminish anzu-mode
  :config
  (global-anzu-mode 1)
  (setq anzu-deactivate-region t)
  (setq anzu-search-threshold 999))

;;------------------------------------------------------------------------------
;; Rainbow mode
(use-package rainbow-mode :defer t ;:diminish rainbow-mode
  :config
  (add-to-list 'rainbow-html-colors-major-mode-list 'scss-mode)
  (add-to-list 'rainbow-html-colors-major-mode-list 'stylus-mode)
  (add-to-list 'rainbow-html-colors-major-mode-list 'php-mode))

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
;; Lisp
(add-to-list 'auto-mode-alist '("Cask$" . lisp-mode))

;;------------------------------------------------------------------------------
;; Conf
(add-to-list 'auto-mode-alist '("config\\(\\.[a-zA-Z0-9_]+\\)*$" . conf-mode))

;;------------------------------------------------------------------------------
;; Shell
(add-to-list 'auto-mode-alist '("bashrc\\(\\.[a-zA-Z0-9_]+\\)*$" . sh-mode))

;;------------------------------------------------------------------------------
;; Markdown
(use-package markdown-mode :mode ("\\.md$" . gfm-mode))

;;------------------------------------------------------------------------------
;; YAML
(use-package yaml-mode :mode ("\\.yml$" . yaml-mode))

;;------------------------------------------------------------------------------
;; JSON
(use-package json-mode :mode ("\\.json$" . json-mode)
  :config
  (setq js-indent-level 2))

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
(use-package enh-ruby-mode
  :mode (("\\.rb$" . enh-ruby-mode)
         ("\\.rake$" . enh-ruby-mode)
         ("\\.gemspec$" . enh-ruby-mode)
         ("Capfile$" . enh-ruby-mode)
         ("Gemfile$" . enh-ruby-mode)
         ("Rakefile$" . enh-ruby-mode))
  :config
  (setq enh-ruby-add-encoding-comment-on-save nil)
  (add-to-list 'ac-modes 'enh-ruby-mode)
  (add-hook 'enh-ruby-mode-hook
            '(lambda ()
               (electric-pair-mode t)
               (electric-indent-mode t)
               (electric-layout-mode t)
               (add-to-list 'ac-dictionary-files (concat (cask-dependency-path my-bundle 'auto-complete) "/dict/ruby-mode"))
               )))

;;------------------------------------------------------------------------------
;; JavaScript
(use-package js2-mode :mode ("\\.js$" . js2-mode)
  :config
  (setq js2-basic-offset 2)
  (setq js2-highlight-level 3)
  (setq js2-include-node-externs t)
  (setq js2-strict-inconsistent-return-warning nil)
  (add-to-list 'ac-modes 'js2-mode)
  (add-hook 'js2-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (cask-dependency-path my-bundle 'auto-complete) "/dict/js-mode"))
               )))

;;------------------------------------------------------------------------------
;; CoffeeScript
(use-package coffee-mode :mode ("\\.coffee$" . coffee-mode)
  :config
  (setq coffee-tab-width 2)
  (add-to-list 'ac-modes 'coffee-mode)
  (add-hook 'coffee-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (cask-dependency-path my-bundle 'auto-complete) "/dict/js-mode"))
               )))

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
               (add-to-list 'ac-dictionary-files (concat (cask-dependency-path my-bundle 'auto-complete) "/dict/css-mode"))
               ))
  (add-hook 'scss-mode-hook 'rainbow-mode))

;;------------------------------------------------------------------------------
;; Stylus
(use-package stylus-mode :mode ("\\.styl$" . stylus-mode)
  :config
  (add-to-list 'ac-modes 'stylus-mode)
  (add-hook 'stylus-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (cask-dependency-path my-bundle 'auto-complete) "/dict/css-mode"))
               ))
  (add-hook 'stylus-mode-hook 'rainbow-mode))

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
   ))

;;------------------------------------------------------------------------------
;; Haml
(use-package haml-mode :mode ("\\.haml$" . haml-mode))

;;------------------------------------------------------------------------------
;; Jade
(use-package jade-mode :mode ("\\.jade$" . jade-mode))

;;------------------------------------------------------------------------------
;; PHP
(use-package php-mode :mode ("\\.php$" . php-mode)
  :config
  (add-hook 'php-mode-hook
            '(lambda ()
               (php-enable-drupal-coding-style)
               ))
  (add-hook 'php-mode-hook 'rainbow-mode))
