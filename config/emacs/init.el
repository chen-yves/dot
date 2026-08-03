;;; init.el --- My Emacs Configuration. -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:

;;;; References:
;;;; - https://github.com/seagle0128/.emacs.d
;;;; - https://github.com/redguardtoo/emacs.d
;;;; - https://github.com/manateelazycat/lazycat-emacs
;;;; - https://github.com/MiniApollo/kickstart.emacs
;;;; - https://github.com/daviwil/emacs-from-scratch
;;;; - https://github.com/purcell/emacs.d
;;;; - https://github.com/syl20bnr/spacemacs
;;;; - https://github.com/doomemacs/core
;;;; - https://github.com/bbatsov/prelude
;;;; - https://github.com/Eason0210/.emacs.d
;;;; - https://github.com/jamescherti/minimal-emacs.d
;;;; - https://github.com/LionyxML/emacs-solo

;;; Code:

;;;; BUILTIN
(use-package use-package
  :ensure nil
  :custom
  (use-package-compute-statistics t)
  (use-package-always-ensure t)
  (use-package-always-defer t)
  (use-package-expand-minimally t)
  (use-package-enable-imenu-support t))

(use-package package
  :ensure nil
  :init
  (setq package-enable-at-startup nil)
  (setq package-quickstart t)
  :config
  (package-initialize)
  (setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa" . "https://melpa.org/packages/")
          ("jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/"))))

