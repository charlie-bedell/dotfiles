(deftheme ayu-dark
  "a non-perfect replication of the ayu-dark theme")

(custom-theme-set-faces
 'ayu-dark
 '(default ((t (:family "Menlo" :foundry "nil" :width normal :height 120 :weight normal :slant normal :underline nil :overline nil :extend nil :strike-through nil :box nil :inverse-video nil :foreground "#BFBDB6" :background "#161b27" :stipple nil :inherit nil))))
 '(cursor ((t (:background "#eeeeec"))))
 '(hl-line ((t (:background "#262d3c" :extend t))))
 '(region ((t (:background "#292d35"))))
 '(mode-line ((t (:background "#3c414a" :foreground "#0B0E14"))))
 '(mode-line-inactive ((t (:background "#464b55" :foreground "#0B0E14"))))
 '(tree-sitter-hl-face:tag ((t (:foreground "#39BAE6"))))
 '(font-lock-function-name-face ((t (:foreground "#FFB454"))))
 '(tree-sitter-hl-face:function.macro ((t (:foreground "#FFB454"))))
 '(font-lock-string-face ((t (:foreground "#AAD94C"))))
 '(font-lock-regexp-grouping-construct ((t (:foreground "#95E6CB"))))
 '(font-lock-regexp-grouping-backslash ((t (:foreground "#95E6CB" :inherit font-lock-regexp-grouping-construct))))
 '(font-lock-keyword-face ((t (:foreground "#FF8F40"))))
 '(tree-sitter-hl-face:string.special ((t (:foreground "#E6B673"))))
 '(font-lock-comment-face ((t (:foreground "#636A72"))))
 '(font-lock-constant-face ((t (:foreground "#D2A6FF"))))
 '(tree-sitter-hl-face:operator ((t (:foreground "#F29668"))))
 '(treemacs-git-added-face ((t (:foreground "#7FD962"))))
 '(treemacs-git-modified-face ((t (:foreground "#73B8FF")))))

(provide-theme 'ayu-dark)


