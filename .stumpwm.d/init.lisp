;; A customized config for stumpwm

;;-- quicklisp
  (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                         (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
      (load quicklisp-init)))
;; init
;;------------------------------
(in-package :stumpwm)
(setf *default-package* :stumpwm)
;;------------------------------
;;;; Load modules stumpwm-contrib
(set-module-dir
 (concatenate 'string (getenv "HOME") "/.stumpwm.d/modules"))
;; if the module folder is in a different location
;; (set-module-dir "/usr/share/stumpwm/contrib/util/")

;; up the debug level (see ~/.xsession-errors)
;; (setf stumpwm::*debug-level* 0)

;; set the font for the message bar and input bar
;; (set-font "-*-FreeMono-medium-r-*-*-6*")
(set-font "-adobe-helvetica-medium-r-normal-*-14-*-*-*-*-*-*-*")
;; (set-font "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-7")
;; (set-font "-xos4-terminus-medium-r-normal--0-0-72-72-c-0-iso8859-7")
;; (set-font "-*-dina-medium-r-normal-*-*-*-*-*-*-*-*-*")
;; (set-font "-lispm-fixed-medium-r-normal-*-13-*-*-*-*-*-*-*")
;; (set-font "-artwiz-smoothansi-medium-r-normal--13-130-75-75-m-60-iso8859-1")
;; (set-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1

;; Starup Programs
;;------------------------------
;;;; Set Background
(run-shell-command "sh ~/.screenlayout/arandr.sh")
(run-shell-command "nitrogen --restore")
(run-shell-command "picom")
(run-shell-command "xsetroot -cursor_name left_ptr")
(run-shell-command "emacs --daemon")

;;------------------------------
;;;; Config mouse
(setf *mouse-focus-policy*    :click
      *float-window-modifier* :META)



;;------------------------------
;; Custom modules
;;------------------------------

;;;; Theme Colors
(defvar phundrak-nord0  "#2e3440")
(defvar phundrak-nord1  "#3b4252")
(defvar phundrak-nord2  "#434c5e")
(defvar phundrak-nord3  "#4c566a")
(defvar phundrak-nord4  "#d8dee9")
(defvar phundrak-nord5  "#e5e9f0")
(defvar phundrak-nord6  "#eceff4")
(defvar phundrak-nord7  "#8fbcbb")
(defvar phundrak-nord8  "#88c0d0")
(defvar phundrak-nord9  "#81a1c1")
(defvar phundrak-nord10 "#5e81ac")
(defvar phundrak-nord11 "#bf616a")
(defvar phundrak-nord12 "#d08770")
(defvar phundrak-nord13 "#ebcb8b")
(defvar phundrak-nord14 "#a3be8c")
(defvar phundrak-nord15 "#b48ead")

;;------------------------------
;;;; Set Colors
(set-border-color                 phundrak-nord4)
(set-focus-color                  phundrak-nord15)
(set-unfocus-color                phundrak-nord4)
(set-float-focus-color            phundrak-nord15)
(set-float-unfocus-color          phundrak-nord4)
(setf *normal-border-width*       3
      *float-window-border*       3
      *float-window-title-height* 15
      *window-border-style*       :thick)


;;------------------------------
;;;; message and input bar
(setf *input-window-gravity*     :bottom
      *message-window-padding*   5
      *message-window-y-padding* 5
      *message-window-gravity*   :bottom-right)


;;------------------------------
;;; gaps
(load-module "swm-gaps")
(setf swm-gaps:*head-gaps-size*  5
      swm-gaps:*inner-gaps-size* 5
      swm-gaps:*outer-gaps-size* 10)
(when *initializing* (swm-gaps:toggle-gaps))


;;------------------------------
;;; Configuration keybindings
(set-prefix-key (kbd "Menu"))

(define-key *root-map* (kbd "M-x") "exec")
(define-key *root-map* (kbd "M-r") "colon")
(define-key *root-map* (kbd "Q")   "loadrc")
(define-key *root-map* (kbd "M-q") "quit")

(define-key *root-map* (kbd "-") "vsplit")
(define-key *root-map* (kbd "|") "hsplit")

(define-key *root-map* (kbd "c") "exec alacritty")
(define-key *root-map* (kbd "C-c") "exec alacritty")
(define-key *root-map* (kbd "e") "exec emacsclient -c")
(define-key *root-map* (kbd "C-e") "exec emacsclient -nw")
;;------------------------------
;;; Rofi Configuration
(stumpwm:add-to-load-path "~/.stumpwm.d/modules/rofi")
(load-module "rofi")

;; list of pairs '(("name" . "command"))
(defvar *my-menu*
  '(("Terminal" . "exec alacritty")
    ("File Manager" . "exec alacritty -e ranger")
    ("💼  Work >" . (("Emacs" . "emacsclient -c")))
    ("🌍  Inet >" . (("Firefox" . "firefox")
                     ("Telegram" . "telegram-desktop")))))

(defcommand my-menu () ()
  (rofi:menu *my-menu*)
  (rofi:menu *my-menu* "-show-icons -theme gruvbox-dark-hard -cycle false"))

(define-key *root-map* (kbd "s-x") "my-menu")

;; windowlist
(define-key *root-map* (kbd "s-Tab") "rofi-windowlist")


;;------------------------------
;;;; Enable modeline

;; Load linemoe modules
(load-module "battery-portable")
(load-module "cpu")
(load-module "mem")

;; set modeline options
(setf
 *mode-line-background-color*    phundrak-nord1
 *mode-line-foreground-color*    phundrak-nord5
 *mode-line-border-color*        phundrak-nord1
 *mode-line-border-width*        0
 *mode-line-timeout*             1
 *group-format*                  " %t "
 *time-modeline-string*          "%H:%M"
 *window-format*                 "%n:%30t"
 mem::*mem-modeline-fmt*         "%a%p"
 *screen-mode-line-format* (list "%g %v ^> | %M | %B | %d"))


;; Finally enable the modeline
;; enable one monitor
;; (enable-mode-line (current-screen) (current-head) t)
;; Enable many monitor
(dolist (h (screen-heads (current-screen)))
 (enable-mode-line (current-screen) h t))

;;------------------------------
;; System Tray for StumpWM mode-line.
;; (ql:quickload :xembed)
;; (load-module "stumptray")
;; (stumptray::stumptray)

;;------------------------------
;; end config
;;------------------------------
(setf *startup-message* "StumpWM is ready!")
