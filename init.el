(setq ring-bell-function 'ignore)
;; set tab indent to 2 spaces
(setq-default tab-width 2)
;; apply linting on save
(setq-default flycheck-emacs-lisp-load-path 'inherit)
;;set default font to MonoLisa Nerd Font with size 14
(set-face-attribute 'default nil :font "MonoLisa Nerd Font" :height 100)
(set-frame-parameter nil 'alpha-background 70)

(add-to-list 'default-frame-alist '(alpha-background . 70))

(defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)


(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(add-to-list 'custom-theme-load-path "~/emacs.d/themes/")
(load-theme 'zenburn t)

(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)


(unless (package-installed-p 'editorconfig)
  (package-install 'editorconfig))

;;Install Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
  (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
    (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
      (url-retrieve-synchronously
        "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
        'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t)
(add-hook 'prog-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)

;; install org mode with straight.el
(straight-use-package 'org)
(require 'org)

(evil-mode 1)
(use-package evil
	:straight t
	:ensure t)

(add-to-list 'load-path "~/.emacs.d/evil/")
(use-package evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key "." 'find-file)

(straight-use-package 'emacs-everywhere)

;; Install magit 
(straight-use-package 'magit)

;;lsp mode
(use-package lsp-mode
	:straight t)
(add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                  :major-modes '(nix-mode)
                  :server-id 'nix))

(use-package nix-mode
  :mode "\\.nix\\'")

;;Tree sitter
(use-package tree-sitter
	:straight t
	:config
	(require 'tree-sitter-langs)
	(global-tree-sitter-mode)
	(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(add-to-list 'load-path "~/elisp-tree-sitter/core")
(add-to-list 'load-path "~/elisp-tree-sitter/lisp")
(add-to-list 'load-path "~/elisp-tree-sitter/langs")

(require 'tree-sitter)
(require 'tree-sitter-hl)
(require 'tree-sitter-langs)
(require 'tree-sitter-debug)
(require 'tree-sitter-query)

(global-tree-sitter-mode)

;; haskell mode
(use-package haskell-mode
	:straight t
	:config
	(add-hook 'haskell-mode-hook 'interactive-haskell-mode))