#lang scribble/manual

@title{RtMidi}

This package provides Racket bindings for the RtMidi package. It is
currently undocmented, this file notwithstanding.

@defmodule[rtmidi]{ }

Some stubs:

@defproc[(make-rtmidi-in) rtmidi-out?]{
 ...}

@defproc[(make-rtmidi-out) rtmidi-out?]{ ...}

@defproc[(rtmidi-ports [in rtmidi-in/out?]) (listof string?)]{ ... }

@defproc[(rtmidi-open-port [in-or-out rtmidi-in/out?] [idx nat-or-false?]) void?]{ ... }

@defproc[(rtmidi-close-port [in-or-out rtmidi-in/out?]) void?]{ ...}

@defproc[(rtmidi-send-message [out rtmidi-out?] [msg (listof byte?)]) void?]{ ... }

@section{Example}

Here's a file that uses these functions:

@#reader scribble/comment-reader
 (racketmod 
  racket
  (require rtmidi)
 
  ;; Create RtMidiIn and RtMidiOut
  (define in (make-rtmidi-in))
  (define out (make-rtmidi-out)) 
 
  ;; List input and output ports
  (define in-ports (rtmidi-ports in))
  (printf "Input ports: ~a~n" in-ports) 
 
  (define out-ports (rtmidi-ports out))
  (printf "Output ports: ~a~n" out-ports)
 
  ;; Open the first input and output port, if any
 
  (match in-ports
    [(cons a-port other-ports) (rtmidi-open-port in 0)]
    [other (printf (current-error-port) "no input ports\n")])

  (match out-ports
    [(cons a-port other-ports) (rtmidi-open-port out 0)]
    [other (printf (current-error-port) "no output ports\n")])

  ;; Send a note
  (rtmidi-send-message out (list #b10010000 65 127))
  (sleep 0.2)
  (rtmidi-send-message out (list #b10000000 65 127))

  ;; Read incoming messages until break
  (let loop ()
    (pretty-print (sync in))
    (loop)))

