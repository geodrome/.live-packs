;; Random useful functions lifted from the web
(defun create-shell ()
    "creates an shell with a given name"
    (interactive);; "Prompt\n shell name:")
    (let ((shell-name (read-string "shell name: " nil)))
    (shell (concat "*" shell-name "*"))))

;; using eshell for now    
(define-key evil-ex-map "shelle" 'eshell)
(define-key evil-ex-map "shell" 'shell)

;; Clearing eshell
(defun eshell/clear ()
  "04Dec2001 - sailor, to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(define-key evil-ex-map "clearshell" 'clear)    
    

;; Delete file and buffer in Emacs
(defun delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(global-set-key (kbd "C-c k") 'delete-this-buffer-and-file)
(define-key evil-ex-map "Bufferd" 'delete-this-buffer-and-file)

;; Send expression to repl
(defun nrepl-eval-expression-at-point-in-repl ()
  (interactive)
  (let ((form (nrepl-expression-at-point)))
    ;; Strip excess whitespace
    (while (string-match "\\`\s+\\|\n+\\'" form)
      (setq form (replace-match "" t t form)))
    (set-buffer (nrepl-find-or-create-repl-buffer))
    (goto-char (point-max))
    (insert form)
    (nrepl-return)))
(global-set-key (kbd "C-'") 'nrepl-eval-expression-at-point-in-repl)

;; Use my-keys-minor-mode for all my "override" key bindings to override all major/minor 
;; mode maps and make sure my binding is always in effect

;; Start with a keymap
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;;;; Keybindings START

;; Window movement
(define-key my-keys-minor-mode-map (kbd "C-k") 'windmove-up)
(define-key my-keys-minor-mode-map (kbd "C-j") 'windmove-down)
(define-key my-keys-minor-mode-map (kbd "C-l") 'windmove-right)
(define-key my-keys-minor-mode-map (kbd "C-h") 'windmove-left)

(define-key my-keys-minor-mode-map (kbd "S-C-h") 'shrink-window-horizontally)
(define-key my-keys-minor-mode-map (kbd "S-C-l") 'enlarge-window-horizontally)
(define-key my-keys-minor-mode-map (kbd "S-C-j") 'shrink-window)
(define-key my-keys-minor-mode-map (kbd "S-C-k") 'enlarge-window)

;; Carrot movement - useful for skipping over chars in insert mode
;; may want to add this specifically to insert mode
;; actually C-f already available
;; (define-key my-keys-minor-mode-map (kbd "C-f") 'forward-char)


;; Replace ESC 
;; so that esc actually quits pretty much anything (like pending prompts in the minibuffer)

(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
    
(let ((esq-chord "df"))
  (key-chord-define my-keys-minor-mode-map esq-chord 'evil-normal-state)
  (key-chord-define evil-normal-state-map esq-chord 'keyboard-quit)
  (key-chord-define evil-visual-state-map esq-chord 'keyboard-quit)
  (key-chord-define minibuffer-local-map esq-chord 'minibuffer-keyboard-quit)
  (key-chord-define minibuffer-local-ns-map esq-chord 'minibuffer-keyboard-quit)
  (key-chord-define minibuffer-local-completion-map esq-chord 'minibuffer-keyboard-quit)
  (key-chord-define minibuffer-local-must-match-map esq-chord 'minibuffer-keyboard-quit)
  (key-chord-define minibuffer-local-isearch-map esq-chord 'minibuffer-keyboard-quit)
  ;(global-set-key esq-chord 'evil-exit-emacs-state)
  ;(key-chord-define my-keys-minor-mode-map esq-chord 'evil-exit-emacs-state)
)

;;; https://github.com/mbriggs/.emacs.d/blob/master/my-keymaps.el
(define-key evil-normal-state-map "  " 'ace-jump-mode)
(define-key evil-normal-state-map " k" 'ace-jump-char-mode)
(define-key evil-normal-state-map " l" 'ace-jump-line-mode)
(define-key evil-normal-state-map " r" 'rename-buffer)

;; Me using the space idea
(define-key evil-normal-state-map " x" 'kill-sexp)

;; Some more chords
(key-chord-define my-keys-minor-mode-map "ee" 'evil-emacs-state)

;; Ex-commands are vim commands beginning with semicolon I find these very convenient
;; much more than typical emacs key combos. Define ex-commands here:

(define-key evil-ex-map "e" 'ido-find-file)
(define-key evil-ex-map "ls" 'ace-jump-buffer)
(define-key evil-ex-map "buffer" 'ido-switch-buffer)

(define-key evil-ex-map "replj" 'nrepl-jack-in)
(define-key evil-ex-map "replns" 'nrepl-set-ns)
(define-key evil-ex-map "replc" 'nrepl-find-and-clear-repl-buffer)
(define-key evil-ex-map "repli" 'nrepl-interrupt)
(define-key evil-ex-map "Evalns" 'nrepl-eval-ns-form)

;; must be evaled from repl buffer, which is in emacs mode and no ex commands
(define-key evil-ex-map "replnfo" 'nrepl-display-current-connection-info)

(define-key evil-ex-map "repllf" 'nrepl-load-file) ; VIM has :lfile or something
(define-key evil-ex-map "repllb" 'nrepl-load-current-buffer)
(define-key evil-ex-map "Doc" 'nrepl-doc)
(define-key evil-ex-map "Source" 'nrepl-src)

;; Jump to symbol definition and back
;; !!!! bindings starting with [ should not be in my overriding keymap or else can't type [
(define-key evil-ex-map (kbd "jd") 'nrepl-jump)
(define-key evil-ex-map (kbd "jb") 'nrepl-jump-back)
; These seem to be bound to c-tag based navigation for the same actions
;(define-key my-keys-minor-mode-map (kbd "C-]") 'nrepl-jump)
;(define-key my-keys-minor-mode-map (kbd "C-T") 'nrepl-jump-back)


;;;; Keybindings END


;; Define and enable minor mode
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)

;; Probably should turn off my-keys-minor-mode in the minibuffer
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)