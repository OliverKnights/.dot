(require 'package)

(setq comp-deferred-compilation t
      ring-bell-function 'ignore
      c-basic-offset 4
      c-basic-indent 4
      confirm-kill-emacs 'y-or-n-p
      indent-tabs-mode nil
      js-indent-level 2
      default-tab-width 4
      tab-width 4
      sh-basic-offset 2
      dired-listing-switches "-alh"
      confirm-kill-processes nil
      package-enable-at-startup nil
      gc-cons-threshold (* 8 1024 1024)
      help-window-select t                   ; Focus new help windows when opened
      sentence-end-double-space nil          ; Use a single space after dots
      tab-always-indent 'complete            ; Tab indents first then tries completions
      uniquify-buffer-name-style 'forward    ; Uniquify buffer names
      warning-minimum-level :error           ; Skip warning buffers

      read-process-output-max (* 1024 1024)  ; Increase read size per process

      scroll-conservatively 101              ; Avoid recentering when scrolling far
      scroll-margin 2                        ; Add a margin when scrolling vertically

      tramp-default-method "ssh"
      inhibit-startup-screen t
      initial-scratch-message ""
      explicit-shell-file-name "/bin/bash"
      markdown-list-indent-width 2
      kill-buffer-query-functions nil ;; don't confirm when killing a buffer with a process
      epg-gpg-program "gpg"
      epa-pinentry-mode 'loopback ;; enter password for gpg in emacs
      scroll-preserve-screen-position t ;; keep cursor in the same position relative to viewport when scrolling
      custom-file (concat user-emacs-directory "custom.el")
      vc-follow-symlinks t)

;; (add-to-list 'default-frame-alist '(font . "Source Code Pro-11" ))
;; (set-face-attribute 'default t :font "Source Code Pro-11" )

(add-hook 'makefile-mode-hook (lambda ()
                                (setq-local tab-width 4
                                            indent-tabs-mode t)))
(defun turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))
(add-hook 'sh-mode-hook #'turn-off-indent-tabs-mode)
(add-hook 'sh-mode-hook #'flymake-mode)
(add-hook 'markdown-mode-hook #'turn-off-indent-tabs-mode)
(add-hook 'markdown-mode-hook #'variable-pitch-mode)
(add-hook 'org-mode-hook #'variable-pitch-mode)

