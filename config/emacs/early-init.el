;;; early-init.el --- Early initialization. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq package-enable-at-startup nil)
(setq gc-cons-percentage 1.0)
(setq gc-cons-threshold most-positive-fixnum)
(setq read-process-output-max #x10000)
(let ((default-file-name-handler-alist file-name-handler-alist)
      (default-load-suffixes load-suffixes)
      (default-load-file-rep-suffixes load-file-rep-suffixes))
  (setq file-name-handler-alist nil
        load-suffixes '(".elc" ".el")
        load-file-rep-suffixes '(""))
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq load-suffixes default-load-suffixes
                    load-file-rep-suffixes default-load-file-rep-suffixes
                    file-name-handler-alist default-file-name-handler-alist))
            101))
(when (boundp 'load-path-filter-function)
  (setq load-path-filter-function #'load-path-filter-cache-directory-files))
(setq load-prefer-newer noninteractive)
(prefer-coding-system 'utf-8)
(setq use-package-enable-imenu-support t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq frame-inhibit-implied-resize t)
(setq initial-major-mode 'fundamental-mode)
(setq default-frame-alist '((menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (internal-border-width . 12)
                            (horizontal-scroll-bars)
                            (vertical-scroll-bars)))

;;; early-init.el ends here
