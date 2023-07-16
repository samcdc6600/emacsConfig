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
;; If sb-fci-column-width is changed sb-fci-column-width-minimap in minimap.el
;; should also be changed.
(setq sb-fci-column-width 80)
(load "fill-column-indicator")
(add-hook 'after-change-major-mode-hook 'fci-mode)
(setq fci-mode 0)
(setq fci-rule-column sb-fci-column-width)
(setq fci-rule-width 1)
(setq fci-rule-color "#4d2e6b")			       ; Theme may
					; override this (currently we
					; have it set to a colour that
					; should match up fairly
					; nicely with the purple-haze theme.)
(setq fci-rule-character (string-to-number "2588" 16)) ; 2591
(load "xclip-1.9")
(xclip-mode 1)
;; Enable flash at point when point jumps in position.
(beacon-mode 1)
(setq beacon-color "#660ac2")
;; This only seems to work sometimes. Other times it's just very fast :'(
(setq beacon-blink-duration 0.9) ; Set fade-out duration to x seconds
;; Disable welcome buffer.
(setq inhibit-startup-screen t)
;; These are annoying in GUI mode.
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; When creating a new window in GUI mode with "make-frame" and then closing
;; that (or the original) frame both frames will close (or all open
;; frames). Using this code we can make sure that only the current frame will
;; close and if it is the only frame and changes have been made in any of the
;; buffers then save-buffers-kill-emacs will be called instead of delete-frame
;; and emacs will ask if you really want to quit.
(when window-system
  (defun close-current-frame ()
    "Close the current frame.
If the frame being closed is the sole visible or iconified frame,
exit Emacs."
    (interactive)
    (if (or (null (visible-frame-list))
            (null (cdr (visible-frame-list))))
	(save-buffers-kill-emacs)
      (delete-frame)))

  (global-set-key (kbd "C-x C") 'close-current-frame)

  (global-set-key (kbd "C-x C-c") #'close-current-frame))
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
(defun sb-expand-window-vertically ()
  "Expands the current window vertically by 1 row."
  (interactive)
  (enlarge-window 1))
(global-set-key (kbd "<f8>") 'sb-expand-window-vertically)


(defun sb-shrink-window-vertically ()
  "Shrink the current window vertically by 1 row."
  (interactive)
  (shrink-window 1))
(global-set-key (kbd "<f7>") 'sb-shrink-window-vertically)


(defun sb-expand-window-horizontally ()
  "Expand the current window horizontally by 1 column."
  (interactive)
  (enlarge-window-horizontally 1))
(global-set-key (kbd "<f6>") 'sb-expand-window-horizontally)


;; This is needed for minimap since we cannot switch to the minimap buffer to
;; enlarge it. We also add vertically just for completeness and we might
;; actually we it now that we are thinking about it.
(defun sb-shrink-window-horizontally ()
  "Shrink the current window horizontally by 1 column."
  (interactive)
  (shrink-window-horizontally 1))
(global-set-key (kbd "<f5>") 'sb-shrink-window-horizontally)


(defun sb-line-length ()
  "Returns the length of the line a point."
  (interactive)
   (let (len)
     (setq len (- (line-end-position) (line-beginning-position)))
     (message "Line length at point is: %d" len)))


(defun sb-region-length-inl ()
  "Prints the number of characters in the selected region (including new lines)
in the mini buffer."
  (interactive)
  (if (use-region-p)			; Return t if the region is active and
					; it is appropriate to act on it. 
					; '?' is used for regular expressions.
					; If true.
  (let (len)
    (setq len (- (region-end) (region-beginning)))
    (message "There are %s characters." len))
  					; Else.
  (message "Error no region selected.")))


(defun sb-region-length ()
  "Prints the number of characters in the selected region (minus new line
characters) in the mini buffer."
  (interactive)
  (if (use-region-p)
      (message
       "There are %s characters (less any \"\\n\" characters.)"
       (- (region-end) (region-beginning)
	  (get-count
	   '?\n
	   (buffer-substring
	    (region-beginning) (region-end)))))
    (message "Error no region selected.")))


(defun get-count (regexp str)
  "Returns the number of occurrences of regexp in str."
  (cl-count regexp str))


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
;; Change fill column width for mode...
(add-hook 'text-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'c-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'c++-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'html-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'asm-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'css-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'shell-script-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
(add-hook 'java-mode-hook
	  (lambda ()
            (set-fill-column sb-fci-column-width)))
;; Enable minimap minor mode for major modes.
;; NOTE THAT MINIMAP ONLY WORKS CORRECTLY IN GUI MODE. SO WE CHECK FOR THAT
;; HERE.
(when window-system
  (add-hook 'c-mode-hook		'minimap-mode)
  (add-hook 'c++-mode-hook		'minimap-mode)
  (add-hook 'css-mode-hook	 	'minimap-mode)
  (add-hook 'shell-script-mode-hook	'minimap-mode)
  (add-hook 'emacs-lisp-mode-hook	'minimap-mode)
  (add-hook 'java-mode-hook		'minimap-mode))

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


;; Install Use-Package (MELPA must be setup first) =============================
;; =============================================================================
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; Setting use-package-always-ensure to t means we don't have to specify
;; :ensure t in packages we’d like to declare and install using use-package.
;; Ensure makes sure packages are installed at startup.
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
;; =============================================================================


;; Minimap  Mode - Start =======================================================
;; =============================================================================
;; NOTE THAT MINIMAP ONLY WORKS CORRECTLY IN GUI MODE. SO WE CHECK FOR THAT
;; HERE. 
(when window-system
  (use-package minimap
    :ensure t)
  
  (set-face-attribute 'minimap-font-face nil :height 42)
  
  (custom-set-faces
   '(minimap-active-region-background
     ((t (:background "#19062d"))))))

;; Default is 0.15
(setq minimap-width-fraction 0.12)
;; Default is 30
(setq minimap-minimum-width 22)
;; =============================================================================


;; LSP (Language Server Protocol) Mode - Start =================================
;; =============================================================================
;; NOTE: FOR C++ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; For c++-mode we need Clangd. This can be installed on FreeBSD by installing
;; llvm. A compile_commands.json is required in the root of the project
;; directory. One can be generated using this site (assuming you've got a make
;; file.): https://texttoolkit.com/compilation-database-generator
;; Sadly we've not found a better way yet.
(use-package lsp-mode
  :hook ((c++-mode) . lsp-deferred) ; XYZ are to be replaced by python, c++, etc.
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c m"))
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  ;; USE lsp-toggle-on-type-formatting to disable annoying auto formatting when
  ;; pressing enter. This is a function and so we don't think we can use setq to
  ;; call is. We don't understand exactly how use-package works and thus aren't
  ;; going to fix this right now. This is just a note so that we know how to
  ;; disable it even if we need to do it manually and so that we can fix it
  ;; latter. 
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05))
(use-package company)			; Needed for nice auto completion list.

;; (use-package lsp-mode
;; 	     :commands (lsp lsp-deferred)
;; 	     :init
;; 	     (setq lsp-keymap-prefix "C-c m"))
;; LSP (Language Server Protocol) Mode - End ===================================


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
 '(package-selected-packages
   '(fira-code-mode beacon fancy-narrow company company-mode lsp-ui lsp-mode use-package))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
