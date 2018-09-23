;; 前端开发环境配置


;; emmet-mode
;; (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
;; (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
;; (add-hook 'web-mode-hook 'emmet-mode)
;; (add-to-list 'auto-mode-alist '("\\.jsx$" . 'emmet-mode))


;;;;;;;;;;;;;;
;emmet-mode
;;;;;;;;;;;;;
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)


;;;;;;;;;;;;;;
;web-mode
;;;;;;;;;;;;;;;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; flycheck
(require 'flycheck)
;;(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(json-jsonlist)))

;; js2-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.sjs$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.es6$" . js2-mode))
(setq js2-allow-rhino-new-expr-initializer nil)
(setq js2-enter-indents-newline t)
(setq js2-global-externs '("module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON"))
(setq js2-idle-timer-delay 0.1)
(setq js2-indent-on-enter-key nil)
(setq js2-mirror-mode nil)
(setq js2-strict-inconsistent-return-warning nil)
(setq js2-auto-indent-p t)
(setq js2-include-rhino-externs nil)
(setq js2-include-gears-externs nil)
(setq js2-concat-multiline-strings 'eol)
(setq js2-rebind-eol-bol-keys nil)
(setq js2-mode-show-parse-errors t)
(setq js2-mode-show-strict-warnings nil)




;;;;;;;;;;;;;;;;
;Tide
;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(dolist (hook (list
               'js2-mode-hook
               'rjsx-mode-hook
               'typescript-mode-hook
               ))
  (add-hook hook (lambda ()
                   ;; 初始化 tide
                   (tide-setup)
                   ;; 当 tsserver 服务没有启动时自动重新启动
                   (unless (tide-current-server)
                     (tide-restart-server))
                   )))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)
(require 'web-mode)
(add-hook 'web-mode-hook
          (lambda ()
            (when (and (buffer-file-name)
                       (string-equal "tsx" (file-name-extension buffer-file-name)))
              (setup-tide-mode))))
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (when (string-equal "tsx" (file-name-extension buffer-file-name))
;;               (setup-tide-mode))))

;; json-mode
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)
