(defun circle-windows ()
  (interactive)
  (let ((owindow (selected-window))
        (obuffer (current-buffer))
        )
    (while (not (equal owindow (next-window)))
      (set-window-buffer (selected-window) (window-buffer (next-window)))
      (select-window (next-window)))
    (set-window-buffer (selected-window) obuffer)
    (select-window owindow)))

(defun move-region-around (direction beg end)
  (let (real-beg
        real-end
        target-beg
        deactivate-mark
        text)
    (save-excursion
      (goto-char beg)
      (setq real-beg (line-beginning-position))

      (when (equal direction 'up)
        (setq target-beg (line-beginning-position 0)))

      (goto-char end)
      (setq real-end (line-beginning-position 2))

      (when (equal direction 'down)
        (setq target-beg (copy-marker (line-beginning-position 3)))) ;must use marker

      (setq text (buffer-substring-no-properties real-beg real-end))
      (delete-region real-beg real-end)
      (goto-char target-beg)
      (insert text)
      )

    (set-mark (+ target-beg (- real-end real-beg 1)))
    (goto-char target-beg)
    (setq transient-mark-mode 'only)))


(defun move-region-up (beg end)
  (interactive "r")
  (move-region-around 'up beg end))

(defun move-region-down (beg end)
  (interactive "r")
  (move-region-around 'down beg end))

;;插入日期时间
;;{{{
;; insert current date
(defun my-insert-date ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a")))

;; insert current time
(defun my-insert-time ()
  (interactive)
  (insert (format-time-string "%p %I:%M")))

(global-set-key "\C-c\C-d" 'my-insert-date)
(global-set-key "\C-c\C-t" 'my-insert-time)

(global-set-key [\C-f10] 'toggle-menu-bar-mode-from-frame)

(global-set-key (quote [M-up]) (quote move-region-up))
(global-set-key (quote [M-down]) (quote move-region-down))
(global-set-key "\C-c\C-c2" 'circle-windows)
(global-set-key "\C-c\C-x2" 'circle-windows)

;;my buffers key binding.
(defun my-kill-other-buffers (&optional list)
  "Kill other buffers except the current one."
  (interactive)
  (if (null list)
      (setq list (buffer-list)))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (if (not (string-equal name (buffer-name (current-buffer))))
      (and name  ; Can be nil for an indirect buffer, if we killed the base buffer.
           (not (string-equal name ""))
           (/= (aref name 0) ?\s)
           (kill-buffer buffer))))
    (setq list (cdr list))))

(defun my-kill-current-buffer ()
  "Kill current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x q") 'my-kill-other-buffers)
(global-set-key [\C-f4] 'my-kill-current-buffer)
;;(global-set-key (kbd "C-x <f4>") 'my-kill-current-buffer)
