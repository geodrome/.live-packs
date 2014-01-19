; Use live-use-packs to control which built-in packs should be loaded
(live-use-packs '(live/foundation-pack     
                  live/colour-pack       ; This built-in pack MUST be disabled if you want to use 3rd party color theme pack
                  live/clojure-pack
                  live/lang-pack
                  live/power-pack))
; Use live-add-packs to load custom packs
(live-add-packs '( ~/.live-packs/evilmode-pack
                   ~/.live-packs/ace-jump-buffer-pack
                   ;~/.live-packs/solarized-pack
                   ;~/.live-packs/evil-tabs-pack
                   ~/.live-packs/geo-pack))