(use-package emacs
  :ensure nil
  :init
  (defun my/setup-fonts ()
    "Setup fonts."
    (when (display-graphic-p)
      (require 'cl-lib)
      ;; Default
      (cl-loop for font in '("JetbrainsMono Nerd Font" "Monaco" "Consolas")
               when (find-font (font-spec :name font))
               return (set-face-attribute 'default nil
                                          :family font
                                          :height (cond ((eq system-type 'darwin) 130)
                                                        ((eq system-type 'windows-nt) 110)
                                                        (t 100))))

      ;; Modeline
      (cl-loop for font in '("JetbrainsMono Nerd Font" "Monaco" "Consolas")
               when (find-font (font-spec :name font))
               return (progn
                        (set-face-attribute 'mode-line nil :family font :inherit 'variable-pitch)
                        (set-face-attribute 'mode-line-inactive nil :family font :inherit 'variable-pitch)))

      ;; Symbol
      (cl-loop for font in '("Apple Symbols" "Segoe UI Symbol" "Symbola" "Symbol")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))

      ;; Unicode
      (cl-loop for font in '("Segoe UI" "Arial Unicode MS")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'unicode (font-spec :family font) nil 'prepend))

      ;; Emoji
      (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))

      ;; Chinese
      (cl-loop for font in '("LXGW Neo Xihei" "LXGW WenKai Mono" "WenQuanYi Micro Hei Mono" "PingFang TC" "Microsoft Yahei UI" "Simhei")
               when (find-font (font-spec :name font))
               return (progn
                        (setq face-font-rescale-alist `((,font . 1.0)))
                        (set-fontset-font t 'han (font-spec :family font))))))
  :hook
  ((window-setup . my/setup-fonts)
   (server-after-make-frame . my/setup-fonts)
   (minibuffer-setup-hook . (lambda () (setq gc-cons-threshold most-positive-fixnum)))
   (minibuffer-exit-hook . (lambda () (setq gc-cons-threshold 800000))))
  :config
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq fast-but-imprecise-scrolling t)
  (setq ring-bell-function 'ignore)
  (setq long-line-threshold 1000)
  (setq large-hscroll-threshold 1000)
  (setq inhibit-compacting-font-caches t)
  (setq bidi-inhibit-bpa t)
  (setq enable-recursive-minibuffers t)
  (setq-default bidi-display-reordering nil)
  (setq-default bidi-paragraph-direction 'left-to-right)
  (setq-default tab-width 2)
  (setq-default create-lockfiles nil)
  (setq-default truncate-lines t)
  (setq frame-resize-pixelwise t))

(use-package modus-themes
  :ensure nil
  :hook (after-init . (lambda () (load-theme 'modus-operandi-tinted t))))

(use-package minibuffer
  :ensure nil
  :bind
  (:map minibuffer-local-completion-map
        ("<SPC>" . nil)))

(use-package hl-line
  :ensure nil
  :hook (prog-mode . hl-line-mode))

(use-package simple
  :ensure nil
  :hook
  ((after-init . size-indication-mode)
   (after-init . line-number-mode)
   (after-init . column-number-mode))
  :config
  (setq-default indent-tabs-mode nil))

(use-package cus-edit
  :ensure nil
  :config
  (setq custom-file (concat (file-name-as-directory user-emacs-directory) "custom.el")))

(use-package paren
  :ensure nil
  :hook (prog-mode . show-paren-mode))

(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

(use-package display-line-numbers
  :ensure nil
  :hook
  (prog-mode . display-line-numbers-mode))

(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode)
  :config
  (setq auto-revert-check-vc-info nil))

(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode))

(use-package files
  :ensure nil
  :config
  (setq require-final-newline nil)
  (setq enable-local-variables :all)
  (setq auto-save-default nil)
  (setq make-backup-files nil))

(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

(use-package so-long
  :ensure nil
  :hook (after-init . global-so-long-mode))

(use-package isearch
  :ensure nil
  :config
  (setq isearch-lazy-count t)
  (setq isearch-count-prefix-format "[%s/%s] "))

(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-show-docstrings t))

(use-package ibuffer
  :ensure nil
  :bind (([remap list-buffers] . ibuffer)))

(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t)
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq dired-auto-revert-buffer #'dired-buffer-stale-p)
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'top))

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind
  (("M-n" . flymake-goto-next-error)
   ("M-p" . flymake-goto-prev-error))
  :config
  (setq flymake-no-changes-timeout 1.0))

(use-package eglot
  :ensure nil
  :commands eglot
  :config
  (setq eglot-events-buffer-size 0))

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :hook (python-mode . (lambda ()
                         (setq-local tab-width 4)
                         (setq-local indent-tabs-mode nil)))
  :config
  (setq python-indent-guess-indent-offset nil)
  (setq python-indent-offset 4))

(use-package project
  :ensure nil
  :config
  (add-to-list 'project-vc-extra-root-markers ".project"))

(use-package icomplete
  :ensure nil
  :hook (after-init . fido-vertical-mode))

;;;; ELPA/MELPA
(use-package evil
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-ex-define-cmd "q" 'kill-current-buffer)
  (evil-ex-define-cmd "wq" (lambda ()
                             (interactive)
                             (save-buffer)
                             (kill-buffer-and-window))))

(use-package evil-collection
  :hook (evil-mode . evil-collection-init))

(use-package evil-escape
  :hook (evil-mode . evil-escape-mode)
  :config
  (setq evil-escape-key-sequence "jk")
  (setq evil-escape-delay 0.2))

(use-package evil-leader
  :hook (evil-mode . global-evil-leader-mode)
  :config
  (setq evil-leader/leader "SPC")
  (evil-leader/set-key
    "SPC" 'execute-extended-command
    "T" 'emacs-init-time
    "pf" 'project-find-file
    "pp" 'project-switch-project
    "pb" 'project-list-buffers
    "pa" 'project-remember-projects-under
    "ff" 'find-file
    "fs" 'isearch-forward
    "ww" 'ace-window
    "wd" 'delete-other-windows
    "wD" 'delete-window
    "wm" 'toggle-frame-maximized
    "hd" 'helpful-at-point
    "hf" 'helpful-callable
    "hv" 'helpful-variable
    "hx" 'helpful-command
    "hk" 'helpful-key))

(use-package orderless
  :hook
  (minibuffer-setup . (lambda ()
                        (setq completion-styles '(orderless basic))
                        (setq completion-category-overrides '((file (styles partial-completion))))
                        (setq completion-pcm-leading-wildcard t))))

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(use-package diff-hl
  :hook
  ((after-init . global-diff-hl-mode)
   (after-init . global-diff-hl-show-hunk-mouse-mode)
   (dired-mode . diff-hl-dired-mode))
  :config
  (setq diff-hl-draw-borders nil)
  (setq diff-hl-update-async t)
  (setq diff-hl-global-modes '(not image-mode pdf-view-mode)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package colorful-mode
  :hook (prog-mode . colorful-mode))

(use-package popper
  :bind
  (("C-`" . popper-toggle)
   ("M-`" . popper-cycle)
   ("C-M-`" . popper-toggle-type))
  :hook
  ((window-setup . popper-mode)
   (popper-mode . popper-echo-mode))
  :config
  (setq popper-mode-line "")
  (setq popper-reference-buffers
        '("\\*Messages\\*$"
          "Output\\*$" "\\*Pp Eval Output\\*$"
          "^\\*eldoc.*\\*$"
          "\\*Compile-Log\\*$"
          "\\*Completions\\*$"
          "\\*Warnings\\*$"
          "\\*Async Shell Command\\*$"
          "\\*Backtrace\\*$"
          "\\*Fd\\*$" "\\*Find\\*$" "\\*Finder\\*$"
          compilation-mode
          help-mode helpful-mode
          Buffer-menu-mode
          flymake-diagnostics-buffer-mode
          grep-mode occur-mode rg-mode
          "^\\*gt-result\\*$" "^\\*gt-log\\*$"
          "^\\*Process List\\*$" process-menu-mode cargo-process-mode
          "^\\*.*eshell.*\\*.*$" eshell-mode
          "^\\*.*shell.*\\*.*$" shell-mode
          "^\\*.*terminal.*\\*.*$" term-mode
          "\\*package update results\\*$" "\\*Package-Lint\\*$"
          "\\*quickrun\\*$"
          "\\*vc-.*\\**"
          "\\*diff-hl\\**"
          "^\\*macro expansion\\**"
          inferior-python-mode inf-ruby-mode swift-repl-mode)))

(use-package corfu
  :hook
  ((after-init . global-corfu-mode)
   (global-corfu-mode . corfu-popupinfo-mode)
   (global-corfu-mode . corfu-history-mode))
  :config
  (setq corfu-auto t)
  (setq corfu-auto-prefix 1)
  (setq corfu-count 13)
  (setq corfu-preview-current nil)
  (setq corfu-on-exact-match nil)
  (setq corfu-auto-delay 0.2)
  (setq corfu-popupinfo-delay '(0.4 . 0.2))
  (setq global-corfu-modes '((not erc-mode circe-mode help-mode helpful-mode gud-mode) t)))

(use-package cape
  :after corfu
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-nonexclusive))

(use-package yasnippet-capf
  :after cape
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":")
  (setq hl-todo-text-modes nil)
  (setq hl-todo-keyword-faces '(("TODO" warning bold)
                                ("FIXME" error bold)
                                ("REVIEW" font-lock-keyword-face bold)
                                ("HACK" font-lock-constant-face bold)
                                ("DEPRECATED" font-lock-doc-face bold)
                                ("BUG" error bold)
                                ("XXX" font-lock-constant-face bold)
                                ("NOTE" success bold))))

(use-package symbol-overlay
  :hook ((prog-mode yaml-mode yaml-ts-mode) . symbol-overlay-mode)
  :bind
  (("M-i" . symbol-overlay-put)
   ("M-N" . symbol-overlay-jump-next)
   ("M-P" . symbol-overlay-jump-prev)
   ("M-R" . symbol-overlay-remove-all))
  :config
  (setq symbol-overlay-idle-time 0.3))

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h x" . helpful-command)
   ("C-h k" . helpful-key)
   ("C-h C-d" . helpful-at-point)))

(use-package ace-window
  :bind (([remap other-window] . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package xclip
  :defer 5
  :config
  (xclip-mode))

(use-package gcmh
  :defer 5
  :config
  (gcmh-mode))

(use-package pretty-hydra
  :bind
  (("C-c w" . hydra-window/body))
  :config
  (pretty-hydra-define hydra-window
    (:hint nil :color amaranth :quit-key ("q" "C-g") :title "Window Management" :foreign-keys warn)
    ("Actions"
     (("TAB" other-window "switch")
      ("x" ace-delete-window "delete")
      ("X" ace-delete-other-windows "delete other" :exit t)
      ("s" ace-swap-window "swap")
      ("a" ace-select-window "select" :exit t)
      ("m" toggle-frame-maximized "maximize" :exit t)
      ("u" toggle-frame-fullscreen "fullscreen" :exit t))
     "Move"
     (("h" windmove-left "←")
      ("j" windmove-down "↓")
      ("k" windmove-up "↑")
      ("l" windmove-right "→"))
     "Split"
     (("v" split-window-below "vertical")
      ("r" split-window-right "horizontal")
      ("t" toggle-window-split "toggle"))
     "Resize"
     (("=" enlarge-window "enlarge")
      ("-" shrink-window "shrink")
      (">" enlarge-window-horizontally "enlarge horizontally")
      ("<" shrink-window-horizontally "shrink horizontally"))
     "Zoom"
     (("=" text-scale-increase "increase")
      ("-" text-scale-decrease "decrease")
      ("0" (text-scale-increase 0) "reset" :exit t)))))

(use-package ibuffer-vc
  :after ibuffer
  :hook (ibuffer-mode . (lambda ()
                          (ibuffer-vc-set-filter-groups-by-vc-root)
                          (unless (eq ibuffer-sorting-mode 'filename/process)
                            (ibuffer-do-sort-by-filename/process)))))

(use-package magit
  :commands magit-status)

(use-package csv-mode
  :mode "\\.[cq]sv\\'"
  :config
  (setq csv-separators '("," ";" "|" " ")))

(use-package markdown-mode
  :mode "\\.md\\'"
  :config
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-enable-math t)
  (setq markdown-hide-markup nil)
  (setq markdown-command "pandoc"))

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package json-mode
  :mode "\\.json\\'")

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package dotenv-mode
  :mode "\\.env\\'")

(use-package uv-mode
  :hook ((python-mode python-ts-mode) . uv-mode-auto-activate-hook))

(use-package toml-mode
  :mode "\\.toml\\'")

;;; init.el ends here
