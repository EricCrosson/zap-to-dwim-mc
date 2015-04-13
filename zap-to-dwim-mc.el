(defvar zap-char-dwim-mc nil
  "Storage for functions `zap-to-char' and `zap-up-to-char' to
allow them to dwim during `multiple-cursors-mode'.")

(defun zap-char-dwim-mc ()
  "Reset variable `zap-char-dim-mc' to nil."
  (setq zap-char-dwim-mc nil))

(add-hook 'multiple-cursors-mode-enabled-hook 'reset-zap-char-diwm-mc)

(defadvice zap-to-char (around zap-to-char-mc-dwim activate)
  "When invoking `zap-to-char' interactively during
`multiple-cursors-mode', assume all cursors wish to zap to the
same char."
  (let ((kill (current-kill 0 t)))
    (when multiple-cursors-mode
      (if (and zap-char-dwim-mc
               (called-interactively-p 'interactive))
          (zap-to-char 1 kill)
        ad-do-it
        (setq zap-char-dwim-mc (substring-no-properties kill (- (length kill) 1)))))))

(defadvice zap-up-to-char (around zap-up-to-char-mc-dwim activate)
  "When invoking `zap-up-to-char' interactively during
`multiple-cursors-mode', assume all cursors wish to zap up to the
same char."
  (let ((kill (current-kill 0 t)))
    (when multiple-cursors-mode
      (if (and zap-char-dwim-mc
               (called-interactively-p 'interactive))
          ;; todo: pass along prefix key
          (zap-up-to-char 1 kill)
        ad-do-it
        (setq zap-char-dwim-mc (substring-no-properties kill (- (length kill) 1)))))))
