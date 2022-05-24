(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-boring-file-regexp-list '("\\~$"))
 '(helm-buffers-truncate-lines t)
 '(helm-mini-default-sources '(helm-source-buffers-list helm-source-recentf))
 '(inhibit-startup-buffer-menu t)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(package-selected-packages
	 '(rjsx-mode js2-mode use-package typescript-mode tree-sitter-langs helm-lsp lsp-treemacs company lsp-ui tree-sitter helm exec-path-from-shell slime json-mode flycheck lsp-mode ac-html flymd markdown-mode smart-tab smartparens crux multiple-cursors dockerfile-mode magit dash transient ace-window python swiper)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-ff-directory ((t (:extend t :foreground "DeepSkyBlue1"))))
 '(helm-ff-file ((t (:foreground "lightgrey"))))
 '(helm-selection ((t (:background "gray27" :distant-foreground "white"))))
 '(sp-pair-overlay-face ((t (:inherit region))))
 '(hl-line ((t (:extend t :background "#3C4446"))))
 '(markdown-header-face-1 ((t (:inherit outline-1 :foreground "#19d1ff"))))
 '(markdown-header-face-2 ((t (:inherit outline-2 :foreground "#46e83a"))))
 '(markdown-header-face-3 ((t (:inherit outline-3 :foreground "#F8A51C"))))
 '(markdown-header-face-4 ((t (:inherit outline-4 :foreground "#FBF52D"))))
 '(markdown-header-face-5 ((t (:inherit outline-5 :foreground "#F57FDF"))))
 '(markdown-header-face-6 ((t (:inherit outline-6 :foreground "#C581FA"))))
 '(term-color-blue ((t (:foreground "DeepSkyblue1"))))
 '(term-color-cyan ((t (:foreground "white"))))
 '(term-color-magenta ((t (:foreground "lightgrey"))))
 '(term-color-red ((t (:foreground "#fc3d3d")))))
;; add melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; basic custom settings
(load-theme 'tango-dark t)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq scroll-step 1)
(global-hl-line-mode 1)
(smartparens-global-mode 1)
(show-smartparens-global-mode 1)
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq ring-bell-function 'ignore)
(setq-default set-fill-column 89)
(setq aw-ignore-on nil) ; allow treemacs with ace-window
;; (setq-default indent-tabs-mode t)
;; (setq-default tab-width 2) ; set tabs to be two spaces long
;; (defvaralias 'c-basic-offset 'tab-width)
(delete-selection-mode 1)

;; LSP
(use-package lsp-mode
	:config
	(require 'lsp-mode)
	(setq gc-cons-threshold       10000000
				read-process-output-max (* 1024 1024)
				lsp-idle-delay          0.500
				lsp-log-io              nil ; if set to true can cause performance hit
				)
	:hook
	((typescript-mode . lsp)
	 (rjsx-mode . lsp)))

;; helm
(use-package helm
	:config
	(require 'helm-config)
	(setq helm-autoresize-mode       1
				helm-autoresize-max-height 30
				helm-autoresize-min-height 30
				helm-full-frame            nil
				helm-buffer-in-new-frame-p nil
				helm-split-window-inside-p t
				;; helm-boring-file-regexp-list edited in custom-variables
				helm-ff-skip-boring-files  t)
	:bind
	("C-x C-f" . helm-find-files)
	("C-x b" . helm-mini)
	("M-x" . helm-M-x))
(helm-mode 1)

;; term
(require 'term)
(defun term-use-sensible-escape-char (&rest ignored)
  (term-set-escape-char 24)) ;; changes escape char from C-c to C-x
(advice-add 'term :after #'term-use-sensible-escape-char)
(setq explicit-shell-file-name '"/bin/zsh")

(defun term (buffer-name)
	"Start a terminal and rename buffer."
	(interactive "Mbuffer name: terminal")
	(setq buffer-name (concat "terminal" buffer-name))
	(set-buffer (make-term buffer-name "/bin/zsh"))
	(term-mode)
	(term-char-mode)
	(switch-to-buffer (concat "*" buffer-name "*")))

;; keybindings
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-c C-s") 'replace-string)
(global-set-key (kbd "C-a") 'crux-move-beginning-of-line)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c C-n") 'mc/mark-next-lines)
;; smartparens pairs
(sp-local-pair 'lisp-mode "'" "'") ;; adds pair so they can be removed
(sp-local-pair 'lisp-mode "`" "`")
(sp-local-pair 'lisp-mode "'" "'" :actions :rem)
(sp-local-pair 'lisp-mode "`" "`" :actions :rem)
(sp-local-pair 'markdown-mode "*" "*")
(sp-local-pair 'markdown-mode "**" "**")
(sp-local-pair 'typescript-mode "<" ">")
(sp-local-pair 'python-mode "'''" "'''")
(sp-local-pair 'python-mode "\"\"\"" "\"\"\"")

;; setup for slime and lisp
(setq inferior-lisp-program "/usr/local/bin/sbcl") ; your Lisp system
(add-to-list 'load-path "~/.slime") ; your SLIME directory
(require 'slime)
(slime-setup)

(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode 1)

(global-flycheck-mode 1)
(global-company-mode 1)
(lsp-treemacs-sync-mode 1)

(when (memq window-system '(mac ns x))
	(exec-path-from-shell-initialize))

;; hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'multiple-cursors-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
(add-hook 'markdown-mode-hook (lambda () (auto-fill-mode 1)))
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;; (add-hook 'rjsx-mode-hook #'(lambda () (setq-local electric-indent-inhibit t))) ;; not using this but keeping for reference

(setq auto-mode-alist
      (append '(("\\.tsx\\'" . typescript-mode)
		("\\.ts\\'" . typescript-mode)
		("\\.jsx\\'" . rjsx-mode)
		("\\.js\\'" . rjsx-mode))
	      ;;("\\.jsx\\'" . font-lock-mode)
	      ;;("\\.tsx\\'" . font-lock-mode)
	      ;;("\\.css\\'" . web-mode))
	      auto-mode-alist))

;;; .emacs ends here
