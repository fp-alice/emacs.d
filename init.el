(package-initialize)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; If GNU ELPA is having package verification issues, set package-check-signature to nil (temporarily) and install gnu-elpa-keyring-update
(setq package-archives '(("gnu"     . "https://elpa.gnu.org/packages/")
                         ("melpa"   . "https://melpa.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

; Set font
(add-to-list 'default-frame-alist '(font . "Source Code Pro-10"))
(set-face-attribute 'default t :font "Source Code Pro-10")

; Load evil
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding  nil
        evil-want-integration t
        evil-search-module    'evil-search)
  :config
  (evil-mode 1))

; Load keymap fixes for evil
(use-package evil-collection
  :ensure t
  :config
  (evil-collection-translate-key nil 'evil-motion-state-map
                                 "n" "j"
                                 "e" "k"
                                 "o" "l"
                                 ;; 'o' needs to be somewhere else
                                 "l" "o")
  (define-key evil-normal-state-map (kbd "o") 'evil-forward-char)
  (evil-collection-init))

; general.el, keymapping
(use-package general :ensure t)
(require 'general)

; Popup window manager
(use-package popwin
  :ensure t
  :config
  (popwin-mode 1)
  (push '("^\*helm.+\*$" :regexp t) popwin:special-display-config)
  (add-hook 'helm-after-initialize-hook (lambda ()
                                          (popwin:display-buffer helm-buffer t)
                                          (popwin-mode -1)))
  (add-hook 'helm-cleanup-hook (lambda () (popwin-mode 1))))

; Helm & Helm extensions
(use-package helm
  :ensure t
  :config
  (require 'helm-config)
  (helm-mode 1))

(use-package helm-ag
  :ensure t
  :config
  (setq helm-ag-base-command "rg --vimgrep --no-heading --smart-case"))

; COMPlete ANYthing
(use-package company
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'company-mode)
  :bind
  (:map evil-insert-state-map
        ("C-p" . company-complete)))

;; Backends
(use-package company-php     :ensure t)
(use-package company-nginx   :ensure t)
(use-package company-ansible :ensure t)
(use-package company-plsense :ensure t)

;; Enhanced frontend
(use-package company-box
  :ensure t
  :config
  (setq company-box-icons-alist 'company-box-icons-all-the-icons)
  :hook
  (company-mode . company-box-mode))

; Treemacs file & project browser as well as evil compatibility mode
(use-package treemacs
  :ensure t
  :config
  '(treemacs-RET-actions-config
    (quote
     ((file-node-close  . treemacs-visit-node-in-most-recently-used-window)
      (file-node-open   . treemacs-visit-node-in-most-recently-used-window)
      (root-node-open   . treemacs-toggle-node)
      (root-node-closed . treemacs-toggle-node)
      (dir-node-open    . treemacs-toggle-node)
      (dir-node-closed  . treemacs-toggle-node)
      (file-node-closed . treemacs-visit-node-default)
      (tag-node-open    . treemacs-toggle-node-prefer-tag-visit)
      (tag-node-closed  . treemacs-toggle-node-prefer-tag-visit)
      (tag-node         . treemacs-visit-node-default)))))

(use-package treemacs-evil :ensure t)

; g/e/ctags
(use-package ggtags :ensure t)

; Project interactions
(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))

; Centaur Tabs
(use-package centaur-tabs
  :ensure t
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-build-helm-source)
  (centaur-tabs-group-by-projectile-project)
  :bind
  (:map evil-normal-state-map
        ("g t" . centaur-tabs-forward)
        ("g T" . centaur-tabs-backward)))

; Magit and evil compatibility mode
(use-package magit :ensure t)
(use-package evil-magit
  :ensure t
  :config
  (setq evil-magit-state          'normal
        evil-magit-use-y-for-yank nil)
  (require 'evil-magit))

; Theme components
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-molokai t)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; XXX remember to run (all-the-icons-install-fonts)
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

; modes
(use-package dockerfile-mode   :ensure t :mode "Dockerfile")
(use-package lua-mode          :ensure t :mode "\\.lua\\'")
(use-package robots-txt-mode   :ensure t :mode "robots.txt")
(use-package fish-mode         :ensure t :mode "\\.fish\\'" :magic "\\#!.+fish\\'")
(use-package perl6-mode        :ensure t)
(use-package apt-sources-list  :ensure t)
(use-package ansible           :ensure t)

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

(use-package php-mode          :ensure t :mode "\\.php\\'" :magic "\\#!.+php\\'")
(use-package php-refactor-mode
  :ensure t
  :config
  (add-hook 'php-mode-hook 'php-refactor-mode))

; Disable tab auto-insertion
(setq-default indent-tabs-mode nil)

(setq scroll-step                    1
      scroll-margin                  9
      scroll-conservatively          10000
      mouse-wheel-scroll-amount      '(1 ((shift) . 1))
      mouse-whell-progressive-speed  nil
      mouse-whell-follow-mouse       't
      version-control                t
      vc-make-backup-files           t
      vc-follow-symlinks             t
      coding-system-for-read         'utf-8
      coding-system-for-write        'utf-8
      sentence-end-double-space      nil
      auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))
      backup-directory-alist         `(("." . "~/.emacs.d/backups"))
      delete-old-versions            -1
      custom-file                    "~/.emacs.d/custom.el")

;; Enable pair hilighting
(show-paren-mode 1)

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;; Disable toolbar and _especially_ scrollbars
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Stateless global keybindings
(general-define-key
 "C-s"   'save-buffer
 "M-n"   'evil-next-match
 "M-N"   'evil-previous-match)

; Normal mode
;; Window movement
(general-define-key
 :states 'normal
 :prefix "C-w"
 "<up>"    'evil-window-up
 "e"       'evil-window-up
 "<down>"  'evil-window-down
 "n"       'evil-window-down
 "<left>"  'evil-window-left
 "h"       'evil-window-left
 "<right>" 'evil-window-right
 "o"       'evil-window-right)

;; Misc. keys
(general-define-key
 :states 'normal
 ;; Open treemacs
 "SPC t m t" 'treemacs
 "SPC t m o" 'treemacs-select-window
 "SPC t f n" 'treemacs-create-file
 "SPC t d n" 'treemacs-create-dir
 "SPC t m b" 'helm-buffers-list
 "SPC t t l" 'toggle-truncate-lines
 "SPC f e x" 'eval-buffer)

; helm-ag keys
(general-define-key
 :states 'normal
 "SPC s a"   'helm-ag
 "SPC s s"   'helm-ag-project-root
 "SPC s f"   'helm-ag-this-file)

(general-define-key
 :states 'normal
 "SPC g c c" 'magit-commit-create
 "SPC g c a" 'magit-commit-amend
 "SPC g c e" 'magit-commit-extend
 "SPC g c r" 'magit-commit-reword
 "SPC g a a" 'magit-stage
 "SPC g a m" 'magit-stage-modified
 "SPC g r s" 'magit-unstage
 "SPC g r a" 'magit-unstage-all
 "SPC g s t" 'magit-status
 "SPC g d d" 'magit-diff-unstaged
 "SPC g d q" 'magit-diff-staged
 "SPC g d f" 'magit-diff-buffer-file)

;; treemacs-mode bindings
(general-define-key
 :keymaps    'treemacs-mode-map
 "SPC t m t" 'treemacs
 "C-c"       'treemacs
 "r"         'treemacs-visit-node-in-most-recently-used-window
 "R"         'treemacs-refresh)

;; because once was not enough
(general-define-key
 :keymaps 'treemacs-mode-map
 :prefix "C-w"
 "<up>"    'evil-window-up
 "e"       'evil-window-up
 "<down>"  'evil-window-down
 "n"       'evil-window-down
 "<left>"  'evil-window-left
 "h"       'evil-window-left
 "<right>" 'evil-window-right
 "o"       'evil-window-right)

(general-define-key
 :keymaps 'tetris-mode-map
 "a" 'tetris-move-left
 "t" 'tetris-move-right
 "s" 'tetris-move-down
 "l" 'tetris-rotate-next
 "e" 'tetris-rotate-prev
 "p" 'tetris-pause)

; set _ to a word character so that C-Left/C-Right/S-Left/S-Right don't skip over it
(modify-syntax-entry ?_ "w")
