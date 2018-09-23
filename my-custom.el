;; set backup-directory-alist
(setq backup-directory-alist (quote (("." . "~/.emacs.d/tmp"))))

;; set user infomation
(setq user-full-name "crazycode")
(setq user-mail-address "crazycode@gmail.com")
;; set default location
(setq calendar-latitude 31.22)
(setq calendar-longitude 121.48)
(setq calendar-location-name "Shanghai")

;; see my-font.el
(setq my-default-font-size ":pixelsize=16")
(setq my-default-chinese-font-size 14)

;; 解决不能运行node的问题
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))
