#lang setup/infotab

(define name "RtMidi")

(define blurb '("RtMidi provides racket bindings for the RtMidi library."))

(define scribblings '(("rtmidi.scrbl" () (net-library))))

;; don't compile the stuff in the contrib subdirectory.
#;(define compile-omit-paths '("contrib"))

