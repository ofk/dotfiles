;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initilaize

;;------------------------------------------------------------------------------
;; cl

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
;; Auto revert file
(global-auto-revert-mode t)

;;------------------------------------------------------------------------------
;; Custom file
;; http://extra-vision.blogspot.com/2016/10/emacs25-package-selected-packages.html
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

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
;; Lisp
(add-to-list 'auto-mode-alist '("Cask$" . lisp-mode))

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
;; Conf
(add-to-list 'auto-mode-alist '("config\\(\\.[a-zA-Z0-9_]+\\)*$" . conf-mode))

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
(use-package rjsx-mode :mode ("\\.jsx?$" . rjsx-mode)
  :config
  (setq js-indent-level 2)
  (setq js-switch-indent-offset 2)
  (setq js2-strict-trailing-comma-warning nil)
  (add-to-list 'ac-modes 'rjsx-mode)
  (add-hook 'rjsx-mode-hook
            '(lambda ()
               (add-to-list 'ac-dictionary-files (concat (cask-dependency-path my-bundle 'auto-complete) "/dict/js-mode"))
               )))

;;------------------------------------------------------------------------------
;; TypeScript
(use-package typescript-mode :mode ("\\.ts$" . typescript-mode)
  :config
  (setq typescript-indent-level 2)
  (add-to-list 'ac-modes 'typescript-mode)
  (add-hook 'typescript-mode-hook
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
;; Processing
(use-package processing-mode :mode ("\\.pde$" . processing-mode))

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
(use-package emmet-mode :ensure t :diminish emmet-mode)

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