(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;(add-to-list 'load-path "~/go/pkg/mod/github.com/golangci/lint-1@v0.0.0-20191013205115-297bf364a8e0/misc/emacs/")
;;(require 'golint)

(if (file-exists-p "~/.emacs.d/private.el")
  (load "~/.emacs.d/private.el"))
(load "view.el")

;; This should be project local really, I think the list of ignores should be like .gitignore patterns
(setq-default project-vc-ignores (list "vendor/"))

;; autosave
(defadvice switch-to-buffer (before save-buffer-now activate)
           (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
           (when buffer-file-name (save-buffer)))
(defadvice other-frame (before other-frame-now activate)
           (when buffer-file-name (save-buffer)))
(defadvice ace-window (before other-frame-now activate)
           (when buffer-file-name (save-buffer)))

;; modes
(blink-cursor-mode 0)                   ; Prefer a still cursor
(auto-save-visited-mode 1)
(global-hl-line-mode 1)
(global-visual-line-mode 1)
(global-auto-revert-mode 1)
(show-paren-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(savehist-mode 1) ;; Save minibuffer history
;;(fido-mode 1)
(delete-selection-mode 1)
(electric-pair-mode -1)
;; might be useful at some point
;;(global-subword-mode 1)                 ; Iterate through CamelCase words

;; variables
(defalias 'yes-or-no-p 'y-or-n-p)

;; theme
(load-theme 'modus-operandi t)

;; bindings
(global-set-key (kbd "M-o") 'ace-window)

;; Garbage-collect on focus-out, Emacs should feel snappier overall.
(add-function :after after-focus-change-function
  (defun me/garbage-collect-maybe ()
    (unless (frame-focus-state)
      (garbage-collect))))

;; hooks
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

; style I want to use in c++ mode
(c-add-style "my-style"
             '("stroustrup"
               (indent-tabs-mode . nil)        ; use spaces rather than tabs
               (c-basic-offset . 4)))            ; indent by four spaces

(defun my-c++-mode-hook ()
  (c-set-style "my-style"))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))
;; packages
(use-package ace-window
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?;))
             :ensure t)

(use-package groovy-mode
             :ensure t)

(use-package jenkinsfile-mode
  :ensure t
  :mode ("Jenkinsfile\\'" . groovy-mode))

(use-package corfu
  :hook
  (after-init . corfu-global-mode))


(use-package restclient
             :ensure t)

(use-package which-key
             :ensure t
             :config
             (which-key-mode))

(use-package magit
             :ensure t
             :bind ("C-x g" . magit-status))

(use-package lsp-mode
             :ensure t
             ;; uncomment to enable gopls http debug server
             ;; :custom (lsp-gopls-server-args '("-debug" "127.0.0.1:0"))
             :commands (lsp lsp-deferred)
             :config (progn
                       ;; use flycheck, not flymake
                       (setq lsp-prefer-flymake nil)))
(lsp-register-client
    (make-lsp-client :new-connection (lsp-tramp-connection "gopls")
                     :major-modes '(go-mode)
                     :remote? t
                     :server-id 'gopls-remote))

(use-package go-mode
             :ensure t
             :hook ((go-mode . lsp-deferred)
                    (go-mode . (lambda ()
                                 (setq tab-width 4
                                       indent-tabs-mode 1)))
                    (before-save . lsp-format-buffer)
                    (before-save . lsp-organize-imports)
                    (before-save . gofmt-before-save)))

(add-hook 'python-mode-hook 'lsp-deferred)


(defun goall ()
  (interactive)
  (message "Project root: %s" (project-roots )))

(use-package dockerfile-mode
             :ensure t
             :mode ("Dockerfile\\'" . dockerfile-mode))

(use-package js2-mode
             :ensure t
             :mode "\\.js\\'"
             :hook ((js2-mode . setup-tide-mode)
                    (js2-mode . lsp-deferred)
                    (js2-mode . (lambda ()
                                  (setq js2-basic-offset 4)))))

(use-package docker-compose-mode
             :ensure t)

(use-package vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 30000))

(use-package docker
             :ensure t
             :bind (("C-c do" . docker)
                    ("C-c dc" . docker-compose)))

(add-hook 'org-mode-hook 'org-indent-mode)
(setq org-todo-keywords
      '((sequence "TODO" "DOING" "|" "DONE")))
(org-babel-do-load-languages
  'org-babel-load-languages
  '((R . t)
    (python . t)
    (perl . t)
    (js . t)
    (shell . t)
    (sql . t)
    (org . t)
    (plantuml . t)
    (emacs-lisp . t)
    (lisp . t)    ;; slime - lisp interaction mode
    (gnuplot . t)))
(setq org-agenda-files (list (expand-file-name "~/src/wiki")))
(setq org-refile-targets '(("work.org" :maxlevel . 1)
			  ("life.org" :maxlevel . 1)
			  ("archive.org" :maxlevel . 1)))

(use-package edit-indirect
             :ensure t)

(use-package docker-tramp
             :ensure t)

(use-package ob-async
             :ensure t)

(use-package org
  :custom
  (org-confirm-babel-evaluate nil)
  (org-clock-sound "/usr/share/sounds/sound-icons/prompt.wav")
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t))

(use-package expand-region
             :ensure t
             :bind ("C-=" . 'er/expand-region))

(use-package counsel
             :ensure t
             :config
             (ivy-mode 1)
             (setq ivy-use-virtual-buffers t))

(use-package exec-path-from-shell
             :ensure t
             :if (memq window-system '(mac ns x))
             :config
             (setq exec-path-from-shell-variables '("PATH" "GOPATH" "GPG_TTY"))
             (exec-path-from-shell-initialize))


(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; (setq my-tramp-ssh-completions
;;       '((tramp-parse-sconfig "~/.ssh/config")
;;         (tramp-parse-shosts "~/.ssh/known_hosts")))

;; (eval-after-load "tramp"
;;                  '(mapc (lambda (method)
;;                           (tramp-set-completion-function method my-tramp-ssh-completions))
;;                         '("fcp" "rsync" "scp" "scpc" "scpx" "sftp" "ssh")))

(use-package plantuml-mode
             :ensure t
             :mode ("\\.plantuml\\'" . plantuml-mode)
             :config
             (setq plantuml-jar-path (expand-file-name "~/Downloads/plantuml.jar"))
             (setq plantuml-default-exec-mode 'jar))

(add-to-list
  'org-src-lang-modes '("plantuml" . plantuml))
(setq org-plantuml-jar-path (expand-file-name "~/Downloads/plantuml.jar"))

(setq org-refile-targets
      '(("archive.org" :maxlevel . 1)
        ("life.org" :maxlevel . 1)))

(use-package vue-mode
             :ensure t)
(add-hook 'vue-mode-hook 'lsp-deferred)


(use-package transpose-frame
  :ensure t)

(defun my-increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))

(defun my-decrement-number-decimal (&optional arg)
  (interactive "p*")
  (my-increment-number-decimal (if arg (- arg) -1)))

(use-package multi-vterm
  :ensure t)

(use-package flymake-shellcheck
  :ensure t
  :commands flymake-shellcheck-load
  :hook ((sh-mode . lsp-deferred-mode)
         (sh-mode . flymake-shellcheck-load)))

(use-package doom-themes
  :ensure t)

(use-package crux
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding 'nil)
  :config
  (evil-mode))

(use-package evil-collection
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-escape
  :config
  (setq-default evil-escape-key-sequence "fd")
  (setq evil-escape-delay 0.15)
  (evil-escape-mode)
  :ensure t)

(use-package ivy-pass
  :ensure t)

(use-package counsel-tramp
  :ensure t)

(use-package general
  :ensure t
  :config
  (general-create-definer my-leader-def
    ;; :prefix my-leader
    :prefix "SPC")

  (my-leader-def
    :states 'normal
    :keymaps 'override
    "oa" 'org-agenda
    "oc" 'org-capture

    "ut" 'counsel-tramp
    "uv" 'multi-vterm
    "us" 'shell

    "es" 'eval-last-sexp
    "eb" 'eval-buffer

    "bl" 'ivy-switch-buffer
    "br" 'rename-buffer
    "bx" 'kill-this-buffer

    "pp" 'projectile-switch-project
    "pr" 'counsel-projectile-rg
    "pg" 'projectile-grep
    "pf" 'projectile-find-file

    "gs" 'magit-status

    "fl" 'find-file
    "fs" 'save-buffer

    "wr" 'split-window-right
    "wb" 'split-window-below
    "wo" 'delete-other-windows
    "wx" 'delete-window
    "ws" 'frameset-to-register
    "wl" 'jump-to-register)

  (general-define-key
    :states 'visual
    :keymaps 'override
    "gc" 'comment-dwim)

  (general-define-key
   :keymaps 'override
   :states 'normal
   "-" 'dired-jump
   "C-b" '(lambda ()
            (interactive)
            (evil-scroll-up 0))
   "C-f" '(lambda ()
            (interactive)
            (evil-scroll-down 0))))

;; Disable keys we've rebound
(global-set-key (kbd "C-x b") 'nil)
(global-set-key (kbd "C-x 1") 'nil)
(global-set-key (kbd "C-x 2") 'nil)
(global-set-key (kbd "C-x 3") 'nil)
(global-set-key (kbd "C-x C-e") 'nil)
(global-set-key (kbd "C-x C-f") 'nil)
(global-set-key (kbd "C-x C-s") 'nil)

;; (use-package smooth-scrolling
;;   :ensure t
;;   :config
;;   (smooth-scrolling-mode 1)
;;   (setq smooth-scroll-margin 2))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; (setq remote-file-name-inhibit-cache nil)
;; (setq vc-handled-backends '(Git))
;; (setq tramp-verbose 1)

(use-package counsel-projectile
  :ensure t)

(use-package desktop
  :hook
  (after-init . desktop-read)
  (after-init . desktop-save-mode)
  :custom
  (desktop-restore-eager 4)
  (desktop-restore-forces-onscreen nil)
  (desktop-restore-frames t))

(use-package shackle
  :ensure t
  :hook
  (after-init . shackle-mode)
  :custom
  (shackle-inhibit-window-quit-on-same-windows t)
  (shackle-rules '((help-mode :same t)
                   (helpful-mode :same t)
                   (process-menu-mode :same t)))
  (shackle-select-reused-windows t))

(use-package marginalia
  :ensure t
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))
