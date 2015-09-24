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
;; anzu.el
(use-package anzu :ensure t :diminish anzu-mode
  :config
  (global-anzu-mode 1)
  (setq anzu-deactivate-region t)
  (setq anzu-search-threshold 999))

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
(add-to-list 'auto-mode-alist '("config$" . conf-mode))

;;------------------------------------------------------------------------------
;; Shell
(add-to-list 'auto-mode-alist '("bashrc\\(\\.[a-zA-Z0-9_]+\\)?$" . sh-mode))
