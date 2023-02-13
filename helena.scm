;; -*- mode: scheme; -*-
;; This is an operating system configuration

(use-modules
 (gnu)
 (nongnu packages linux)
 (nongnu packages fonts)
 (nongnu packages mozilla)
 (gnu system nss)
 (gnu system pam)
 (rnrs lists)
 (guix packages)
 (gnu services dbus)
 (gnu services docker)
 (gnu services audio))

(use-service-modules
 desktop cups networking nix sysctl virtualization
 sound xorg)

(use-package-modules
 bootloaders ccache certs cups audio pulseaudio lisp emacs
 emacs-xyz lisp-xyz libreoffice fonts geo ghostscript gnome gnupg
 guile guile-xyz linux nano ntp shellutils gimp scanner ssh
 tex package-management shells curl admin disk compton mtools
 video python-xyz version-control xorg gnuzilla ncurses terminals
 web-browsers gstreamer gnucash password-utils xdisorg gnupg
 chromium glib wm polkit glib)

(operating-system
 (kernel linux)
 (firmware
  (list linux-firmware))
 (host-name "helena")
 (timezone "America/Sao_Paulo")
 (locale "en_US.utf8")
 ;; Choose US English keyboard layout.  The "altgr-intl"
 ;; variant provides dead keys for accented characters.
 (keyboard-layout
  (keyboard-layout "br" "abnt2"))
 ;; Use the UEFI variant of GRUB with the EFI System
 ;; Partition mounted on /boot/efi.
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets
    '("/boot/efi"))
   (keyboard-layout keyboard-layout)))
 (file-systems
  (append
   (list
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/")
     (type "btrfs")
     (options "subvol=@,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/boot")
     (type "btrfs")
     (options "subvol=@boot,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/var/log")
     (type "btrfs")
     (options "subvol=@log,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/var/tmp")
     (type "btrfs")
     (options "subvol=@tmp,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/gnu")
     (type "btrfs")
     (options "subvol=@gnu,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/.snapshots")
     (type "btrfs")
     (options "subvol=@.snapshots,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home")
     (type "btrfs")
     (options "subvol=@home,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home/carlosfilho")
     (type "btrfs")
     (options "subvol=@carlosfilho,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home/carlosfilho/Documentos")
     (type "btrfs")
     (options "subvol=@carlosfilho/Documentos,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home/carlosfilho/Imagens")
     (type "btrfs")
     (options "subvol=@carlosfilho/Imagens,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home/carlosfilho/ISOs")
     (type "btrfs")
     (options "subvol=@carlosfilho/ISOs,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home/carlosfilho/Livros")
     (type "btrfs")
     (options "subvol=@carlosfilho/Livros,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home/carlosfilho/Music")
     (type "btrfs")
     (options "subvol=@carlosfilho/Music,compress-force=lzo"))
    (file-system
     (device
      (file-system-label "helena"))
     (mount-point "/home/carlosfilho/Projetos")
     (type "btrfs")
     (options "subvol=@carlosfilho/Projetos,compress-force=lzo"))
    (file-system
     (device
      (uuid "9B96-7224" 'fat32))
     (mount-point "/boot/efi")
     (type "vfat")))
   %base-file-systems))

 ;; Specify a swap file for the system, which resides on the
 ;; root file system.
 ;; (swap-devices
 ;;   (list
 ;;    (swap-space
 ;;     (target (uuid "9fcd5c51-4026-4fe7-aaf4-497f1206b67f")))))

 ;; Create user `carlosfilho' with `cachorroso'
 ;; as its initial password.
 (users
  (cons*
   (user-account
    (name "carlosfilho")
    (comment "Carlos Alberto Filho")
    (password
     (crypt "cachorroso" "$6$abc"))
    (group "carlosfilho")
    (shell
     (file-append zsh "/bin/zsh"))
    (home-directory "/home/carlosfilho")
    (supplementary-groups
     '("wheel" "netdev" "users" "lp" "audio" "video"
       "nixbld" "docker")))
   %base-user-accounts))
 ;; Add the `carlosfilho' group
 (groups
  (cons*
   (user-group
    (system? #t)
    (name "realtime"))
   (user-group
    (name "carlosfilho"))
   %base-groups))
 ;; This is where we specify system-wide packages.
 (packages
  (append
   (list
    ;; my packages
    git nix binutils coreutils curl htop ranger picom mtools ncurses
    libvterm alacritty stow xterm xrandr arandr thermald autorandr
    xset xhost xss-lock xmodmap dbus nitrogen findutils xsetroot
    mkfontdir xfontsel
    dbus polkit guile-ac-d-bus
    zsh zsh-autosuggestions ;zsh land
    openssh                 ;so that gnome ssh access works
    gpgme                   ;for the symlink from /usr/bin/gpgme-json
    cups foomatic-filters hplip sane-backends ijs ghostscript ;print
    ntp openntpd python-dbus fuse
    ccache                            ;speed up compiles on fast disks
    ;; emacs
    emacs emacs-guix emacs-pcmpl-args emacs-esh-help
    emacs-all-the-icons-dired emacs-magit emacs-ssh-agency
    emacs-dired-hacks emacs-dired-rsync emacs-vterm
    ;; Windows manager
    sbcl stumpwm+slynk
    `(,stumpwm "lib")
    emacs-stumpwm-mode
    sbcl-stumpwm-swm-gaps sbcl-stumpwm-ttf-fonts sbcl-stumpwm-pass
    sbcl-stumpwm-kbd-layouts rofi polybar stumpish
    sbcl-clx-truetype
    ;; Browser
    nyxt icecat qutebrowser ungoogled-chromium youtube-viewer
    youtube-dl emacs-youtube-dl firefox
    ;; Offcie
    libreoffice gimp evince gnucash emacs-helm-pass qtpass
    pass-git-helper keepassxc
    password-store gnupg
    ;; audio and bluetooph stack
    bluez bluez-alsa pulseaudio pipewire pulsemixer gst-libav
    gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly
    ;; Fonts from packages fonts.scm
    ;; sbcl-ttf-fonts
    font-dejavu font-adobe-source-code-pro font-adobe-source-han-sans
    font-adobe-source-sans-pro font-adobe-source-serif-pro
    font-anonymous-pro font-anonymous-pro-minus font-awesome
    font-bitstream-vera font-blackfoundry-inria font-cantarell
    font-cns11643 font-cns11643-swjz font-comic-neue font-culmus
    font-dejavu font-dosis font-dseg font-fantasque-sans font-fira-code
    font-fira-mono font-fira-sans font-fontna-yasashisa-antique
    font-gnu-freefont font-gnu-freefont-ttf font-gnu-unifont font-go
    font-google-material-design-icons font-google-noto
    font-google-roboto font-jetbrains-mono
    font-hack font-hermit font-ibm-plex font-inconsolata font-iosevka
    font-iosevka-aile font-iosevka-etoile font-iosevka-slab
    font-iosevka-term font-iosevka-term-slab font-ipa-mj-mincho
    font-jetbrains-mono font-lato font-liberation
    font-linuxlibertine font-lohit font-meera-inimai font-mononoki
    font-mplus-testflight font-open-dyslexic font-opendyslexic
    font-public-sans font-rachana font-sarasa-gothic font-sil-andika
    font-sil-charis font-sil-gentium font-tamzen font-terminus
    font-tex-gyre font-un font-vazir font-wqy-microhei  font-wqy-zenhei
    ;; lots of fonts from package xorg.scm
    font-adobe100dpi font-adobe75dpi font-cronyx-cyrillic font-dec-misc
    font-isas-misc font-micro-misc font-misc-cyrillic font-util
    font-misc-ethiopic font-misc-misc font-mutt-misc
    font-schumacher-misc font-sony-misc font-sun-misc
    font-screen-cyrillic  font-winitzki-cyrillic font-xfree86-type1
    font-microsoft-arial
    ;; for HTTPS access
    nss-certs
    ;; for user mounts
    gvfs)
   %base-packages))
 ;; Add GNOME and Xfce---we can choose at the log-in screen
 ;; by clicking the gear.  Use the "desktop" services, which
 ;; include the X11 log-in service, networking with
 ;; NetworkManager, and more.
 (services
  (append
   (list
    (service gnome-desktop-service-type)
    ;; Enable JACK to enter realtime mode
    (pam-limits-service
     (list
      (pam-limits-entry "@realtime" 'both 'rtprio 99)
      (pam-limits-entry "@realtime" 'both 'nice -19)
      (pam-limits-entry "@realtime" 'both 'memlock 'unlimited)))
    ;; Enable /usr/bin/env in shell scripts
    (extra-special-file "/usr/bin/env"
                        (file-append coreutils "/bin/env"))
    ;; Enable Docker containers and virtual machines
    (service docker-service-type)
    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")
              (tls-port "16555")))
                                        ; Add udev rules to enable PipeWire use
    (udev-rules-service 'pipewire-add-udev-rules pipewire-0.3)
    ;; Enable the build service for Nix package manager
    (service nix-service-type)
    ;; Enable the bluetooth service
    (bluetooth-service #:auto-enable? #t)
    ;; Enable the print service
    (service cups-service-type
             (cups-configuration
              (web-interface? #t)
              (extensions
               (list cups-filters hplip))))
    ;; Firewall
    (service iptables-service-type
             (iptables-configuration
              (ipv4-rules
               (plain-file "iptables.rules" "*filter
:INPUT ACCEPT
:FORWARD ACCEPT
:OUTPUT ACCEPT
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-port-unreachable
COMMIT
"))
              (ipv6-rules
               (plain-file "ip6tables.rules" "*filter
:INPUT ACCEPT
:FORWARD ACCEPT
:OUTPUT ACCEPT
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp6-port-unreachable
COMMIT
"))))
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout keyboard-layout))))
   %desktop-services))
 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
