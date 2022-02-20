(package-initialize)


;; Alter Load Paths - Start ====================================================
;; =============================================================================
(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'custom-theme-load-path
	     "~/.emacs.d/lisp/themes/")

;; Alter Load Paths - End ======================================================


;; Misc Stuff - Start ==========================================================
;; =============================================================================
;; If no suffix is specified Emacs will look for .elc before .el
(load "fill-column-indicator")
(add-hook 'after-change-major-mode-hook 'fci-mode)
(setq fci-mode 0)
(setq fci-rule-column 80)
(setq fci-rule-width 1)
(setq fci-rule-color "#4d2e6b")			       ; Theme may
					; override this (currently we
					; have it set to a colour that
					; should match up fairly
					; nicely with the purple-haze theme.)
(setq fci-rule-character (string-to-number "2588" 16)) ; 2591

(load "xclip-1.9")
(xclip-mode 1)

;; Misc Stuff - End ============================================================


;; Theme Stuff - Start =========================================================
;; =============================================================================
;; (load-theme 'soothe t)
					; Sooth seem's to set
					; something that most of the
					; other themes don't reset. So by
					; enabling it and then
					; enabling one of most of the
					; other themes you can create
					; a hybrid them.
;; (load-theme 'manoj-dark)
;; (load-theme 'wheatgrass)
;; (load-theme 'afternoon t)
;; (load-theme 'cyberpunk t)
;; (load-theme 'tomorrow-night-paradise t)
;; (load-theme 'twilight t)
;; (load-theme 'ujelly t)
;; (load-theme 'billw t)
;; (load-theme 'borland-blue t) ;*
(load-theme 'cherry-blossom t) ; ***
;; (load-theme 'clarity t)
;; (load-theme 'comidia t)
;; (load-theme 'evenhold t) ; *
;; (load-theme 'night-owl t)
;;(load-theme 'purple-haze t) ; ***
;; (load-theme 'zweilight t)

;; Theme Stuff - End ===========================================================


;; SB Custom Functions - Start =================================================
;; =============================================================================
(fset 'sb-expand-window-vertically
      (kmacro-lambda-form [?\C-x ?^] 0 "%d"))
(global-set-key (kbd "<f9>") 'sb-expand-window-vertically)

(fset 'sb-expand-window-horizontally
      (kmacro-lambda-form [?\C-x ?\}] 0 "%d"))
(global-set-key (kbd "<f8>") 'sb-expand-window-horizontally)

(defun sb-line-length ()
  "Returns the length of the line a point."
  (interactive)
   (let (len)
     (setq len (- (line-end-position) (line-beginning-position)))
     (message "Line length at point is: %d" len)))

(defun sb-asterisk-comment ()
  "Generally intended for use with add-hook to set comment-start for mode."
  (setq-local comment-start "*	"))

(defun sb-semicolon-comment ()
  "Generally intended for use with add-hook to set comment-start for mode."
  (setq-local comment-start "; "))

;; The following two functions are taken from the book "GNU Emacs and
;; XEmacs" and thus aren't written by us. In any case we choose to put
;; them here because it seem's like a nice place to put them :) .
(defun dos-new-lines-to-unix-new-lines() ; Convert DOS text file to
					; Unix text file.
  "Strip DOS carriage return characters from a buffer."
  ;; This allows the function to be executed by simply entering it's name in the
  ;; minibuffer. Otherwise it could only be executed if it was evaluated
  ;; manually.
  (interactive)
  ;; When save-excursion is used as a wrapper around other functions any changes
  ;; they make to the position of point are reverted when save-excursion is
  ;; executed.
  (save-excursion
  ;; Point-min: return the minimum permissible value of point in the current
  ;; buffer. This is 1, unless narrowing (a buffer restriction) is in effect.
  ;; Goto-char: Set point to POSITION, a number or marker.
  ;; Beginning of buffer is position (point-min), end is (point-max).
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match ""))
  (message "Operation complete.")))

(defun unix-new-lines-to-dos-new-lines() ; Convert Unix text file to
					; DOS text file.
  "Insert DOS carriage-return characters into a buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t) (replace-match "\r\n"))
    (message "Operation complete")))

;; SB Custom Functions - End ===================================================


;; Spell Checking - Start ======================================================
;; =============================================================================
;; Hunspell is a shell program and must be installed.
(setq ispell-program-name (executable-find "hunspell")
      ispell-dictionary "en_GB")
;; Flyspell-correct-ivy has to be installed using melpa.
(require 'flyspell-correct-ivy)
(define-key flyspell-mode-map (kbd "C-c $") 'flyspell-correct-wrapper)

;; Spell Checking - End ========================================================


;; Hooks - Start ===============================================================
;; =============================================================================
;; Enable flyspell-mode for text-mode and it's derivatives.
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
;; Enable flyspell-prog-mode for prog-mode and it's derivatives.
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
;; (dolist (hook '(prog-mode-hook))
;;   (add-hook hook (lambda () (flyspell-prog-mode 1))))
;; Turn on auto-fill-mode...
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'c-mode-hook 'auto-fill-mode)
(add-hook 'c++-mode-hook 'auto-fill-mode)
(add-hook 'html-mode-hook 'auto-fill-mode)
(add-hook 'asm-mode-hook 'auto-fill-mode)
(add-hook 'css-mode-hook 'auto-fill-mode)
(add-hook 'shell-script-mode-hook 'auto-fill-mode)
(add-hook 'emacs-lisp-mode-hook 'auto-fill-mode)
(add-hook 'java-mode-hook 'auto-fill-mode)
;; Turn on fci-mode...
(add-hook 'text-mode-hook 'fci-mode)
(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'c++-mode-hook 'fci-mode)
(add-hook 'html-mode-hook 'fci-mode)
(add-hook 'asm-mode-hook 'fci-mode)
(add-hook 'css-mode-hook 'fci-mode)
(add-hook 'shell-script-mode-hook 'fci-mode)
(add-hook 'emacs-lisp-mode-hook 'fci-mode)
(add-hook 'java-mode-hook 'fci-mode)
;; Add "*	" as the comment for text mode!
(add-hook 'text-mode-hook 'sb-asterisk-comment)
;; Add "; " as the comment for asm mode!
(eval-after-load "asm"
  (add-hook 'asm-mode-hook 'sb-semicolon-comment))

;; Hooks - End =================================================================


;; Load Emacs 24's Package System, Add MELPA Repository - Start ================
;; =============================================================================
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "https://melpa.org/packages/")
   t))

;; Load Emacs 24's Package System, Add MELPA Repository - End ==================


;; Melpa And Customize Stuff - Start ===========================================
;; =============================================================================

;; Inserting the following line into your ~/.emacs files will cause
;; the mode to be loaded whenever it's needed: (add-hook
;; text-mode-hook (lambda () (auto-fill-mode 1))). That is the mode
;; auto-fill-mode.

;; By default, only files with the *.txt suffix are automatically put
;; in text mode. If you have files with a different suffix that should
;; be in text-mode, a statement like this in your ~/.emacs file should
;; do the trick: (add-to-list 'auto-mode-alist (cons "\\.jrn\\'"
;; 'text-mode)). See page 156 of GNU Emacs and Xemacs.

(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(use-package))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
