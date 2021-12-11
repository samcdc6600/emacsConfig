(put 'narrow-to-region 'disabled nil)


(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'xclip)
(require 'fill-column-indicator)

;; (add-hook 'c-mode-hook 'fci-mode)
;; (add-hook 'c++-mode-hook 'fci-mode)
;;(defun fciEn () (setq fill-column 80)(add-hook 'after-change-major-mode-hook 'fci-mode))
(setq-default fill-column 80)
(add-hook 'after-change-major-mode-hook 'fci-mode)
(setq fci-rule-width 1)
(setq fci-rule-character (string-to-number "2588" 16))
(setq fci-rule-color "#0e0348")
