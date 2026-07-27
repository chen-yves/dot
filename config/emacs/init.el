;;; init.el --- My Emacs Configuration. -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:

;;;; Inspirations:
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

;;; Code:

;;;; CORE
(use-package use-package
  :ensure nil
  :custom
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
          ("melpa" . "https://melpa.org/packages/"))))

(use-package emacs
  :ensure nil
  :init
  (defun my/setup-fonts ()
    "Setup fonts."
    (when (display-graphic-p)
      (require 'cl-lib)
      ;; Default
      (cl-loop for font in '("FiraCode Nerd Font"
                             "CaskaydiaCove Nerd Font"
                             "JetbrainsMono Nerd Font"
                             "Fira Code"
                             "Cascadia Code"
                             "Monaco"
                             "Menlo"
                             "SF Mono"
                             "Hack"
                             "Source Code Pro"
                             "Monaco"
                             "DejaVu Sans Mono"
                             "Consolas")
               when (find-font (font-spec :name font))
               return (set-face-attribute 'default nil
                                          :family font
                                          :height (cond ((eq system-type 'darwin) 130)
                                                        ((eq system-type 'windows-nt) 100)
                                                        (t 100))))

      ;; Modeline
      (cl-loop for font in '("JetbrainsMono Nerd Font"
                             "Cascadia Code"
                             "Monaco"
                             "Menlo"
                             "SF Mono"
                             "Arial"
                             "Helvetica"
                             "Times New Roman")
               when (find-font (font-spec :name font))
               return (progn
                        (set-face-attribute 'mode-line nil :family font :inherit 'variable-pitch)
                        (set-face-attribute 'mode-line-inactive nil :family font :inherit 'variable-pitch)))

      ;; Symbol
      (cl-loop for font in '("Apple Symbols"
                             "Segoe UI Symbol"
                             "Symbola"
                             "Symbol")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))

      ;; Unicode
      (cl-loop for font in '("Segoe UI" "Arial Unicode MS")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'unicode (font-spec :family font) nil 'prepend))

      ;; Emoji
      (cl-loop for font in '("Noto Color Emoji"
                             "Apple Color Emoji"
                             "Segoe UI Emoji")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))

      ;; Chinese
      (cl-loop for font in '("LXGW Neo Xihei"
                             "LXGW WenKai Mono"
                             "WenQuanYi Micro Hei Mono"
                             "PingFang SC"
                             "Microsoft Yahei UI"
                             "Simhei")
               when (find-font (font-spec :name font))
               return (progn
                        (setq face-font-rescale-alist `((,font . 1.0)))
                        (set-fontset-font t 'han (font-spec :family font))))))
  :hook
  (window-setup . my/setup-fonts)
  (server-after-make-frame . my/setup-fonts)
  :config
  (setq fast-but-imprecise-scrolling t)
  (setq long-line-threshold 1000)
  (setq large-hscroll-threshold 1000)
  (setq inhibit-compacting-font-caches t)
  (setq auto-window-vscroll nil)
  (setq bidi-inhibit-bpa t)
  (setq hscroll-step 1)
  (setq hscroll-margin 2)
  (setq scroll-step 1)
  (setq scroll-margin 0)
  (setq scroll-conservatively 100000)
  (setq scroll-preserve-screen-position t)
  (setq auto-window-vscroll nil)
  (setq-default bidi-display-reordering nil)
  (setq-default bidi-paragraph-direction 'left-to-right)
  (setq-default tab-width 2)
  (setq-default create-lockfiles nil)
  (setq-default truncate-lines t))

(use-package outline
  :ensure nil
  :hook (emacs-lisp-mode . outline-minor-mode)
  :config
  (setq outline-minor-mode-cycle t)
  (setq outline-minor-mode-highlight t))

(use-package syntax
  :ensure nil
  :config
  (setq syntax-wholeline-max 1000))

(use-package vc-hooks
  :ensure nil
  :config
  (setq vc-handled-backends '(Git)))

(use-package indent
  :ensure nil
  :config
  (setq-default tab-always-indent 'complete))

(use-package frame
  :ensure nil
  :hook
  (after-init . (lambda () (blink-cursor-mode -1))))

(use-package simple
  :ensure nil
  :hook
  (after-init . size-indication-mode)
  (after-init . line-number-mode)
  (after-init . column-number-mode)
  :config
  (setq-default indent-tabs-mode nil))

(use-package cus-edit
  :ensure nil
  :config
  (setq custom-file (concat (file-name-as-directory user-emacs-directory) "custom.el")))

(use-package winner
  :ensure nil
  :hook (after-init . winner-mode)
  :config
  (setq winner-dont-bind-my-keys nil))

(use-package jit-lock
  :ensure nil
  :config
  (setq jit-lock-defer-time 0.1)
  (setq jit-lock-stealth-time nil)
  (setq jit-lock-chunk-size 1000))

(use-package paren
  :ensure nil
  :hook
  (prog-mode . show-paren-mode)
  :config
  (setq show-paren-when-point-inside-paren t)
  (setq show-paren-when-point-in-periphery t))

(use-package elec-pair
  :ensure nil
  :hook
  (prog-mode . electric-pair-mode))

(use-package display-line-numbers
  :ensure nil
  :hook
  (prog-mode . display-line-numbers-mode))

(use-package hl-line
  :ensure nil
  :hook
  (prog-mode . hl-line-mode))

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
  :hook (after-init . recentf-mode)
  :config
  (setq recentf-filename-handlers '(abbreviate-file-name))
  (setq recentf-exclude `("/ssh:" "/TAGS\\'" "COMMIT_EDITMSG\\'")))

(use-package repeat
  :ensure nil
  :hook (after-init . repeat-mode)
  :config
  (setq repeat-exit-key (kbd "RET")))

(use-package whitespace
  :ensure nil
  :hook ((prog-mode markdown-mode conf-mode) . whitespace-mode)
  :config
  (setq whitespace-style '(face trailing)))

(use-package files
  :ensure nil
  :config
  (setq auto-save-default nil)
  (setq make-backup-files nil))

(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

(use-package so-long
  :ensure nil
  :hook (after-init . global-so-long-mode))

(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode))

(use-package ibuffer
  :ensure nil
  :bind
  (([remap list-buffers] . ibuffer))
  :config
  (setq ibuffer-show-empty-filter-groups nil)
  (setq ibuffer-filter-group-name-face '(:inherit (success bold))))

(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t)
  (setq dired-auto-revert-buffer #'dired-buffer-stale-p)
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'top))

;;;; EVIL
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

(use-package evil-nerd-commenter
  :after evil
  :bind
  (:map evil-normal-state-map
        ("gcc" . evilnc-comment-or-uncomment-lines))
  (:map evil-visual-state-map
        ("gc" . evilnc-comment-or-uncomment-lines)))

(use-package evil-goggles
  :hook (evil-mode . evil-goggles-mode)
  :config
  (setq evil-goggles-pulse t)
  (setq evil-goggles-duration 0.5)
  (evil-goggles-use-diff-faces))

(use-package evil-matchit
  :hook (evil-mode . global-evil-matchit-mode))

(use-package evil-surround
  :hook (evil-mode . global-evil-surround-mode))

(use-package evil-visualstar
  :hook (evil-mode . global-evil-visualstar-mode))

(use-package evil-indent-plus
  :after evil
  :bind
  (:map evil-inner-text-objects-map
        ("i" . evil-indent-plus-i-indent)
        ("I" . evil-indent-plus-i-indent-up)
        ("J" . evil-indent-plus-i-indent-up-down))
  (:map evil-outer-text-objects-map
        ("i" . evil-indent-plus-a-indent)
        ("I" . evil-indent-plus-a-indent-up)
        ("J" . evil-indent-plus-a-indent-up-down)))

(use-package evil-snipe
  :hook
  (evil-mode . evil-snipe-mode)
  (evil-mode . evil-snipe-override-mode)
  :config
  (setq evil-snipe-scope 'whole-buffer)
  (setq evil-snipe-repeat-scope 'whole-buffer))

(use-package evil-terminal-cursor-changer
  :when (not (display-graphic-p))
  :hook (evil-mode . etcc-on))

(use-package evil-leader
  :hook (evil-mode . global-evil-leader-mode)
  :config
  (setq evil-leader/leader "SPC")
  (evil-leader/set-key
    "SPC" 'execute-extended-command
    "T" 'emacs-init-time
    "p" 'projectile-command-map
    "ff" 'find-file
    "fs" 'swiper-isearch
    "fo" 'counsel-outline
    "fw" 'counsel-rg
    "fW" 'counsel-grep
    "fb" 'counsel-ibuffer
    "fr" 'counsel-recentf
    "fi" 'counsel-imenu
    "gl" 'avy-goto-line
    "gw" 'avy-goto-word-0
    "gc" 'avy-goto-char-timer
    "ww" 'ace-window
    "wd" 'delete-other-windows
    "wD" 'delete-window
    "tn" 'dired-sidebar-toggle-sidebar
    "tv" 'vundo
    "tm" 'minimap-mode
    "hd" 'helpful-at-point
    "hf" 'helpful-callable
    "hv" 'helpful-variable
    "hx" 'helpful-command
    "hk" 'helpful-key))

;;;; UI
(use-package catppuccin-theme)
(use-package zenburn-theme)
(use-package nord-theme)
(use-package nordic-night-theme)
(use-package spacemacs-theme)
(use-package gruvbox-theme)
(use-package ayu-theme)
(use-package seoul256-theme)
(use-package material-theme)
(use-package atom-one-dark-theme)
(use-package ef-themes)
(use-package kanagawa-themes)
(use-package standard-themes)
(use-package color-theme-sanityinc-tomorrow)
(use-package color-theme-sanityinc-solarized)

(use-package doom-themes
  :hook (after-init . (lambda () (load-theme 'doom-one t))))

(use-package dashboard
  :hook
  (after-init . dashboard-setup-startup-hook)
  :config
  (setq dashboard-display-icons-p t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-week-agenda nil)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-icon-file-height 1.25)
  (setq dashboard-icon-file-v-adjust -0.125)
  (setq dashboard-heading-icon-height 1.25)
  (setq dashboard-heading-icon-v-adjust -0.125)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-navigation-cycle t)
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-heading-shorcut-format " [%s]")
  (setq dashboard-item-shortcuts '((recents . "r")
                                   (bookmarks . "m")
                                   (projects . "p")
                                   (agenda . "a")
                                   (registers . "e")))
  (setq dashboard-items '((recents . 10)
                          (projects . 5)
                          (registers . 5))))

(use-package solaire-mode
  :hook
  (after-init . solaire-global-mode))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-bar-width 5)
  (setq doom-modeline-minor-modes t))

(use-package hide-mode-line
  :hook
  (completion-list-mode . hide-mode-line-mode)
  (dired-sidebar-mode . hide-mode-line-mode))

(use-package centaur-tabs
  :defer 10
  :config
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-height 25)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-icon-type 'nerd-icons)
  (setq centaur-tabs-gray-out-icons 'buffer)
  (setq centaur-tabs-set-bar 'over)
  (centaur-tabs-mode))

(use-package beacon
  :hook (prog-mode . beacon-mode)
  :config
  (setq beacon-blink-duration 0.5)
  (setq beacon-blink-delay 0.5)
  (setq beacon-size 50)
  (setq beacon-blink-when-focused t))

(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))

(use-package highlight-defined
  :when (<= emacs-major-version 30)
  :hook (emacs-lisp-mode . highlight-defined-mode))

(use-package indent-bars
  :hook
  ((prog-mode yaml-mode yaml-ts-mode) . indent-bars-mode)
  (emacs-lisp-mode . (lambda () (indent-bars-mode -1)))
  :config
  (setq indent-bars-display-on-blank-lines nil)
  (setq indent-bars-color '(font-lock-comment-face :face-bg nil :blend 0.4))
  (setq indent-bars-highlight-current-depth '(:face default :blend 0.4))
  (setq indent-bars-pattern ".")
  (setq indent-bars-width-frac 0.1)
  (setq indent-bars-pad-frac 0.1)
  (setq indent-bars-color-by-depth nil)
  (setq indent-bars-no-descend-string t)
  (setq indent-bars-prefer-character t)
  (setq indent-bars-no-stipple-char ?│))

(use-package breadcrumb
  :hook (prog-mode . breadcrumb-local-mode))

(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-grep
  :hook (grep-mode . nerd-icons-grep-mode))

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

;;;; WINDOW
(use-package winum
  :hook (after-init . winum-mode))

(use-package popper
  :bind
  (("C-`" . popper-toggle)
   ("M-`" . popper-cycle)
   ("C-M-`" . popper-toggle-type))
  :hook
  (window-setup . popper-mode)
  (popper-mode . popper-echo-mode)
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
          "\\*Apropos\\*$"
          "\\*Backtrace\\*$"
          "\\*Calendar\\*$"
          "\\*Fd\\*$" "\\*Find\\*$" "\\*Finder\\*$"
          "\\*Kill Ring\\*$"
          "\\*Embark \\(Collect\\|Live\\):.*\\*$"
          bookmark-bmenu-mode
          comint-mode
          compilation-mode
          help-mode helpful-mode
          tabulated-list-mode
          Buffer-menu-mode
          flymake-diagnostics-buffer-mode
          gnus-article-mode devdocs-mode
          grep-mode occur-mode rg-mode
          osx-dictionary-mode fanyi-mode
          "^\\*gt-result\\*$" "^\\*gt-log\\*$"
          "^\\*Process List\\*$" process-menu-mode cargo-process-mode
          "^\\*.*eshell.*\\*.*$" eshell-mode
          "^\\*ghostel\\*$" ghostel-mode
          "^\\*.*shell.*\\*.*$" shell-mode
          "^\\*.*terminal.*\\*.*$" term-mode
          "\\*DAP Templates\\*$" dap-server-log-mode
          "\\*ELP Profiling Results\\*" profiler-report-mode
          "\\*package update results\\*$" "\\*Package-Lint\\*$"
          "\\*[Wo]*Man.*\\*$"
          "\\*ert\\*$"
          "\\*gud-debug\\*$"
          "\\*lsp-help\\*$" "\\*lsp session\\*$"
          "\\*quickrun\\*$"
          "\\*vc-.*\\**"
          "\\*diff-hl\\**"
          "^\\*macro expansion\\**"
          "\\*Agenda Commands\\*" "\\*Org Select\\*" "\\*Capture\\*" "^CAPTURE-.*\\.org*"
          "\\*Gofmt Errors\\*$" "\\*Go Test\\*$" godoc-mode
          "\\*docker-.+\\*" "\\*prolog\\*" "\\*rustfmt\\*$"
          inferior-python-mode inf-ruby-mode swift-repl-mode)))

(use-package ligature
  :hook (after-init . global-ligature-mode)
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://")))

;;;; COMPLETION
(use-package ivy
  :hook (after-init . ivy-mode)
  :config
  (setq ivy-dynamic-exhibit-delay-ms 250)
  (setq ivy-height 17)
  (setq ivy-wrap t)
  (setq ivy-fix-height-minibuffer t)
  (setq ivy-use-virtual-buffers nil)
  (setq ivy-virtual-abbreviate 'full)
  (setq ivy-on-del-error-function #'ignore)
  (setq ivy-use-selectable-prompt t)
  (setq ivy-sort-max-size 7500)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format " [%d/%d] ")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order)))
  (setq ivy-more-chars-alist
        '((counsel-rg . 2)
          (counsel-search . 2)
          (t . 3))))

(use-package ivy-rich
  :hook (ivy-mode . ivy-rich-mode))

(use-package counsel-etags
  :commands counsel-etags-grep)

(use-package nerd-icons-ivy-rich
  :hook (ivy-mode . nerd-icons-ivy-rich-mode))

(use-package counsel
  :hook (ivy-mode . counsel-mode)
  :bind
  (("C-c r" . counsel-rg)
   ("C-c R" . counsel-grep-or-swiper-backward)
   ("C-c c" . counsel-load-theme)
   ("C-c i" . counsel-imenu)
   ("C-c F" . counsel-recentf)
   ("C-c o" . counsel-outline)))

(use-package amx
  :hook (ivy-mode . amx-mode))

(use-package swiper
  :bind
  (("C-s" . swiper-isearch)))

(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :config
  (setq wgrep-auto-save-buffer t))

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-limit 15)
  (setq company-tooltip-align-annotations t)
  (setq company-require-match 'never)
  (setq company-idle-delay 0.3)
  (setq company-global-modes '(not
                               erc-mode
                               help-mode
                               helpful-mode
                               gud-mode
                               vterm-mode))
  (setq company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend))
  (setq company-backends '((company-capf :with company-yasnippet)
                           (company-dabbrev-code company-keywords)
                           company-files))
  (setq company-auto-commit nil)
  (setq company-dabbrev-other-buffers nil)
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-downcase nil))

(use-package company-box
  :when (display-graphic-p)
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-icon-alist 'company-box-icons-all-the-icons)
  (setq company-box-show-single-candidate t)
  (setq company-box-backends-colors nil)
  (setq company-box-tooltip-limit 50))

;;;; Snippets
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets)

;;;; TOOL
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
  :hook
  ((prog-mode yaml-mode yaml-ts-mode) . symbol-overlay-mode)
  :bind
  (("M-i" . symbol-overlay-input)
   ("M-N" . symbol-overlay-jump-next)
   ("M-P" . symbol-overlay-jump-prev)
   ("M-R" . symbol-overlay-remove-all))
  :config
  (setq symbol-overlay-idle-time 0.3))

(use-package minimap
  :commands minimap-mode
  :config
  (setq minimap-update-delay 0.24)
  (setq minimap-width-fraction 0.16)
  (setq minimap-window-location 'right))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package colorful-mode
  :hook (prog-mode . colorful-mode))

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h x" . helpful-command)
   ("C-h k" . helpful-key)
   ("C-h C-d" . helpful-at-point)))

