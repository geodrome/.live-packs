;; Startup dimensions
(add-to-list 'default-frame-alist '(height . 68))
(add-to-list 'default-frame-alist '(width . 105))

;; Set cursor color - i think it's being overriden by evil-mode
(add-to-list 'default-frame-alist '(cursor-color . "palegoldenrod"))

;; Set the font
(add-to-list 'default-frame-alist '(font . "Monaco 12"))

;; Disabling the built-in live/colour-pack disables the highlight current line 
;; feature. This adds it back.
(global-hl-line-mode 1)
(set-face-background 'hl-line "#222")

; Remove 'prettyfications' from clojure-mode
; with the first "type" of Clojure file you open (i.e. .clj or .cljs); this should knock out
; the special formatting on every buffer that ever has clojure-mode applied to it
(add-hook 'clojure-mode-hook
          (lambda ()
            (font-lock-remove-keywords
             nil `(("(\\(fn\\)[\[[:space:]]"
                    (0 (progn (compose-region (match-beginning 1)
                                              (match-end 1) "λ")
                              nil)))
                   ("\\(#\\)("
                    (0 (progn (compose-region (match-beginning 1)
                                              (match-end 1) "ƒ")
                              nil)))
                   ("\\(#\\){"
                    (0 (progn (compose-region (match-beginning 1)
                                              (match-end 1) "∈")
                              nil)))))))
                              
;; Make REPL come up in emacs state
(evil-set-initial-state 'nrepl-mode 'emacs)
;(evil-set-initial-state 'nrepl-mode 'insert) ;; 'insert doesn't work, but 'emacs works

;; hide the *nrepl-connection* and *nrepl-server* buffers from appearing in some buffer switching commands
(setq nrepl-hide-special-buffers t)

;; Display ido results vertically, rather than horizontally
;; (setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

; enable MELPA
(add-to-list 'package-archives
     '("melpa" . "http://melpa.milkbox.net/packages/") t)
    
    
;;; cljx files in clojure mode




















