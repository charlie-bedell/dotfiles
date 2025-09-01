;;; package --- Summary
;; emacs config

;;; Commentary:
;; constant wip, a lot of stuff is commented out to keep as reference
;; the first big block of commented code is kept there to help debugging


;;; Code:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0)
 '(company-minimum-prefix-length 2)
 '(custom-safe-themes
	 '("4f8dce32da76340dd5ea39890fd63bed06b444f3bb55cd66aa4e6d465721f88a" default))
 '(eglot-ignored-server-capabilities '(:inlayHintProvider) nil nil "Customized with use-package eglot")
 '(exec-path-from-shell-arguments '("-l"))
 '(flycheck-checker-error-threshold 400)
 '(js2-strict-missing-semi-warning nil)
 '(org-babel-load-languages '((emacs-lisp . t) (shell . t) (python . t) (C . t)))
 '(org-link-frame-setup
	 '((vm . vm-visit-folder-other-frame)
		 (vm-imap . vm-visit-imap-folder-other-frame) (gnus . org-gnus-no-new-news)
		 (file . find-file) (wl . wl-other-frame)))
 '(package-selected-packages
	 '(ac-html ace-window cider company-lua corfu crux devdocs dockerfile-mode
						 doom-themes elisp-format esup exec-path-from-shell fish-mode
						 flycheck flycheck-rust flymd focus glsl-mode helm indicators ivy
						 json-mode lsp-pyright magit markdown-mode modus-themes
						 multiple-cursors nano-modeline nano-theme nil org-roam pyenv-mode
						 rainbow-mode rjsx-mode rust-mode slime smart-tab solo-jazz-theme
						 swiper terraform-mode treemacs typescript-mode use-package vlf
						 vterm web-mode yaml yaml-mode yasnippet)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(treemacs-root-face ((t (:inherit font-lock-constant-face :foreground "burlywood1" :underline t :height 1.2)))))

