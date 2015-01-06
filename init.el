(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
        ("http" . "127.0.0.1:1315")
        ("https" . "127.0.0.1:1315")))

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(setq el-get-verbose t)

;; personal recipes
(setq el-get-sources
      '((:name el-get :branch "master")

        (:name magit
               :before (global-set-key (kbd "C-x C-z") 'magit-status))

        (:name expand-region
               :before (global-set-key (kbd "C-@") 'er/expand-region))

        ;;你是不是经常按 C-y 放进一个 kill-ring 里的单元。然后 M-y，M-y，…… 来寻找你需要的很久以前剪切下来的东西？很费事吧？
        ;;用了 browse-kill-ring 就好了。你只需要把它绑定到一个热键，比如 C-c k: 就能出现这样一个buffer
        (:name browse-kill-ring
               :before (global-set-key [(control c)(k)] 'browse-kill-ring))

        (:name ace-jump-mode
               :before (global-set-key (kbd "C-c SPC") 'ace-jump-mode))

        (:name descbinds-anything
               :after (progn
                        (descbinds-anything-install)
                        (global-set-key (kbd "C-h b") 'descbinds-anything)))

        (:name goto-last-change
               :before (global-set-key (kbd "C-x C-/") 'goto-last-change))

        (:name projectile
               :after (progn
                        (projectile-global-mode)))
        ))

;; my packages
(setq dim-packages
      (append
       ;; list of packages we use straight from official recipes
       '(multiple-cursors smart-forward fuzzy-format
                          git-emacs magit magit-view-file recentf-ext
                          smex auto-complete auto-complete-rst
                          ace-jump-mode ace-jump-buffer ace-window
                          ruby-mode rvm rinari yaml-mode rspec-mode
                          haml-mode web-mode json-mode zencoding-mode
                          applescript-mode lua-mode
                          pandoc-mode rst-mode markdown-mode muse deft 
                          markdown-mode color-theme-railscasts protobuf-mode)

       (mapcar 'el-get-as-symbol (mapcar 'el-get-source-name el-get-sources))))

(el-get 'sync dim-packages)


;; 手工加载的库
;; helper function
(defun my-add-subdirs-to-load-path (dir)
  (let ((default-directory (concat dir "/")))
    (setq load-path (cons dir load-path))
    (normal-top-level-add-subdirs-to-load-path)))

(my-add-subdirs-to-load-path "~/.emacs.d/vendor")

;; 机器相关的设置放在my-custom.el
(load "~/.emacs.d/my-custom.el")

;; 加载扩展库的配置文件
(mapc 'load (directory-files "~/.emacs.d/config/01base" t "\.el$"))
;; (mapc 'load (directory-files "~/.emacs.d/config/02advedit" t "\.el$"))
(mapc 'load (directory-files "~/.emacs.d/config/20languages" t "\.el$"))
(mapc 'load (directory-files "~/.emacs.d/config/50webdev" t "\.el$"))
;; (mapc 'load (directory-files "~/.emacs.d/config/70emacsonrails" t "\.el$"))
;; (mapc 'load (directory-files "~/.emacs.d/config/99post" t "\.el$"))


