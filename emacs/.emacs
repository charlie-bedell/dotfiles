;;; package --- Summary
;; emacs config

;;; Commentary:
;; constant wip, a lot of stuff is commented out to keep as reference
;; the first big block of commented code is kept there to help debugging

;;; Code:
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;; for debugging
;; (setq use-package-compute-statistics t)
;; (setq backtrace-on-redisplay-error t)
;; ;; beginning of custom init
;; ;; help debug on error
;; (when init-file-debug
;;   (setq use-package-verbose t
;;         use-package-expand-minimally nil
;;         use-package-compute-statistics t
;;         debug-on-error t))
;; (setq debug-on-error t)
;; (setq toggle-debug-on-quit t)
;; ;; logging
;; ;; check logs after crash
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
(setq package-install-upgrade-built-in t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(defun efs/display-startup-time ()
	"Display startup time and garbage collections."
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

(defun my/delete-word (arg)
	"Delete forward ARG words without adding them to the kill ring."
	(interactive "p")
	(delete-region
	 (point)
	 (progn
		 (forward-word arg)
		 (point))))

(defun my/backward-delete-word (arg)
	"Delete backward ARG words without adding them to the kill ring."
	(interactive "p")
	(my/delete-word (- arg)))

;; M-x describe-personal-keybindings to see all your keybinds
(use-package emacs
  :ensure nil
  :init
  (setq-default
	 indent-tabs-mode t
	 tab-width 2
	 fill-column 80)
  (setq confirm-kill-emacs #'y-or-n-p
        vc-follow-symlinks t
        inhibit-startup-buffer-menu t
        inhibit-startup-screen t
        scroll-step 1
        scroll-conservatively 200
        ring-bell-function 'ignore
        global-auto-revert-non-file-buffers t
        gc-cons-threshold 10000000)

  :config
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
	(menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (winner-mode 1)
  (delete-selection-mode 1)
  (global-hl-line-mode 1)
  (global-auto-revert-mode 1)
  (blink-cursor-mode -1)
  (fringe-mode 8)
	(column-number-mode 1)
	(prefer-coding-system 'utf-8)
	(let ((home (file-name-as-directory (expand-file-name "~"))))
  (setq default-directory home)
  (setq-default default-directory home))
  (when (eq system-type 'windows-nt)
		(add-to-list 'default-frame-alist
								 '(font . "JetBrains Mono SemiBold-10.5")))

	:custom
	(custom-safe-themes
   '("4f8dce32da76340dd5ea39890fd63bed06b444f3bb55cd66aa4e6d465721f88a"
		 default))

  :bind
  (("C-r" . replace-string)
   ("C-s" . swiper)
   ("C-;" . comment-or-uncomment-region)
   ("C-a" . crux-move-beginning-of-line)
   ("M-d" . my/delete-word)
	 ("M-DEL" . my/backward-delete-word)
   ("C-v" . (lambda () (interactive) (scroll-up-by 5)))
   ("M-v" . (lambda () (interactive) (scroll-down-by 5)))
   ("M-," . xref-go-back)
   ("M-." . xref-find-definitions)
   ("M-/" . xref-find-references)
   ("C-c C-p" . backward-list)
   ("C-c C-n" . forward-list)
   ("M-m" . xref-find-apropos)
   ("C-\\" . treemacs)
	 ("C-z" . nil)
	 ("C-x C-z" . nil))

  :hook
  ((prog-mode . display-line-numbers-mode)
   (prog-mode . column-number-mode)
   (prog-mode . display-fill-column-indicator-mode)))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
	:custom
	(exec-path-from-shell-arguments '("-l"))
  :config
  (exec-path-from-shell-initialize))

(use-package indicators
  :ensure t)

(use-package swiper
	:ensure t
	)

(use-package avy
	:ensure t
	:init
	(setq avy-keys '(?q ?w ?e ?r ?a ?s ?d ?f ?c))
	:bind*
	("C-j" . avy-goto-char))

(use-package python
	:ensure nil
  :hook ((python-mode . my-python-mode-setup))
  :config
  (setq python-indent-offset 4)
  (defun my-python-mode-setup ()
    (interactive)
    (setq-local flycheck-disabled-checkers '(python-pylint python-flake8))
    (setq-local python-indent-offset 4))
  )

(defun my-python-recompile-key ()
  (local-set-key (kbd "C-x C-e") #'recompile))

(add-hook 'python-mode-hook #'my-python-recompile-key)

(use-package helm
	:ensure t
	:defer t
	:config
	(helm-mode 1)
	(helm-autoresize-mode 1)
	:custom
  (helm-autoresize-max-height 0)
  (helm-autoresize-min-height 28)
  (helm-full-frame nil)
  (helm-buffer-in-new-frame-p nil)
  (helm-split-window-inside-p t)
  (helm-buffers-truncate-lines nil)
  (helm-mini-default-sources '(helm-source-buffers-list helm-source-recentf))
  (helm-boring-file-regexp-list '("\\~$" "[#]*[#]" "\\#*\\#" ".uid$"))
  (helm-ff-skip-boring-files t)
	(helm-buffer-max-length 40)
  :bind
  ("C-x C-f" . helm-find-files)
  ("C-x b" . helm-mini)
  ("M-x" . helm-M-x)
  :custom-face
  (helm-ff-directory ((t (:extend t :foreground "DeepSkyBlue1" :background unspecified))))
  (helm-ff-file ((t (:foreground "lightgrey"))))
  (helm-selection ((t (:background "gray27" :distant-foreground "white")))))

(use-package multiple-cursors
	:ensure t)

(use-package ivy
	:ensure t
	:defer t
  :commands (ivy-mode)
  :custom
  (ivy-height 15)
  (ivy-count-format "(%d/%d)"))


(use-package org
  :defer t
	:ensure nil
	:custom
	(org-directory "~/RoamNotes")
	(org-agenda-files '("~/RoamNotes/todo.org"))
	(org-default-notes-file (concat org-directory "~/RoamNotes/notes.org"))
	(org-agenda-timegrid-use-ampm 1)
	(org-hide-emphasis-markers t)
	(org-ctrl-k-protect-subtree 'error)
	(org-confirm-babel-evaluate t)
	(org-link-frame-setup
   '((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file)
     (wl . wl-other-frame)))
	(org-capture-templates
	'(("t" "Todo" entry (file+headline "~/RoamNotes/todo.org" "Tasks")
	   "* TODO %?\n  %i\n  %a")
	  ("j" "Journal" entry (file+datetree "~/RoamNotes/journal.org")
	   "* %?\nEntered on %U\n  %i\n  %a")))
  :config
  (defvar org-capture-templates)
  (defvar org-agenda-timegrid-use-ampm)
	(org-babel-do-load-languages
	 'org-babel-load-languages
	 '((emacs-lisp . t)
		 (shell . t)
		 (python . t)
		 (C . t)))
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  ("C-c q" . org-tags-view)
  :hook
  ((org-mode . auto-fill-mode)
   (org-mode . display-fill-column-indicator-mode)
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
	   ((org-agenda-files (file-expand-wildcards "~/RoamNotes/*.org")))))))

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
	:ensure nil
  :commands (term-set-escape-char term-mode term-char-mode pb-copy)
  :config
  (term-set-escape-char 24) ;; set escape char from C-c to C-x
  (setq explicit-shell-file-name "/bin/zsh")
  :custom-face
  (term-color-blue ((t (:foreground "cyan2" :background "cyan2"))))
  (term-color-cyan ((t (:foreground "DeepSkyblue1" :background "DeepSkyblue1"))))
  )

;; (require 'term)
;; (define-key term-raw-map (kbd "C-y") 'term-paste) ;; cant put these
;; (define-key term-raw-map (kbd "s-v") 'term-paste) ;; in use-package?

(use-package magit
	:ensure t
	:commands (magit-status magit-dispatch))

(use-package flycheck
  :ensure t
	:commands flycheck-mode
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

	(defun my-enable-flycheck ()
		(when buffer-file-name
			(flycheck-mode 1)))

	:hook
	((prog-mode . my-enable-flycheck)
	 (flycheck-mode . mp-flycheck-prefer-eldoc)
	 (flycheck-mode . mp-flycheck-set-clang-include-path))

	:custom
	(flycheck-checker-error-threshold 400)
  :config
  ;; Disable unwanted checkers globally
  (setq-default flycheck-disabled-checkers '(python-flake8 python-pylint))

  ;; Add javascript-eslint to web-mode
  (flycheck-add-mode 'javascript-eslint 'web-mode))

(use-package crux
	:ensure t
	:commands (crux-move-beginning-of-line))

;; speeds up initial flycheck
;; (with-eval-after-load 'flycheck
;;   (advice-add 'flycheck-eslint-config-exists-p :override (lambda() t)))

;; eslint is downloaded into the current node version (at the time writing this)
;; that version is v20.10.0, which is managed by nvm


(use-package eldoc
	:ensure nil
  :custom
  (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
	(eldoc-idle-delay 0.2)
	(eldoc-echo-area-use-multiline-p t)
	(eldoc--echo-area-prefer-doc-buffer nil)
  :config
  ;; (eldoc-add-command-completions "paredit-")
  ;; (eldoc-add-command-completions "combobulate-")
  )

(use-package yasnippet
	:ensure t
  ;; use [TAB] or C-i to expand snippets
  :commands (yas-reload-all)
  :config
  (setq yas-snippet-dirs (append yas-snippet-dirs
				 '("~/dotfiles/yasnippets")))
  (yas-reload-all)
  :hook
  (prog-mode . yas-minor-mode))

(use-package ace-window
	:ensure t
  :custom
  (aw-ignore-on nil)
  :bind
  ("C-x o" . ace-window))

(use-package markdown-mode
	:ensure t
  :hook
  (markdown-mode . auto-fill-mode))

(use-package focus
  :defer t
  :custom-face
  (focus-unfocused ((t (:foreground "gray35")))))

(use-package multiple-cursors
	:ensure t
  :bind
  ("M-n" . mc/mark-next-lines)
  ("M-p" . mc/mark-previous-lines))

(use-package elec-pair
  :ensure nil
  :hook
  (prog-mode . electric-pair-local-mode))

(defun my/windows-normalize-file-uri (uri)
  "Use an uppercase, unescaped drive letter in Windows file URIs."
  (if (and (eq system-type 'windows-nt)
           (stringp uri)
           (string-match
            "\\`file:///\\([A-Za-z]\\)\\(?:%3[Aa]\\|:\\)"
            uri))
      (concat
       "file:///"
       (upcase (match-string 1 uri))
       ":"
       (substring uri (match-end 0)))
    uri))

(defun my/windows-normalize-csharp-uri (uri)
  "Use an uppercase, unescaped drive letter in csharp:/ URIs."
  (if (and (eq system-type 'windows-nt)
           (stringp uri)
           (string-match
            "\\`csharp:/\\([A-Za-z]\\)\\(?:%3[Aa]\\|:\\)"
            uri))
      (concat
       "csharp:/"
       (upcase (match-string 1 uri))
       ":"
       (substring uri (match-end 0)))
    uri))

(defun my/eglot-csharp-normalize-metadata-uri
    (original-handler operation &rest args)
  "Normalize the metadata URI before invoking ORIGINAL-HANDLER."
  (when (and (eq system-type 'windows-nt)
             (stringp (car args)))
    (setcar args
            (my/windows-normalize-csharp-uri
             (car args))))

  (apply original-handler operation args))

(use-package eglot
  :ensure nil
	:defer t

	;; change size to 2000000 when debugging
	;; back to 0 when done
  :custom
  (eglot-events-buffer-config
   '(:size 0 :format full))

  (eglot-ignored-server-capabilities
   '(
		 :inlayHintProvider
		 :documentOnTypeFormattingProvider
		 ))

  :config
  (add-to-list
   'eglot-server-programs
   '((rust-ts-mode rust-mode)
     . ("rust-analyzer"
        :initializationOptions
        (:check (:command "clippy")))))

  (add-to-list
   'eglot-server-programs
   '((rjsx-mode
      js-mode
      js2-mode
      js-ts-mode
      tsx-ts-mode
      typescript-ts-mode
      typescript-mode
      web-mode)
     . ("typescript-language-server" "--stdio")))

  (add-to-list
   'eglot-server-programs
   '((c-mode c-ts-mode c++-mode c++-ts-mode)
     . ("clangd")))

  ;; Important: advise `eglot-path-to-uri', not the obsolete
  ;; `eglot--path-to-uri' alias.
  (when (eq system-type 'windows-nt)
    (advice-remove
     'eglot-path-to-uri
     #'my/windows-normalize-file-uri)

    (advice-add
     'eglot-path-to-uri
     :filter-return
     #'my/windows-normalize-file-uri))

  :custom-face
  (eglot-highlight-symbol-face
   ((t (:background "gray40")))))

(use-package eglot-csharp
  :vc (:url "https://github.com/razzmatazz/eglot-csharp"
						:rev :newest)
	:bind
	(:map csharp-mode-map
				("C-c C-p" . backward-list)
				("C-c C-n" . forward-list)
				)

  :custom
  (eglot-csharp-use-metadata-uris t)

  :hook
  ((csharp-mode
    csharp-ts-mode
    eglot-csharp-cshtml-mode)
   . eglot-csharp-mode)

  :config
  (when (eq system-type 'windows-nt)
    (advice-remove
     'eglot-csharp--metadata-uri-handler
     #'my/eglot-csharp-normalize-metadata-uri)

    (advice-add
     'eglot-csharp--metadata-uri-handler
     :around
     #'my/eglot-csharp-normalize-metadata-uri))

  (defun my/eglot-csharp-fix-json-false (value)
    "Recursively replace `:false' with `:json-false'."
    (cond
     ((eq value :false)
      :json-false)

     ((consp value)
      (cons
       (my/eglot-csharp-fix-json-false (car value))
       (my/eglot-csharp-fix-json-false (cdr value))))

     ((vectorp value)
      (apply
       #'vector
       (mapcar
        #'my/eglot-csharp-fix-json-false
        value)))

     (t value)))

  (unless
      (advice-member-p
       #'my/eglot-csharp-fix-json-false
       'eglot-csharp--workspace-configuration)

    (advice-add
     'eglot-csharp--workspace-configuration
     :filter-return
     #'my/eglot-csharp-fix-json-false)))

(use-package gdscript-mode
	:ensure nil
	:config
	(defvar font-lock-function-call-face 'font-lock-function-call-face)
	:hook (gdscript-mode . eglot-ensure))

(use-package treemacs
   :defer t
   :ensure t
  :init
  (add-to-list 'image-types 'svg)
	:custom
  (treemacs-indentation 1)
  (treemacs-indentation-string (propertize " ┃" 'face 'font-lock-comment-face))
	:config
	(treemacs-resize-icons 16)
	:custom-face
	(treemacs-root-face ((t (:inherit font-lock-constant-face :foreground "burlywood1" :underline t :height 1.2))))
	)

;; keybindings
(global-set-key (kbd "C-c p") 'pyorg)

;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))

(use-package treesit
	:ensure nil
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
	:ensure t
  :hook
  (prog-mode . company-mode)
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1))

(use-package gdshader-mode
  :ensure nil
  :mode "\\.gdshader\\'"

  :init
  (defun my-gdshader-company-setup ()
    (setq-local company-dabbrev-downcase nil)
    (setq-local company-backends
                '((company-keywords company-dabbrev))))

  :hook
  (gdshader-mode . my-gdshader-company-setup)

  :config
  (add-to-list
   'company-keywords-alist
   (append '(gdshader-mode)
           gdshader-all-keywords)))

(use-package slime
	:ensure t
	:commands slime)

(use-package js-ts-mode
  :ensure nil
  :bind
  ("M-," . xref-go-back)
  ("M-." . xref-find-definitions)
  ("M-/" . xref-find-references)
  :mode ("\\.js\\'" "\\.jsx\\'"))

(use-package typescript-ts-mode
  :ensure nil
  :mode ("\\.ts\\'")
  )

(use-package c-ts-mode
  :ensure nil
  :mode ("\\.c\\'" "\\.h\\'")
  )

(use-package tsx-ts-mode
  :ensure nil
  :mode ("\\.tsx\\'")
  )

(use-package c++-ts-mode
  :ensure nil
  :mode ("\\.cpp\\'")
  )


;; tramp
(setq tramp-default-user "cbedell")


(use-package xml-mode
	:ensure nil
  :mode ("\\.csproj\\'")
  )

(use-package rust-mode
	:ensure t
  :mode ("\\.rs\\'")
  :bind
  (:map rust-mode-map
	("C-x C-e" . recompile)))

(use-package web-mode
	:ensure t
  :mode
  (("\\.html\\'" . web-mode)
   ("\\.php\\'" . web-mode))
  :custom
  (web-mode-enable-current-element-highlight t)
  (web-mode-markup-indent-offset 2)
  (web-mode-auto-close-style 2)
  )

(use-package json-mode
	:ensure t
  :mode "\\.json\\'")

;; backups
(setq backup-directory-alist '(("." . "./.~")))

;;; .emacs ends here