;; (setq backtrace-on-redisplay-error t)
;; beginning of custom init
;; help debug on error
;; (when init-file-debug
;;   (setq use-package-verbose t
;;         use-package-expand-minimally nil
;;         use-package-compute-statistics t
;;         debug-on-error t))
;; (setq debug-on-error t)
;; (setq toggle-debug-on-quit t)
;; logging
;; check logs after crash
;; (defun save-messages-to-file ()
;;   "Save the contents of the Messages buffer to a file."
;;   (with-current-buffer "*Messages*"
;;     (write-region (point-min) (point-max) "~/messages.log" t 'quiet)))

;; ;; Advice to call save-messages-to-file after each modification to the buffer
;; (defadvice message (after save-messages-to-file activate)
;;   "Save the Messages buffer to a file after each modification."
;;   (save-messages-to-file))
;; ;; Ensure the advice is active
;; (ad-activate 'message)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

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
	(menu-bar-mode t)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
	(winner-mode 1)
  (delete-selection-mode 1)
  (global-hl-line-mode 1)
  (global-auto-revert-mode 1)
	(blink-cursor-mode 0)
  :custom
	(confirm-kill-emacs 'y-or-n-p)
	(load (expand-file-name "~/.quicklisp/slime-helper.el"))
	(inferior-lisp-program "sbcl")
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
	(gc-cons-threshold 10000000)
	:bind*
  ("C-r" . replace-string)
  ("C-;" . comment-or-uncomment-region)
  ("C-a" . crux-move-beginning-of-line)
	("C-s" . swiper)
	("C-r" . replace-string)
	("C-v" . (lambda () (interactive) (scroll-up-by 5)))
	("M-v" . (lambda () (interactive) (scroll-down-by 5)))
	("M-," . xref-go-back)
	("M-." . xref-find-definitions)
	("M-/" . xref-find-references)
	("C-c C-p" . backward-list)
	("C-c C-n" . forward-list)
	("M-m" . xref-find-apropos)
	("C-\\" . treemacs)
  :hook (
				 (prog-mode . display-line-numbers-mode)
				 (prog-mode . multiple-cursors-mode)
				 (prog-mode . column-number-mode)
				 (prog-mode . display-fill-column-indicator-mode)
				 (prog-mode . global-company-mode)))

(use-package python
  :hook (python-mode . my-python-mode-setup)
	:custom
	(setq standard-indent 4)
  :config
	(setq python-indent-offset 4)
  (defun my-python-mode-setup ()
		(interactive)
    (setq-local flycheck-disabled-checkers '(python-pylint python-flake8))
		(setq-local python-indent-offset 4))
	(my-python-mode-setup))

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

(use-package ivy
	:commands (ivy-mode)
  :ensure t
  :init
  (ivy-mode 1)
  :custom
  (ivy-height 15)
  (ivy-count-format "(%d/%d)"))

(use-package org
	:defer t
  :ensure nil
  :config
	(defvar org-capture-templates)
	(defvar org-agenda-timegrid-use-ampm)
  (setq org-agenda-files '("~/RoamNotes/todo.org")
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
	:defer t
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
		(global-set-key (kbd "C-w") 'pbcut)
		;; (global-set-key (kbd "C-c C-c") 'term-interrupt-subjob)
		)
  :custom-face
  (term-color-blue ((t (:foreground "cyan2" :background "cyan2"))))
	(term-color-cyan ((t (:foreground "DeepSkyblue1" :background "DeepSkyblue1"))))
	)

(use-package flycheck
  :ensure t
  :preface
  (defun mp-flycheck-eldoc (callback &rest _ignored)
    "Print flycheck messages at point by calling CALLBACK."
    (when-let ((flycheck-errors (and flycheck-mode (flycheck-overlay-errors-at (point)))))
      (mapc
       (lambda (err)
         (funcall callback
                  (format "%s: %s"
                          (let ((level (flycheck-error-level err)))
                            (pcase level
                              ('info (propertize "I" 'face 'flycheck-error-list-info))
                              ('error (propertize "E" 'face 'flycheck-error-list-error))
                              ('warning (propertize "W" 'face 'flycheck-error-list-warning))
                              (_ level)))
                          (flycheck-error-message err))
                  :thing (or (flycheck-error-id err)
                             (flycheck-error-group err))
                  :face 'font-lock-doc-face))
       flycheck-errors)))

  (defun mp-flycheck-prefer-eldoc ()
    (add-hook 'eldoc-documentation-functions #'mp-flycheck-eldoc nil t)
    (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
    (setq flycheck-display-errors-function nil)
    (setq flycheck-help-echo-function nil))

  (defun mp-flycheck-set-clang-include-path ()
    "Set flycheck-clang-include-path based on current project root."
    (when-let ((proj (project-current)))
      (setq-local flycheck-clang-include-path
                  (list (project-root proj)))))

  :init
  (global-flycheck-mode)

  :hook ((flycheck-mode . mp-flycheck-prefer-eldoc)
         (flycheck-mode . mp-flycheck-set-clang-include-path))

  :config
  ;; Disable unwanted checkers globally
  (setq-default flycheck-disabled-checkers '(python-flake8 python-pylint))

  ;; Add javascript-eslint to web-mode
  (flycheck-add-mode 'javascript-eslint 'web-mode))


;; speeds up initial flycheck
(with-eval-after-load 'flycheck
  (advice-add 'flycheck-eslint-config-exists-p :override (lambda() t)))

;; so a couple things: node versions are managed with nvm

;; eslint is downloaded into the current node version (at the time writing this)
;; that version is v20.10.0, which is managed by nvm

;; since the -i (interactive) flag has been removed from (exec-path-from-shell),
;; emacs will inherit path variables from .zshenv... since .zshenv doesn't have
;; nvm, the node version needs to be set manually.


(use-package eldoc
  :preface
   (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
   :config
	 ;; (eldoc-add-command-completions "paredit-")
   ;; (eldoc-add-command-completions "combobulate-")
	(setq eldoc-idle-delay 0.2)
	)

(use-package yasnippet
	;; use [TAB] or C-i to expand snippets
	:commands (yas-reload-all)
	:config
	(setq yas-snippet-dirs (append yas-snippet-dirs
																 '("~/dotfiles/yasnippets")))
	(yas-reload-all)
	:hook
	(prog-mode . yas-minor-mode))

(use-package ace-window
	:custom
	(aw-ignore-on nil)
	:bind
	("C-x o" . ace-window))

(use-package markdown-mode
	:hook
	(markdown-mode . auto-fill-mode))

(use-package focus
	:defer t
	:custom-face
	(focus-unfocused ((t (:foreground "gray35")))))

(use-package multiple-cursors-mode
	:bind
	("M-n" . mc/mark-next-lines)
	("M-p" . mc/mark-previous-lines))

(use-package electric-pair-mode
	:hook
	(prog-mode . electric-pair-local-mode))

(use-package eglot
	:ensure t
	:custom
	(eglot-events-buffer-size 2000000) ; if debugging, set to 2000000
	:config
	(add-to-list 'eglot-server-programs '((rust-ts-mode rust-mode) .
																				("rust-analyzer" :initializationOptions (:check (:command "clippy")))))
	(add-to-list 'eglot-server-programs '((rjsx-mode js-mode js2-mode js-ts-mode tsx-ts-mode typescript-ts-mode typescript-mode web-mode)
																				"typescript-language-server" "--stdio"))
	(add-to-list 'eglot-server-programs '((c-mode c-ts-mode c++-mode c++-ts-mode) "clangd"))
	:custom-face
	(eglot-highlight-symbol-face ((t (:background "gray40")))))

;; (Use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-pyright)
;;                           (eglot))))  ; or lsp-deferred

;; (use-package lsp-mode
;; 	:defer t
;; 	:custom
;; 	(gc-cons-threshold 10000000)
;; 	(read-process-output-max (* 1024 1024))
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

;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))

(use-package treesit
	;; use m-x treesit-install-language-grammar
	:config
	(setq treesit-language-source-alist
				'((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
					(c . ("https://github.com/tree-sitter/tree-sitter-c"))
					(cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
					(css . ("https://github.com/tree-sitter/tree-sitter-css"))
					(cmake . ("https://github.com/uyha/tree-sitter-cmake"))
					(go . ("https://github.com/tree-sitter/tree-sitter-go"))
					(html . ("https://github.com/tree-sitter/tree-sitter-html"))
					(javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.3"))
					(json . ("https://github.com/tree-sitter/tree-sitter-json"))
					(julia . ("https://github.com/tree-sitter/tree-sitter-julia"))
					(lua . ("https://github.com/Azganoth/tree-sitter-lua"))
					(make . ("https://github.com/alemuller/tree-sitter-make"))
					(ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" "master" "ocaml/src"))
					(python . ("https://github.com/tree-sitter/tree-sitter-python"))
					(php . ("https://github.com/tree-sitter/tree-sitter-php"))
					(typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
					(tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
					(ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
					(rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
					(sql . ("https://github.com/m-novikov/tree-sitter-sql"))
					(toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
					(zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
	)

(use-package company
	:config
	(setq company-idle-delay 0)
	(setq company-minimum-prefix-length 1))

(use-package slime)

(require 'term)
(define-key term-raw-map (kbd "C-y") 'term-paste) ;; cant put these
(define-key term-raw-map (kbd "s-v") 'term-paste) ;; in use-package?

(use-package js-ts-mode
	:bind
	("M-," . xref-go-back)
	("M-." . xref-find-definitions)
	("M-/" . xref-find-references)
  :mode ("\\.js\\'" "\\.jsx\\'"))

;; (use-package js2-mode
;; 	:defer t
;; 	:config
;; 	(setq js-indent-level 2)
;; 	(setq js2-basic-offset 2)
;; 	:bind
;; 	(:map js2-mode-map
;; 				("M-." . nil))
;; 	:mode ("\\.js\\'"))

;; (use-package typescript-mode
;; 	:mode ("\\.ts\\'" "\\.tsx\\'"))


(use-package typescript-ts-mode
  :mode ("\\.ts\\'")
	)

(use-package tsx-ts-mode
	:mode ("\\.tsx\\'")
	)

;; python-ts-mode sucks
(use-package python-mode
	:mode ("\\.py\\'"))

(use-package rust-mode
  :mode ("\\.rs\\'"))

(use-package c-ts-mode
	:mode ("\\.c\\'" "\\.h\\'")
	;; not working currently, need to revisit
	;; possible error is that man returns a buffer, not a string
	;; :preface
	;; (defun my-c-eldoc-function (callback &rest _ignored)
  ;;   "Returns a doc string appropriate for the current context, or nil."
	;; 	(man (symbol-at-point)))
	;; (defun my-c-prefer-eldoc ()
  ;; (add-hook 'eldoc-documentation-functions #'my-c-eldoc-function nil t)
  ;;   (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  ;;   (setq flycheck-display-errors-function nil)
  ;;   (setq flycheck-help-echo-function nil))
	;; :hook
	;; ((c-ts-mode . my-c-prefer-eldoc))
	;; :config
	;; (set (make-local-variable 'eldoc-documentation-function) 'c-eldoc-function)
	)

(use-package c++-ts-mode
	:mode ("\\.cpp\\'")
	)

;; (use-package cmake-ts-mode
;; 	:mode ("\\(?:CmakeLists.txt\\'")
;; 	)

(use-package conf-mode
  :mode ("\\.*rc\\'"))

(use-package fish-mode
  :mode ("\\.*fish\\'"))

(use-package web-mode
	:mode ("\\.*html\\'" "\\.*php\\'")
	:custom
	(web-mode-enable-current-element-highlight t)
	(web-mode-markup-indent-offset 2)
	(web-mode-auto-close-style 2))

(use-package json-mode
	:mode ("\\.cjs'" "\\.json'"))

(use-package glsl-mode
	:mode ("\\.vs\\'" "\\.fs\\'"))

(setq org-confirm-babel-evaluate nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)  ; in my case /bin/bash
   (python . t)))

;; backups
(setq backup-directory-alist '(("." . "./.~")))

(provide '.emacs)

;;; .emacs ends here
