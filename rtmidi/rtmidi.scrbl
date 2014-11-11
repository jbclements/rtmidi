#lang scribble/manual

@title{RtMidi}

This package provides Racket bindings for the RtMidi package. It is
currently undocmented, this file notwithstanding.

@section{Installation}

This package is not self-contained. It depends on the RtMidi package, and 
also requires you to compile a dynamic library used to connect to the 
RtMidi code.

At this point, this means that installing this package will require you
to locate the package directory where this package is installed. 

The best way to do this is probably to install the package using 
@tt{raco pkg install} or the package manager, and then to evaluate

@racketblock[(collection-path "rtmidi")]

to see where the directory lives.

Once you've located the collection directory, you'll need to extract
http://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-2.1.0.tar.gz to the
collection directory. Then run `make $PLATFORM`, where `PLATFORM` is one of `linux`,
`macosx`, or `windows`.

The wrapper is C++98 and should compile with any modern C++ compiler.

I haven't tried the Windows build with this Makefile; you might need to make
some adjustments.


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