(use-package dired-sidebar
  :commands dired-sidebar-toggle-sidebar
  :config
  (setq dired-sidebar-theme 'nerd-icons)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(use-package avy
  :bind
  (("M-g l" . avy-goto-line)
   ("M-g w" . avy-goto-word-0)
   ("M-g c" . avy-goto-char-timer)))

(use-package vundo
  :commands vundo)

(use-package esup
  :commands esup
  :config
  (setq esup-depth 0))

(use-package symbols-outline
  :commands symbols-outline-show
  :hook
  ((lsp-mode eglot-managed-mode) . (lambda ()
                                     (setq-local symbols-outline-fetch-fn #'symbols-outline-lsp-fetch)
                                     (symbols-outline-follow-mode)))
  :config
  (setq symbols-outline-window-position 'right))

(use-package ace-window
  :bind
  (([remap other-window] . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package xclip
  :hook (after-init . xclip-mode))

(use-package gcmh
  :hook (after-init . gcmh-mode))

(use-package exec-path-from-shell
  :when (memq window-system '(mac ns x))
  :defer 5
  :config
  (exec-path-from-shell-initialize))

(use-package find-file-in-project
  :commands project-find-file)

;;;; VC
(use-package magit
  :commands magit-status
  :config
  (when (eq system-type 'windows-nt)
    (setq magit-commit-show-diff nil)
    (setq magit-diff-refine-hunk nil)))

;;;; LANGUAGE
(use-package lua-mode
  :mode "\\.lua\\'"
  :config
  (setq lua-indent-level 2)
  (setq lua-indent-nested-block-content-align nil)
  (setq lua-indent-close-paren-align nil))

(use-package csv-mode
  :mode "\\.[cq]sv\\'"
  :config
  (setq csv-separators '("," ";" "|" " ")))

(use-package clojure-mode
  :mode "\\.clj\\'")

(use-package haskell-mode
  :mode "\\.hs\\'")

(use-package go-mode
  :mode "\\.go\\'")

(use-package markdown-mode
  :mode "\\.md\\'"
  :config
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-enable-math t)
  (setq markdown-hide-markup nil)
  (setq markdown-command "pandoc"))

(use-package web-mode
  :mode "\\.p?html\\'")

(use-package typescript-mode
  :mode "\\.ts\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package json-mode
  :mode "\\.json\\'")

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package cmake-mode
  :mode "CMakeLists\\.txt\\'")

(use-package julia-mode
  :mode "\\.jl\\'")

(use-package ruby-mode
  :mode "\\.rb\\'")

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package vue-mode
  :mode "\\.vue\\'")

(use-package powershell
  :mode "\\.ps1\\'")

(use-package dotenv-mode
  :mode "\\.env\\'")

(use-package nginx-mode
  :mode "/nginx/.*\\.conf\\'")

(use-package php-mode
  :mode "\\.php\\'")

(use-package elixir-mode
  :mode "\\.exs?\\'")

(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)\\'")

(use-package uv-mode
  :commands uv-mode-auto-activate-hook
  :hook ((python-mode python-ts-mode) . uv-mode-auto-activate-hook))

(use-package slime)
(use-package vimrc-mode)
(use-package vala-mode)
(use-package toml-mode)
(use-package emmet-mode)
(use-package janet-mode)
(use-package angular-mode)
(use-package scss-mode)
(use-package sass-mode)
(use-package mmm-mode)
(use-package groovy-mode)
(use-package polymode)
(use-package erlang)
(use-package ess)
(use-package rjsx-mode)
(use-package dart-mode)
(use-package swift-mode)
(use-package kotlin-mode)
(use-package matlab-mode)
(use-package pandoc-mode)
(use-package jinja2-mode)
(use-package git-modes)

;;;; SYNTAX
(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :bind
  (("M-n" . flycheck-next-error)
   ("M-p" . flycheck-previous-error))
  :config
  (setq flycheck-emacs-lisp-load-path 'inherit)
  (setq flycheck-idle-change-delay 1.0)
  (setq flycheck-buffer-switch-check-intermediate-buffers t)
  (setq flycheck-display-errors-delay 0.24))

(use-package flycheck-popup-tip
  :hook (flycheck-mode . flycheck-popup-tip-mode)
  :config
  (setq flycheck-popup-tip-error-prefix "[!] "))

;;;; FORMAT
(use-package apheleia
  :hook (prog-mode . apheleia-mode))

;;;; WORKSPACE
(use-package projectile
  :hook (after-init . projectile-mode)
  :bind
  (:map projectile-mode-map
        ("C-c p" . projectile-command-map)))

(use-package persp-mode
  :hook (after-init . persp-mode)
  :config
  (setq persp-autokill-buffer-on-remove 'kill-weak)
  (setq persp-reset-windows-on-nil-window-conf nil)
  (setq persp-nil-hidden t)
  (setq persp-auto-save-fname "autosave")
  (setq persp-set-last-persp-for-new-frames t)
  (setq persp-switch-to-added-buffer nil)
  (setq persp-kill-foreign-buffer-behaviour 'kill)
  (setq persp-remove-buffers-from-nil-persp-behaviour nil)
  (setq persp-auto-resume-time -1)
  (setq persp-auto-save-opt (if noninteractive 0 1)))

(use-package persp-mode-projectile-bridge
  :after (persp-mode projectile)
  :hook
  (persp-mode . persp-mode-projectile-bridge-mode)
  (persp-mode-projectile-bridge-mode . (lambda ()
                                         (if persp-mode-projectile-bridge-mode
                                             (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
                                           (persp-mode-projectile-bridge-kill-perspectives)))))

;;;; LSP & DAP
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-log-io nil)
  ;; (setq lsp-use-plists t)
  (setq lsp-idle-delay 0.5)
  (setq lsp-completion-provider :capf)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-lens-enable nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-text-document-color nil)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-file-watch-threshold 2000)
  (setq lsp-semantic-tokens-enable 'deferred))

(use-package lsp-pyright
  :hook
  ((python-mode python-ts-mode) . (lambda ()
                                    (require 'lsp-pyright)
                                    (setq lsp-pyright-langserver-command "basedpyright"))))

(use-package lsp-ui
  :commands lsp-ui-mode
  :after lsp-mode
  :bind (:map lsp-mode-map
              ("C-c l d" . lsp-ui-doc-glance))
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-delay 0.5)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-code-actions nil)
  (setq lsp-ui-sideline-delay 0.5)
  (setq lsp-ui-peek-enable t)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-ui-imenu-enable nil))

(use-package dap-mode
  :commands (dap-debug dap-debug-edit-template)
  :after lsp-mode
  :config
  (setq dap-auto-configure-features '(sessions locals controls tooltip))
  (setq dap-auto-show-output nil))

(use-package dape
  :commands dape
  :config
  (setq dape-buffer-window-arrangement 'right))

(use-package mason
  :when (not (eq system-type 'windows-nt))
  :hook (prog-mode . (lambda ()
                       (require 'mason)
                       (mason-setup))))

;;;; TERMINAL
(use-package ghostel
  :when (not (eq system-type 'windows-nt))
  :commands ghostel)

(use-package eat
  :when (not (eq system-type 'windows-nt))
  :commands eat)

(use-package eshell-syntax-highlighting
  :hook (eshell-mode . eshell-syntax-highlighting-mode))

;;; init.el ends here
