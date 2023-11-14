(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
	 '(web-mode markdown-mode yaml ace-window helm ivy tree-sitter treemacs yaml-mode use-package typescript-mode tree-sitter-langs terraform-mode swiper solo-jazz-theme smart-tab slime rust-mode rjsx-mode rainbow-mode org-roam nano-theme nano-modeline multiple-cursors modus-themes magit json-mode indicators focus flymd flycheck fish-mode exec-path-from-shell esup elisp-format doom-themes dockerfile-mode devdocs crux company-lua cider ac-html)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; beginning of custom init
;; help debug on error
;; (when init-file-debug
;;   (setq use-package-verbose t
;;         use-package-expand-minimally nil
;;         use-package-compute-statistics t
;;         debug-on-error t))

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(require 'indicators)
(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
		   (format "%.2f seconds"
				   (float-time
		    (time-subtract after-init-time before-init-time)))
	   gcs-done))
(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; load custom ayu-dark theme, else load tango-dark
 (add-to-list 'custom-theme-load-path "~/dotfiles/")
 (if (file-exists-p "~/dotfiles/ayu-dark-theme.el")
     (load-theme 'ayu-dark t)
   (load-theme 'tango-dark t))

;; insert a python code block into an org file
(defun pyorg ()
  "Append STRING to the end of BUFFER."
  (interactive)
  (with-current-buffer (current-buffer)
    (save-excursion
      (insert "#+begin_src python /usr/local/bin/python3 \
:results output\n\n#+end_src\n#+RESULTS:")))
  (forward-char 12))

(defun scroll-up-by (arg)
	"Scroll document up by ARG lines."
	(forward-line arg)
	(scroll-up arg))

(defun scroll-down-by (arg)
	"Scroll document down by ARG lines."
	(forward-line (- arg))
	(scroll-down arg))

(use-package use-package
    :custom
  (use-package-always-pin "nongnu"))

;; M-x describe-personal-keybindings to see all your keybinds
(use-package emacs
  :config
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (delete-selection-mode 1)
  (global-hl-line-mode 1)
  (global-auto-revert-mode 1)
  :custom
	(vc-follow-symlinks t)
  (inhibit-startup-buffer-menu 1)
  (inhibit-startup-screen 1)
  (add-to-list 'exec-path "~/.nvm/version/node/v19.7.0/bin/")
  (fringe-mode 8)
  (fill-column 80)
  (tab-width 2)
  (scroll-step 1)
	(scroll-conservatively 200)
  (exec-path (append exec-path '("/usr/local/bin")))
  (ring-bell-function 'ignore)
  (global-auto-revert-non-file-buffers t)
  :bind
  ("C-c C-s" . replace-string)
  ("C-;" . comment-or-uncomment-region)
  ("C-a" . crux-move-beginning-of-line)
	("C-s" . swiper)
	("C-v" . (lambda () (interactive) (scroll-up-by 5)))
	("M-v" . (lambda () (interactive) (scroll-down-by 5)))
  :hook (
	 (prog-mode . display-line-numbers-mode)
	 (prog-mode . multiple-cursors-mode)
	 (prog-mode . column-number-mode)
	 (prog-mode . display-fill-column-indicator-mode)
	 (prog-mode . global-flycheck-mode)
	 (prog-mode . global-company-mode)))

(use-package helm
	:custom
	(helm-autoresize-mode 1)
	(helm-autoresize-max-height 0)
	(helm-autoresize-min-height 28)
	(helm-full-frame nil)
	(helm-buffer-in-new-frame-p nil)
	(helm-split-window-inside-p t)
	(helm-buffers-truncate-lines t)
	(helm-mini-default-sources '(helm-source-buffers-list helm-source-recentf))
	(helm-boring-file-regexp-list '("\\~$" "[#]*[#]" "\\#*\\#"))
	(helm-ff-skip-boring-files t)
	(helm-mode 1)
	:bind
	("C-x C-f" . helm-find-files)
	("C-x b" . helm-mini)
	("M-x" . helm-M-x)
	:custom-face
  (helm-ff-directory ((t (:extend t :foreground "DeepSkyBlue1" :background unspecified))))
  (helm-ff-file ((t (:foreground "lightgrey"))))
  (helm-selection ((t (:background "gray27" :distant-foreground "white")))))

(use-package org
  :ensure nil
  :config
	(defvar org-capture-templates)
	(defvar org-agenda-timegrid-use-ampm)
  (setq org-agenda-files '("~/RoamNotes/todo.org" "~/RoamNotes/journal/" "~/RoamNotes/projects/")
				org-directory "~/RoamNotes"
				org-default-notes-file (concat org-directory "/notes.org")
				org-agenda-timegrid-use-ampm 1
				
				org-capture-templates
				'(("t" "Todo" entry (file+headline "~/RoamNotes/todo.org" "Tasks")
					 "* TODO %?\n  %i\n  %a")
					("j" "Journal" entry (file+datetree "~/RoamNotes/journal.org")
					 "* %?\nEntered on %U\n  %i\n  %a"))
				org-hide-emphasis-markers t)
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
	("C-c q" . org-tags-view)
  :hook
  ((org-mode . auto-fill-mode)
   (org-mode . display-fill-column-indicator-mode)
   (org-mode . ivy-mode)
   (org-mode . (lambda () (local-set-key "\M-." 'org-open-at-point)))
   (org-mode . (lambda () (local-set-key "\M-," 'org-mark-ring-goto))))
  :custom-face
	)

(use-package org-agenda
	:ensure nil
	:commands (org-agenda-skip-entry-if org-agenda-files)
	:config
	(setq org-agenda-custom-commands
				'(("c" . "custom views")
					("ca" "todo and waiting entries across all of roamNotes" agenda "TODO|WAITING"
					 ((org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO" "WAITING")))
						(org-agenda-files (file-expand-wildcards "~/RoamNotes/*.org"))))
				("ct" "list all todos" todo ""
				 ((org-agenda-files (file-expand-wildcard "~/RoamNotes/*.org")))))))

(use-package org-roam
	:defer t
  :ensure t
	:config
	(org-roam-db-autosync-enable)
	(require 'org-roam-dailies)
	(defvar org-mode-map)
	(defvar org-roam-dailies-map)
  :custom
	(org-roam-directory "~/RoamNotes" "~/RoamNotes/rolodex")
  (org-roam-dailies-directory "journal/")
  (org-roam-complete-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      (file "~/RoamNotes/templates/default_note_template.org")
      :if-new (file+head "${slug}.org" "#+TITLE: ${title}\n#+DATE: %U\n#+FILETAGS:\n")
      :unnarrowed t)
     ("p" "project" plain
      (file "~/RoamNotes/templates/project_note_template.org")
      :if-new (file+head "projects/${slug}.org" "#+TITLE: ${title}\n#+FILETAGS: Project")
      :unnarrowed t)
		 ("r" "rolodex" plain
      (file "~/RoamNotes/templates/rolodex_template.org")
      :if-new (file+head "rolodex/${slug}.org" "#+TITLE: ${title}\n#+DATE: %U\n#+FILETAGS: Rolodex\n")
      :unnarrowed t)))
	
	(org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org" "#+TITLE: %<%Y-%m-%d>\n#+FILETAGS: Journal"))))
  (org-roam-node-display-template
   (concat "${title:*} "
					 (propertize "${tags:50}" 'face 'org-tag)))
  :bind
  (("C-c n c" . org-roam-capture)
   ("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   :map org-mode-map
   ("C-M-i" . completion-at-point)
	 
   :map org-roam-dailies-map
   ;; ("Y" . org-roam-dailies-capture-yesterday)
	 ("T" . org-roam-dailies-capture-tomorrow))
	:bind-keymap
	("C-c n d" . org-roam-dailies-map))

(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)
  :custom
  (ivy-height 15)
  (ivy-count-format "(%d/%d)"))

(use-package term
	:commands (term-set-escape-char term-mode term-char-mode pb-copy)
  :config
  (term-set-escape-char 24) ;; set escape char from C-c to C-x
  (setq explicit-shell-file-name "/bin/zsh")

  (defun term (buffer-name)
    "Start a terminal and rename buffer."
    (interactive "Mbuffer name: terminal")
    (setq buffer-name (concat "terminal" buffer-name))
    (set-buffer (make-term buffer-name "/bin/zsh"))
    (term-mode)
    (term-char-mode)
    (switch-to-buffer (concat "*" buffer-name "*")))

  (if (display-graphic-p)
			()
		(defun pbcopy ()
			(interactive)
			(call-process-region (point) (mark) "pbcopy")
			(setq deactivate-mark t))

		(defun pbpaste ()
			(interactive)
			(call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

		(defun pbcut ()
			(interactive)
			(declare-function pbcopy ".emacs")
			(pbcopy)
			(delete-region (region-beginning) (region-end)))
		(global-set-key (kbd "M-w") 'pbcopy)
		(global-set-key (kbd "C-y") 'pbpaste)
		(global-set-key (kbd "C-w") 'pbcut))
  :custom-face
  (term-color-blue ((t (:foreground "DeepSkyblue1"))))
  (term-color-cyan ((t (:foreground "DeepSkyblue1"))))
  (term-color-magenta ((t (:foreground "lightgrey"))))
  (term-color-red ((t (:foreground "#fc3d3d"))))
	;; remove bold, better fix would be to modify LS_COLORS to remove bold
	(term-bold ((t (:inherit nil)))))

(use-package ace-window
	:custom
	(aw-ignore-on nil)
	:bind
	("C-x o" . ace-window))

(use-package markdown-mode
	:hook
	(markdown-mode . auto-fill-mode))

(use-package focus
	:custom-face
	(focus-unfocused ((t (:foreground "gray35")))))

(use-package multiple-cursors-mode
	:bind
	("C-c C-n" . mc/mark-next-lines)
	("C-c C-p" . mc/mark-previous-lines))

(use-package electric-pair-mode
	:hook
	(prog-mode . electric-pair-local-mode))

(use-package eglot
	:custom
	(eglot-events-buffer-size 0) ; if debugging, set to 2000000
	:custom-face
	(eglot-highlight-symbol-face ((t (:background "gray40")))))

;; (use-package lsp-mode
;; 	:defer t
;; 	:custom
;; 	(gc-cons-threshold 10000000)
;; 	(read-process-output-max (* 1024 1024))
;; 	(company-idle-delay 0.2)
;; 	(company-minimum-prefix-length 1)
;; 	(lsp-idle-delay 0.5)
;; 	(lsp-log-io nil) ; if set to true can cause performance hit
;; 	(lsp-ui-doc-show-with-mouse nil)
;; 	:hook
;; 	(typescript-mode . lsp)
;; 	(rjsx-mode . lsp)
;; 	(rust-mode . lsp)
;; 	(c-mode . lsp)
;; 	(c++-mode . lsp)
;; 	(python-mode . lsp)
;; 	)

(use-package treemacs
	:defer t
	:init
	(add-to-list 'image-types 'svg)
	(setq treemacs--icon-size 12)
	(setq treemacs-indentation 1)
	(setq treemacs-indentation-string (propertize " ┃" 'face 'font-lock-comment-face)))

(use-package devdocs
	:defer t
	:bind
	("C-c C-d C-c" . 'devdocs-lookup)
	)

;; keybindings
(global-set-key (kbd "C-c p") 'pyorg)

;; TODO figure out if i need this
;; (require 'tree-sitter-langs)
;; (global-tree-sitter-mode 1)
;; (lsp-treemacs-sync-mode 1)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; hooks
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(require 'term)
(define-key term-raw-map (kbd "C-y") 'term-paste) ;; cant put these
(define-key term-raw-map (kbd "s-v") 'term-paste) ;; in use-package?

(use-package typescript-mode
  :mode ("\\.tsx\\'" "\\.ts\\'"))

(use-package rjsx-mode
  :mode ("\\.jsx\\'" "\\.js\\'"))

(use-package rust-mode
  :mode ("\\.rs\\'"))


(use-package js2-mode
	:defer t
	:config
	(setq js-indent-level 2)
	(setq js2-basic-offset 2))

(use-package conf-mode
  :mode ("\\.*rc\\'"))

(use-package fish-mode
  :mode ("\\.*fish\\'"))

(use-package web-mode
	:mode ("\\.*html\\'")
	:custom
	(web-mode-enable-current-element-highlight t)
	(web-mode-markup-indent-offset 2))

(setq org-confirm-babel-evaluate nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)  ; in my case /bin/bash
   (python . t)))

(provide '.emacs)
;;; .emacs ends here
