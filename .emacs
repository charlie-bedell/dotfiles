(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil)
 '(custom-safe-themes
	 '("7082b82fc7c747fc1753de8f2648b34a4aa4138cd959ae2b5c80d6b81ad64f85" "de8f2d8b64627535871495d6fe65b7d0070c4a1eb51550ce258cd240ff9394b0" "e7820b899036ae7e966dcaaec29fd6b87aef253748b7de09e74fdc54407a7a02" default))
 '(org-link-frame-setup
	 '((vm . vm-visit-folder-other-frame)
		 (vm-imap . vm-visit-imap-folder-other-frame)
		 (gnus . org-gnus-no-new-news)
		 (file . find-file)
		 (wl . wl-other-frame)))
 '(package-selected-packages
	 '(org dap-mode org-roam nano-modeline nano-theme company-lua lua-mode fish-mode esup focus indicators doom-themes elisp-format rainbow-mode rust-mode yaml-mode terraform-mode rjsx-mode js2-mode use-package typescript-mode tree-sitter-langs helm-lsp lsp-treemacs company lsp-ui tree-sitter helm exec-path-from-shell slime json-mode flycheck lsp-mode ac-html flymd markdown-mode smart-tab smartparens crux multiple-cursors dockerfile-mode magit transient ace-window python swiper))
 '(warning-suppress-log-types '((lsp-mode) (auto-save) (auto-save) (auto-save)))
 '(warning-suppress-types '((auto-save) (auto-save) (auto-save))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-object-property ((t (:inherit tree-sitter-hl-face:variable\.parameter)))))


