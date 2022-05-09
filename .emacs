(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-buffer-menu t)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(package-selected-packages
	 '(typescript-mode tree-sitter-langs helm-lsp lsp-treemacs company lsp-ui tree-sitter helm exec-path-from-shell slime json-mode flycheck lsp-mode ac-html flymd markdown-mode smart-tab smartparens crux multiple-cursors dockerfile-mode magit dash transient ace-window python swiper)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-ff-directory ((t (:extend t :foreground "DeepSkyBlue1"))))
 '(helm-ff-file ((t (:foreground "lightgrey"))))
 '(helm-selection ((t (:background "gray27" :distant-foreground "white"))))
 '(highlight ((t (:background "#3C4446" :foreground "lightgrey"))))
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
(helm-mode 1)
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
(setq-default indent-tabs-mode t)
(setq-default tab-width 2) ; set tabs to be two spaces long
(defvaralias 'c-basic-offset 'tab-width)

;;term
(defun term-use-sensible-escape-char (&rest ignored)
  (term-set-escape-char 24))
(advice-add 'term :after #'term-use-sensible-escape-char)
(setq explicit-shell-file-name '"/bin/zsh")

;; keybindings
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-c C-s") 'replace-string)
(global-set-key (kbd "C-a") 'crux-move-beginning-of-line)
(global-set-key (kbd "C-c C-n") 'mc/mark-next-lines) ;; multi-cursor
;; (global-set-key (kbd "C-c C-p") 'mc/mark-previous-lines) ;; marks 2 lines instead of 1 above, not sure why
(sp-local-pair 'lisp-mode "'" "'") ;; adds pair so they can be removed
(sp-local-pair 'lisp-mode "`" "`")
(sp-local-pair 'lisp-mode "'" "'" :actions :rem)
(sp-local-pair 'lisp-mode "`" "`" :actions :rem)
(sp-local-pair 'markdown-mode "*" "*")
(sp-local-pair 'markdown-mode "**" "**")

;; setup for slime and lisp
(setq inferior-lisp-program "/usr/local/bin/sbcl") ; your Lisp system
(add-to-list 'load-path "~/.slime") ; your SLIME directory
(require 'slime)
(slime-setup)

;; LSPs
(require 'lsp-mode)
(add-hook 'typescript-mode-hook #'lsp)
(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode 1)
(global-flycheck-mode 1)
(global-company-mode 1)
(lsp-treemacs-sync-mode 1)

;; set with guidance from lsp-doctor to improve performance of lsp-mode
(setq gc-cons-threshold 10000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-idle-delay 0.500)
(setq lsp-log-io nil) ; if set to true can cause a performance hit
(when (memq window-system '(mac ns x))
	(exec-path-from-shell-initialize))

;; hooks
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-hook 'typescript-mode 'lsp-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
(add-hook 'markdown-mode-hook (lambda () (auto-fill-mode 1)))
;; TODO: add hooks for language major modes

;;; .emacs ends here
