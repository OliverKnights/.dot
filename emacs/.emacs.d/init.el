(require 'package)

(setq comp-deferred-compilation t
      ring-bell-function 'ignore
      org-clock-sound "/usr/share/sounds/sound-icons/prompt.wav"
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
      org-confirm-babel-evaluate nil
      tramp-default-method "ssh"
      inhibit-startup-screen t
      initial-scratch-message ""
      show-paren-delay t
      markdown-list-indent-width 2
      kill-buffer-query-functions nil ;; don't confirm when killing a buffer with a process
      epg-gpg-program "gpg2"
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
(auto-save-visited-mode 1)
(global-hl-line-mode 1)
(global-visual-line-mode 1)
(global-auto-revert-mode 1)
;; (desktop-save-mode 1)
;; (show-paren-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;;(fido-mode 1)
(delete-selection-mode 1)
(electric-pair-mode 1)

;; variables
(defalias 'yes-or-no-p 'y-or-n-p)

;; theme
(load-theme 'modus-operandi t)

;; bindings
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "C-x C-j") 'dired-jump)

(global-set-key (kbd "C-c p") 'projectile-command-map)

;;; Windows
(global-set-key (kbd "C-M-H-s-w C-M-H-s-r") 'split-window-right)
(global-set-key (kbd "C-M-H-s-w C-M-H-s-b") 'split-window-below)
(global-set-key (kbd "C-M-H-s-w C-M-H-s-o") 'delete-other-windows)
(global-set-key (kbd "C-M-H-s-w C-M-H-s-x") 'delete-window)

;;; Buffers
(global-set-key (kbd "C-M-H-s-b C-M-H-s-r") 'rename-buffer)

;;; Compilation
(global-set-key (kbd "C-M-H-s-c C-M-H-s-o") 'compile)

;;; LSP
(global-set-key (kbd "C-M-H-s-l C-M-H-s-d") 'lsp-find-definition)
(global-set-key (kbd "C-M-H-s-l C-M-H-s-r") 'lsp-find-references)
(global-set-key (kbd "C-M-H-s-l C-M-H-s-i") 'lsp-goto-implementation)

;;; Utils
(global-set-key (kbd "C-M-H-s-u C-M-H-s-v") 'multi-vterm)
(global-set-key (kbd "C-M-H-s-u C-M-H-s-s") 'shell)
(global-set-key (kbd "C-M-H-s-u C-M-H-s-r") 'replace-regexp)

;; Errors
(global-set-key (kbd "C-M-H-s-e C-M-H-s-n") 'flymake-goto-next-error)
(global-set-key (kbd "C-M-H-s-e C-M-H-s-p") 'flymake-goto-prev-error)

(global-set-key (kbd "C-c oa") 'org-agenda)

(global-set-key (kbd "C-v") 'View-scroll-half-page-forward)
(global-set-key (kbd "M-v") 'View-scroll-half-page-backward)

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

(use-package company
             :ensure t
             :hook (after-init . global-company-mode))

(use-package company-go
             :ensure t)

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

(use-package go-mode
             :ensure t
             :hook ((go-mode . lsp-deferred)
                    (go-mode . (lambda ()
                                 (setq tab-width 4
                                       indent-tabs-mode 1)))
                    (go-mode . (lambda ()
                                 (set (make-local-variable 'company-backends) '(company-go))
                                 (company-mode)))
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
             :ensure t)

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

(setq my-tramp-ssh-completions
      '((tramp-parse-sconfig "~/.ssh/config")
        (tramp-parse-shosts "~/.ssh/known_hosts")))

(eval-after-load "tramp"
                 '(mapc (lambda (method)
                          (tramp-set-completion-function method my-tramp-ssh-completions))
                        '("fcp" "rsync" "scp" "scpc" "scpx" "sftp" "ssh")))

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
  :config
  (define-key vterm-mode-map (kbd "<escape>") #'god-local-mode)
  :ensure t)

(use-package flymake-shellcheck
  :ensure t
  :commands flymake-shellcheck-load
  :init
  (add-hook 'sh-mode-hook 'flymake-shellcheck-load))

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
  (evil-mode)
  (define-key evil-normal-state-map (kbd ";") 'evil-ex)
  (define-key evil-normal-state-map (kbd ":") 'evil-repeat-find-char))

(use-package evil-collection
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-escape
  :config
  (setq-default evil-escape-key-sequence "fd")
  (evil-escape-mode)
  :ensure t)
