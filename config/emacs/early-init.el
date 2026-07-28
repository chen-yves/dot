;;; early-init.el --- Early initialization. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq package-enable-at-startup nil)
(setq use-package-enable-imenu-support t)
(setq load-prefer-newer t)
(setq read-process-output-max (* 3 1024 1024))
(let ((default-gc-cons-percentage gc-cons-percentage)
      (default-gc-cons-threshold gc-cons-threshold)
      (default-file-name-handler-alist file-name-handler-alist)
      (default-load-suffixes load-suffixes)
      (default-load-file-rep-suffixes load-file-rep-suffixes))
  (setq gc-cons-percentage 1.0)
  (setq gc-cons-threshold most-positive-fixnum)
  (setq file-name-handler-alist nil)
  (setq load-suffixes '(".elc" ".el"))
  (setq load-file-rep-suffixes '(""))
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq gc-cons-percentage default-gc-cons-percentage)
              (setq gc-cons-threshold default-gc-cons-threshold)
              (setq load-suffixes default-load-suffixes)
              (setq load-file-rep-suffixes default-load-file-rep-suffixes)
              (setq file-name-handler-alist default-file-name-handler-alist))
            101))
(setq-default initial-scratch-message
              (concat ";; Happy hacking, " user-login-name " - Emacs ♥ you!\n\n"))
(when (boundp 'load-path-filter-function)
  (setq load-path-filter-function #'load-path-filter-cache-directory-files))
(prefer-coding-system 'utf-8-unix)
(setq-default buffer-file-coding-system 'utf-8-unix)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq frame-inhibit-implied-resize t)
(setq initial-major-mode 'fundamental-mode)
(setq default-frame-alist '((menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (internal-border-width . 12)
                            (horizontal-scroll-bars . nil)
                            (vertical-scroll-bars . nil)))

;;; early-init.el ends here
