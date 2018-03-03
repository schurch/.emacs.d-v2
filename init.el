;;; init.el --- Stef's Emacs config
;;; Commentary:
;;; Basic Emacs config

;;; Code:

;; Keybindings
(global-set-key (kbd "C-x f") #'helm-recentf)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x b") #'helm-buffers-list)

(setq tab-always-indent 'complete)

(setq save-interprogram-paste-before-kill t)

;; Scroll only half-pages.
(require 'view)
(global-set-key "\C-v" 'View-scroll-half-page-forward)
(global-set-key "\M-v" 'View-scroll-half-page-backward)

(setq mouse-wheel-scroll-amount '(1))
(setq ring-bell-function 'ignore)

;; Packages
(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Rails
(projectile-rails-global-mode)
(add-hook 'ruby-mode-hook 'robe-mode)

;; Helm
(require 'helm-config)
(helm-mode 1)
(setq helm-mode-fuzzy-match t)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

;; General setup
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(global-linum-mode t)
(windmove-default-keybindings)

(setq inhibit-startup-screen t)
(defalias 'yes-or-no-p 'y-or-n-p)

(add-hook 'window-setup-hook 'toggle-frame-maximized t)

(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

;; Exec path from shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Company
(require 'company)
(add-to-list 'company-backends 'company-elm)
(eval-after-load 'company '(push 'company-robe company-backends))
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 2)

;; Elm mode
(require 'elm-mode)
(setq elm-format-on-save t)
(setq elm-tags-on-save t)

;; Haskell
(add-hook 'haskell-mode-hook 'intero-mode)
(eval-after-load "haskell-mode"
  '(define-key haskell-mode-map (kbd "C-c C-b") 'haskell-compile))
(setq haskell-compile-cabal-build-command "stack build")

(defun update-haskell-tags ()
  "Update the haskell tags."
  (when (eq major-mode 'haskell-mode)
    (shell-command-to-string (format "hasktags --ignore-close-implementation -e -o \"%s/TAGS\" \"%s\"" (projectile-project-root) (projectile-project-root)))))

(add-hook 'after-save-hook #'update-haskell-tags)
(setq tags-revert-without-query 1)

;; Flycheck
(add-hook 'after-init-hook 'global-flycheck-mode)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-elm-setup))

;; Projectile
(projectile-mode)

;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;; Move text
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

;; Web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.leaf?\\'" . web-mode))

;; Emmet
(add-hook 'web-mode-hook 'emmet-mode)

;; Dockerfile
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(require 'docker-compose-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("65a2801c39211a69af6cc4c8441f3f51871404b9d12a6f2966a7bc33468995c7" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" default)))
 '(package-selected-packages
   (quote
    (docker-compose-mode dockerfile-mode docker emmet-mode impatient-mode skewer-mode web-mode drag-stuff doom-themes dracula-theme paredit multi-web-mode js2-mode idris-mode robe projectile-rails helm exec-path-from-shell projectile yaml-mode magit flycheck-elm elm-mode intero company flycheck))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
