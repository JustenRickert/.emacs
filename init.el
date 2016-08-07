;; load this file instead!  It is written in org-mode, though!
(require 'org)
(require 'ob-tangle)
(setq debug-on-entry t)
(org-babel-load-file
 (expand-file-name "emacs-init.org"
                 user-emacs-directory))