;; (require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (package-initialize)

;; basic custom settings
(require 'indicators)
(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
		   (format "%.2f seconds"
				   (float-time
		    (time-subtract after-init-time before-init-time)))
	   gcs-done))
(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; load cusotm ayu-dark theme, else load tango-dark
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
  (forward-line))


(defun scroll-up-by (arg)
	"Scroll document up by ARG lines."
	(forward-line arg)
	(scroll-up arg))


(defun scroll-down-by (arg)
	"Scroll document down by ARG lines."
	(forward-line (- arg))
	(scroll-down arg))


;; (setq-default indent-tabs-mode t) ;; keep just for reference
;; (setq-default tab-width 4)
;; (defvaralias 'c-basic-offset 'tab-width)

(setq inhibit-startup-screen nil)
(use-package emacs
  :ensure nil
  :config
	(defvar global-auto-revert-non-file-buffers)
  (add-to-list 'exec-path "/Users/charlesbedell/.nvm/versions/node/v19.7.0/bin/")
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
	(tool-bar-mode 0)
	(scroll-bar-mode 0)
	(delete-selection-mode 0)
	(global-hl-line-mode 1)
	(fringe-mode 8)
	(global-auto-revert-mode 1)
	(global-flycheck-mode 1)
	(global-company-mode 1)
  (setq inhibit-startup-buffer-menu 1
				inhibit-startup-screen nil
				initial-buffer-choice t
				scroll-step 1
				exec-path (append exec-path '("/usr/local/bin"))
				ring-bell-function 'ignore
				global-auto-revert-non-file-buffers t)
  (setq-default fill-column 80
								tab-width 2)
  :bind
  ("C-c C-s" . replace-string)
  ("C-;"     . comment-or-uncomment-region)
  ("C-a"     . crux-move-beginning-of-line)
  :hook
  (
   (prog-mode . display-line-numbers-mode)
   (prog-mode . multiple-cursors-mode)
   (prog-mode . column-number-mode)
   (prog-mode . display-fill-column-indicator-mode)
   (prog-mode . lsp-mode)))

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

(use-package ace-window
  :config
  (setq aw-ignore-on nil)
  :bind
  ("C-x o" . ace-window))

(use-package smartparens
  :init
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1)
	:commands (sp-local-pair)
  :config
  (sp-local-pair 'markdown-mode "*" "*")
  (sp-local-pair 'markdown-mode "**" "**")
  (sp-local-pair 'typescript-mode "<" ">")
  (sp-local-pair 'python-mode "'''" "'''")
  (sp-local-pair 'python-mode "\"\"\"" "\"\"\""))

(use-package lsp-mode
  :config
	(defvar treemacs-space-between-root-nodes)
	(defvar company-minimum-prefix-length)
	(defvar company-idle-delay)
	(defvar lsp-ui-doc-show-with-mouse)
  (setq gc-cons-threshold       10000000
				read-process-output-max (* 1024 1024)
				treemacs-space-between-root-nodes nil
				company-idle-delay 0.0
				company-minimum-prefix-length 1
				lsp-idle-delay          0.1
				lsp-log-io              nil ; if set to true can cause performance hit
				lsp-ui-doc-show-with-mouse nil
				)
  :hook
  ((typescript-mode . lsp)
	 (rjsx-mode . lsp)
	 (rust-mode . lsp)
	 (c-mode . lsp)
	 (c++-mode . lsp)
	 (python-mode . lsp)))

(use-package dap-mode
	:commands (dap-register-debug-template dap-register-debug-provider)
	:config
	(dap-register-debug-template "python-dap"
															 (list :type "python"
																		 :request "attach"
																		 :name "Run-Configuration"))
	(dap-register-debug-template "My App"
															 (list :type "python"
																		 :args "-i"
																		 :cwd nil
																		 :env '(("DEBUG" . 1))
																		 :target-module (expand-file-name "/Users/charlesbedell/code/practice.py")
																		 :request "attach"
																		 :name "Run-Configuration"))
	(dap-register-debug-provider "python"
															 (lambda (conf)
																 (plist-put conf :debugServer 5678)
																 (plist-put conf :host "localhost")
																 conf)))



;; (use-package dap-python
;; 	:config
;; 	(setq dap-python-debugger 'debugpy))


(use-package helm
  :init
  (helm-mode 1)
  :config
	(defvar helm-buffer-in-new-frame-p)
	(defvar helm-buffers-truncate-lines)
	(defvar helm-mini-default-sources)
	(defvar helm-ff-skip-boring-files)
  (setq helm-autoresize-mode         1
				helm-autoresize-max-height   30
				helm-autoresize-min-height   30
				helm-full-frame              nil
				helm-buffer-in-new-frame-p   nil
				helm-split-window-inside-p   t
				helm-buffers-truncate-lines  t
				helm-mini-default-sources    '(helm-source-buffers-list helm-source-recentf)
				helm-ff-skip-boring-files    t
				helm-boring-file-regexp-list '("\\~$" "\\#*\\#"))
  :bind
  ("C-x C-f" . helm-find-files)
  ("C-x b"   . helm-mini)
  ("M-x"     . helm-M-x)
  :custom-face
  (helm-ff-directory ((t (:extend t :foreground "DeepSkyBlue1" :background nil))))
  (helm-ff-file ((t (:foreground "lightgrey"))))
  (helm-selection ((t (:background "gray27" :distant-foreground "white")))))

(use-package org
  :ensure nil
  :config
	(defvar org-capture-templates)
	(defvar org-agenda-timegrid-use-ampm)
  (require 'org)
  (setq org-agenda-files '("~/notes/" "~/RoamNotes/" "~/RoamNotes/journal/" "~RoamNotes/todo/")
				org-directory "~/notes"
				org-default-notes-file (concat org-directory "/notes.org")
				org-agenda-timegrid-use-ampm 1
				
				org-capture-templates
				'(("t" "Todo" entry (file+headline "~/notes/todo.org" "Tasks")
					 "* TODO %?\n  %i\n  %a")
					("j" "Journal" entry (file+datetree "~/notes/journal.org")
					 "* %?\nEntered on %U\n  %i\n  %a"))
				org-hide-emphasis-markers t)
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  :hook
  ((org-mode . auto-fill-mode)
   (org-mode . display-fill-column-indicator-mode)
   (org-mode . ivy-mode)
   (org-mode . (lambda () (local-set-key "\M-." 'org-open-at-point)))
   (org-mode . (lambda () (local-set-key "\M-," 'org-mark-ring-goto))))
  :custom-face
  (org-level-1 ((t (:inherit markdown-header-face-1 :extend nil))))
  (org-level-2 ((t (:inherit markdown-header-face-2 :extend nil))))
  (org-level-3 ((t (:inherit markdown-header-face-3 :extend nil))))
  (org-level-4 ((t (:inherit markdown-header-face-4 :extend nil))))
  (org-level-5 ((t (:inherit markdown-header-face-5 :extend nil))))
  (org-level-6 ((t (:inherit markdown-header-face-6 :extend nil)))))

(use-package org-roam
  :init
  (org-roam-db-autosync-enable)
  :ensure t
	:config
	(require 'org-roam-dailies)
	(defvar org-mode-map)
	(defvar org-roam-dailies-map)
  :custom
	(org-roam-directory "~/RoamNotes")
  (org-roam-dailies-directory "journal/")
  (org-roam-complete-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      (file "~/RoamNotes/templates/default_note_template.org")
      :if-new (file+head "${slug}.org" "#+TITLE: ${title}\n#+DATE: %U\n#+FILETAGS:\n")
      :unnarrowed t)
     ("p" "project" plain
      (file "~/RoamNotes/templates/project_note_template.org")
      :if-new (file+head "${slug}.org" "#+TITLE: ${title}\n#+FILETAGS: Project")
      :unnarrowed t)
		 ("r" "rolodex" plain
      (file "~/RoamNotes/templates/rolodex_template.org")
      :if-new (file+head "rolodex/${slug}.org" "#+TITLE: ${title}\n#+DATE: %U\n#+FILETAGS:\n")
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
  (ivy-count-format "(%d/%d)")
  :bind
  ("C-s" . swiper))

(use-package slime
  :init
  (require 'slime)
  (slime-setup)
  :config
  (setq inferior-lisp-program "/usr/local/bin/sbcl") ;; lisp system
  (add-to-list 'load-path "~/.slime")) ;; slime directory

(use-package term
	:commands (term-set-escape-char term-mode term-char-mode pb-copy)
  :config
  (term-set-escape-char 24) ;; set escape char from C-c to C-x
  (setq explicit-shell-file-name "/usr/local/bin/fish")

  (defun term (buffer-name)
    "Start a terminal and rename buffer."
    (interactive "Mbuffer name: terminal")
    (setq buffer-name (concat "terminal" buffer-name))
    (set-buffer (make-term buffer-name "/usr/local/bin/fish"))
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
  (term-color-cyan ((t (:foreground "white"))))
  (term-color-magenta ((t (:foreground "lightgrey"))))
  (term-color-red ((t (:foreground "#fc3d3d")))))

;; keybindings
(global-set-key (kbd "C-c p") 'pyorg)
(global-set-key (kbd "C-v") (lambda () (interactive) (scroll-up-by 5)))
(global-set-key (kbd "M-v") (lambda () (interactive) (scroll-down-by 5)))
;; (setq smerge-command-prefix "\C-cv") ;; might not work

(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode 1)
(lsp-treemacs-sync-mode 1)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; hooks
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(require 'term)
(define-key term-raw-map (kbd "C-y") 'term-paste) ;; cant put these
(define-key term-raw-map (kbd "s-v") 'term-paste) ;; in use-package?
;; (add-hook 'rjsx-mode-hook #'(lambda () (setq-local electric-indent-inhibit t))) ;; not using this but keeping for reference

(use-package typescript-mode
  :mode ("\\.tsx\\'" "\\.ts\\'"))

(use-package rjsx-mode
  :mode ("\\.jsx\\'" "\\.js\\'"))

(use-package rust-mode
  :mode ("\\.rs\\'"))


(use-package js2-mode
	:config
	(setq js-indent-level 2)
	(setq js2-basic-offset 2))

(use-package conf-mode
  :mode ("\\.*rc\\'"))

(use-package fish-mode
  :mode ("\\.*fish\\'"))

;; (setq auto-mode-alist
;;       (append '(("\\.jsx\\'" . rjsx-mode)
;; 		("\\.js\\'" . rjsx-mode)
;; 		("\\.rs\\'" . rust-mode)
;; 		("\\.*rc\\'" . conf-mode))
;; 	      ;;("\\.jsx\\'" . font-lock-mode)
;; 	      ;;("\\.tsx\\'" . font-lock-mode)
;; 	      ;;("\\.css\\'" . web-mode))
;; 	      auto-mode-alist))



;; org languages
(setq org-confirm-babel-evaluate nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)  ; in my case /bin/bash
   ;;(javascript . t)
   (python . t)))
;;; .emacs ends here
