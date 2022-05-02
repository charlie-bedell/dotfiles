(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-buffer-menu t)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(package-selected-packages
	 '(helm exec-path-from-shell slime json-mode flycheck lsp-mode ac-html typescript-mode subatomic-theme tangotango-theme flymd flycheck-kotlin kotlin-mode markdown-mode smart-tab smartparens crux multiple-cursors dockerfile-mode magit dash transient flymake ace-window python swiper))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-ff-directory ((t (:extend t :foreground "DeepSkyBlue1"))))
 '(helm-ff-file ((t (:foreground "lightgrey"))))
 '(helm-selection ((t (:background "gray27" :distant-foreground "white"))))
 '(highlight ((t (:background "#3C4446" :foreground "lightgrey"))))
 '(hl-line ((t (background "#3C4446"))))
 '(markdown-header-face-1 ((t (:inherit outline-1 :foreground "#19d1ff"))))
 '(markdown-header-face-2 ((t (:inherit outline-2 :foreground "#46e83a"))))
 '(markdown-header-face-3 ((t (:inherit outline-3 :foreground "#F8A51C"))))
 '(markdown-header-face-4 ((t (:inherit outline-4 :foreground "#FBF52D"))))
 '(markdown-header-face-5 ((t (:inherit outline-5 :foreground "#F57FDF"))))
 '(markdown-header-face-6 ((t (:inherit outline-6 :foreground "#C581FA")))))
(load-theme 'tango-dark t)
;; add melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
;; basic custom settings
(global-set-key (kbd "C-s") 'swiper)
;; helm
(helm-mode 1)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq scroll-step 1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-hl-line-mode +1)
;; smartparens settings
(smartparens-global-mode +1)
(show-smartparens-global-mode +1)
;; adding "'" and "`" pairs are already including, adding then removing them locally
;; will remove them for a specific mode
(sp-local-pair 'lisp-mode "'" "'")
(sp-local-pair 'lisp-mode "`" "`")
(sp-local-pair 'lisp-mode "'" "'" :actions :rem)
(sp-local-pair 'lisp-mode "`" "`" :actions :rem)
(sp-local-pair 'markdown-mode "*" "*")
(sp-local-pair 'markdown-mode "**" "**")
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-c C-s") 'replace-string)
;; crux makes it so you can jump to beginning of line or begging of text if there is whitespace
(global-set-key (kbd "C-a") 'crux-move-beginning-of-line)
;; tabs instead of spaces
(setq-default indent-tabs-mode t)
(setq-default tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)
;; multiple cursors keybidings
(global-set-key (kbd "C-c C-n") 'mc/mark-next-lines)
;;(global-set-key (kbd "C-c C-p") 'mc/mark-previous-lines) ;;marks 2 lines instead of 1 above, not sure why


(setq inferior-lisp-program "/usr/local/bin/sbcl") ; your Lisp system
(add-to-list 'load-path "~/.slime") ; your SLIME directory
(require 'slime)
(slime-setup)
;; make tsx files open with typescript mode
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
;; make .el files open with SLIME minor mode
(add-to-list 'auto-mode-alist '("\\.el\\'" . slime-mode))
(add-to-list 'auto-mode-alist '("\\.el\\'" . show-paren-mode))
(add-to-list 'auto-mode-alist '("\\.el\\'" . lisp-mode))
;; make markdown files open with markdown-mode and fill mode
(setq-default set-fill-column 89)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook (lambda () (auto-fill-mode 1)))
