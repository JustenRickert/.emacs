(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("9cb6358979981949d1ae9da907a5d38fb6cde1776e8956a1db150925f2dad6c1" "b0ab5c9172ea02fba36b974bbd93bc26e9d26f379c9a29b84903c666a5fde837" "40f6a7af0dfad67c0d4df2a1dd86175436d79fc69ea61614d668a635c2cd94ab" default)))
 '(default-input-method "latin-1-prefix")
 '(org-agenda-files (quote ("~/org/calendar.org")))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro for Powerline" :foundry "ADBE" :slant normal :weight normal :height 108 :width normal)))))

;; diary integration is supposed to be nice
(setq org-agenda-include-diary t)

;; smooth scrolling
(setq smooth-scroll-mode t)
(setq scroll-step           1
      scroll-conservatively 10000 )

;; updates .zshrc to emacs
(let ((path (shell-command-to-string ". ~/.zshrc; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path 
        (append
         (split-string-and-unquote path ":")
         exec-path)))

;; flyspell-issue-message-flag apparently causes an enormous slowdown!
(setq flyspell-issue-message-flag nil)

;; theme zenburn NOTE: can't run load-theme in here, need to run as
;; hook for some reason >_>
(add-hook 'after-init-hook
	  (lambda ()
	    (load-theme 'tango-plus t)
	    (set-cursor-color "#5f615c")
	    ;;   (load-theme 'zenburn t)))
	    t))

;; is kind of neat, automatic saving and so forth.
(setq version-control t)
;; (setq kept-new-versions 2)
;; (setq kept-old-versions 2)

;; pabbrev mode wonder goodies
(add-hook  'after-init-hook
	   (lambda ()
	     (require 'pabbrev)
	     (define-key pabbrev-mode-map [tab] 'pabbrev-expand-maybe)
	     (require 'popup)
	     (defun pabbrevx-suggestions-goto-buffer (suggestions)
	       (let* ((candidates (mapcar 'car suggestions))
		      (bounds (pabbrev-bounds-of-thing-at-point))
		      (selection (popup-menu* candidates
					      :point (car bounds)
					      :scroll-bar t)))
		 (when selection
		   ;; modified version of pabbrev-suggestions-insert
		   (let ((point))
		     (save-excursion
		       (progn
			 (delete-region (car bounds) (cdr bounds))
			 (insert selection)
			 (setq point (point))))
		     (if point
			 (goto-char point))
		     ;; need to nil this so pabbrev-expand-maybe-full won't try
		     ;; pabbrev expansion if user hits another TAB after ac aborts
		     (setq pabbrev-last-expansion-suggestions nil)
		     ))))
	     (fset 'pabbrev-suggestions-goto-buffer 'pabbrevx-suggestions-goto-buffer)

	     t))


;;org-mode stuff
;;(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook
	  (lambda ()
	    (flyspell-mode t)
	    (set-fill-column 82)
	    (org-indent-mode t)
	    ;; TIL one can setq.  Also, C-hv for search var
	    (setq org-pretty-entities t)
	    (auto-fill-mode t)
	    ;;
	    (pabbrev-mode t);
	    t))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js3-mode))
(add-hook 'js3-mode-hook
	  (lambda ()
	    (auto-complete-mode t)
	    (pabbrev-mode t)
	    t))

;; org-mode grobals
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

;;keyboard switch
(global-set-key (kbd "\C-ci") 'fd-switch-dictionary)

;;abbrev manipulation
(global-set-key (kbd "M-\\") 'pabbrev-expand)
(define-key minibuffer-local-map (kbd "M-\\") 'pabbrev-expand)

;; ispell globaln
;; (global-set-key "\C-ci" 'ispell-region)

;; melpa
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

(defun fd-switch-dictionary()
  (interactive)
  (let* ((dic ispell-current-dictionary)
    	 (change (if (string= dic "francais") "english" "francais")))
    (ispell-change-dictionary change)
    (message "Dictionary switched from %s to %s" dic change)
    ))

