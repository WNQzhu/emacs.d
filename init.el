;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
;;(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                           ("melpa" . "http://elpa.emacs-china.org/melpa/")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(package-selected-packages
   '(slime scala-mode google-translate go-mode protobuf-mode auctex magit auto-org-md google-this multi-term flymake-google-cpplint counsel-projectile projectile counsel-etags org markdown-mode window-numbering)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-face-attribute 'default nil :height 200)
(global-visual-line-mode 1)

;; use eww as the default browser;
;(setq browse-url-browser-function 'eww-browse-url)

(load-theme 'tango-dark t)

 ;; maximize window; fullscreen;
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(global-set-key (kbd "<f11>") 'toggle-frame-fullscreen)
 ;;(add-hook 'emacs-startup-hook 'toggle-frame-maximized)

 ;; show time
 (display-time-mode 1)
 (setq display-time-24hr-format t) ;;
 (setq display-time-day-and-date t) ;;


 (tool-bar-mode 0) ;; no tool-bar;
 (menu-bar-mode 0) ;; no menu bar;
(window-numbering-mode t)

;; ivy
(ivy-mode 1)
(setq ivy-use-selectable-prompt t)
(global-set-key (kbd "C-]") 'counsel-etags-find-tag-at-point)

;;;; read only
(defun read-only-setup ()
  (read-only-mode))
(add-hook 'find-file-hook #'read-only-setup)

;;ssh
(setq rlogin-program "ssh")
(setq rlogin-process-connection-type t)

;; key mapping for this emacs only

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  ;;(setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'meta)
  (load-file "~/org/lisp/remote.el")
)

;; multi-term
(require 'multi-term)
(setq multi-term-program "/bin/zsh")
; Use Emacs terminfo, not system terminfo, mac系统出现了4m
(setq system-uses-terminfo nil)

;; (desktop-save-mode 1)

;; google-this
(google-this-mode 1)
(global-set-key (kbd "C-x C-g") 'google-this-mode-submap)

;; google-translate
(require 'google-translate)
(require 'google-translate-smooth-ui)
(global-set-key "\C-ct" 'google-translate-smooth-translate)
(setq google-translate-translation-directions-alist
      '(("en" . "zh-CN") ("en" . "de")))
(setq google-translate-show-phonetic t)
(defun google-translate-json-suggestion (json)
    "Retrieve from JSON (which returns by the
`google-translate-request' function) suggestion. This function
does matter when translating misspelled word. So instead of
translation it is possible to get suggestion."
    (let ((info (aref json 7)))
      (if (and info (> (length info) 0))
 (aref info 1)
nil)))
;; Fix error of "Failed to search TKK"
(defun google-translate--get-b-d1 ()
    ;; TKK='427110.1469889687'
  (list 427110 1469889687))

;;magit
(global-set-key (kbd "C-x g") 'magit-status)

;;;;; org-mode
;latex
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
                              "xelatex -interaction nonstopmode %f"))
; agenda
(setq org-agenda-files '("~/org/lab"))
(global-set-key "\C-ca" 'org-agenda)

; markdown
(require 'ox-md nil t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other babel languages;
   (ditaa . t)
   ;;(c++ . t)
   (dot . t)
   (maxima . t))) ; this line activates maxima

(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-option-modifier 'control)
  ;; for local mac os
  (scroll-bar-mode 0) ;; no scroll bar;

  ;;ditaa
  (setq org-ditaa-jar-path "/usr/local/Cellar/ditaa/0.11.0_1/libexec/ditaa-0.11.0-standalone.jar")
  ;;pdf-viewer
  (pdf-tools-install)
  (setq pdf-view-use-scaling t)
  (defadvice pdf-info-renderpage (before double-width-arg activate)
  (ad-set-arg 1 (* 2 (ad-get-arg 1))))
)

;; google-c-style
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
;; tramp
(customize-set-variable 'tramp-default-method "ssh")
(customize-set-variable 'tramp-default-user "zhuwenqiao.ai")


;; mount and umount remote dirs;
(defconst ssh-command "sshfs ")
(defconst umount-command "umount ")
(defconst ssh-options "-o Ciphers=aes128-ctr -o cache_timeout=115200 -o attr_timeout=115200 -o compression=no,reconnect,defer_permissions,noappledouble,nolocalcaches,no_readahead,auto_cache ")
(defconst remote-user "zhuwenqiao.ai@10.20.178.20")
(defconst remote-dir "/data05/home/zhuwenqiao.ai/work/")
(defconst local-dir " ~/remote/")

(defun mount ()
  (interactive)
  (shell-command (concat ssh-command ssh-options (concat remote-user ":" remote-dir) local-dir))
  (message "mount remote dir to local"))

(defun umount ()
  (interactive)
  (shell-command (concat umount-command local-dir))
  (message "umount local dir"))
 
(defun cppkg ()
  (interactive)
  (shell-command "cd ~/")
  (shell-command "tar zcvf e.tar.gz ~/.emacs.d")
  (shell-command "scp e.tar.gz zhuwenqiao.ai@10.20.178.20:/data05/home/zhuwenqiao.ai/")
  (message "copy e.tar.gz to remote"))
 
(when (eq system-type 'gnu/linux) ;; mac specific settings
  (load-file "~/org/lisp/test.el")
  (load-file "~/org/lisp/build.el")
  (load-file "~/org/lisp/euler.el")
)

 ;; Python Hook
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2))))
 

;;; go-mode
(require 'go-mode)
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(add-hook 'go-mode-hook (lambda () (setq tab-width 2)))

;;; scala-mode
(require 'scala-mode)
(autoload 'scala-mode "scala-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.scala\\'" . scala-mode))

;;; maxima-mode
(add-to-list 'load-path "/usr/local/Cellar/maxima/5.44.0_2/share/emacs")
(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
(autoload 'maxima "maxima" "Maxima interaction" t)
(autoload 'imath-mode "imath" "Imath mode for math formula input" t)
(setq imaxima-use-maxima-mode-flag t)
(add-to-list 'auto-mode-alist '("\\.ma[cx]" . maxima-mode))

;;; lisp
(setq inferior-lisp-program "/usr/local/bin/sbcl")

;;(defun remote-home-20 ()
;;  (interactive)
;;  (find-file "/ssh:zhuwenqiao.ai@10.20.178.20:/data05/home/zhuwenqiao.ai/"))


;; youdao
;; Enable Cache
(setq url-automatic-caching t)

;; Example Key binding
(global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point)

;; Integrate with popwin-el (https://github.com/m2ym/popwin-el)
;; (push "*Youdao Dictionary*" popwin:special-display-config)

;; Set file path for saving search history
;; (setq youdao-dictionary-search-history-file "~/.emacs.d/.youdao")

;; Enable Chinese word segmentation support (支持中文分词)
;; (setq youdao-dictionary-use-chinese-word-segmentation t)



;; after init
(setq inhibit-startup-message nil)
(shell "*local-shell*")
(maxima)
(remote-aml-20)
