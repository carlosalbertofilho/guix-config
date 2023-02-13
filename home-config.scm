;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home) (gnu packages))

(home-environment
  (packages
    (map specification->package
         (list "telegram-desktop"
               "ungoogled-chromium"
               "font-gnu-freefont")))
  (services (list)))
