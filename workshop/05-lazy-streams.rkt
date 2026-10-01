#lang typed/racket

(require racket/stream)

;; ============================================================
;; Functional Playlist Workshop
;; Step 05 - Lazy Streams
;; ============================================================

(struct Song
  ([title : String]
   [artist : String]
   [genre : Symbol]
   [duration : Integer]
   [popularity : Integer])
  #:transparent)

(define-type Playlist (Listof Song))

(: catalog Playlist)
(define catalog
  (list
   (Song "Everlong" "Foo Fighters" 'rock 250 86)
   (Song "Creep" "Radiohead" 'rock 238 91)
   (Song "Take Five" "Dave Brubeck" 'jazz 324 72)
   (Song "Blinding Lights" "The Weeknd" 'pop 200 95)
   (Song "Come As You Are" "Nirvana" 'rock 219 88)
   (Song "Billie Jean" "Michael Jackson" 'pop 294 93)
   (Song "So What" "Miles Davis" 'jazz 545 70)
   (Song "Dreams" "Fleetwood Mac" 'rock 257 89)
   (Song "Take On Me" "a-ha" 'pop 225 90)
   (Song "Master of Puppets" "Metallica" 'metal 515 84)
   (Song "Smells Like Teen Spirit" "Nirvana" 'rock 301 94)
   (Song "Back in Black" "AC/DC" 'rock 255 92)
   (Song "Hysteria" "Muse" 'rock 227 82)
   (Song "Levitating" "Dua Lipa" 'pop 203 87)
   (Song "The Trooper" "Iron Maiden" 'metal 252 78)))

(: popular-songs (-> Playlist Integer Playlist))
(define (popular-songs songs min-popularity)
  (filter
   (lambda ([song : Song])
     (>= (Song-popularity song) min-popularity))
   songs))

(: playlist-duration (-> Playlist Integer))
(define (playlist-duration songs)
  (foldl
   (lambda ([song : Song] [total : Integer])
     (+ total (Song-duration song)))
   0
   songs))

(: songs-by-genre (-> Symbol Playlist Playlist))
(define (songs-by-genre genre songs)
  (filter
   (lambda ([song : Song])
     (eq? (Song-genre song) genre))
   songs))

(: first-match
   (All (A)
     (-> (-> A Boolean)
         (Listof A)
         (U False A))))
(define (first-match predicate values)
  (cond
    [(empty? values) #f]
    [(predicate (first values)) (first values)]
    [else (first-match predicate (rest values))]))

;; Infinite stream: start, start + 1, start + 2, ...
(: naturals-from (-> Integer (Streamof Integer)))
(define (naturals-from start)
  (stream-cons start
               (naturals-from (add1 start))))

;; ------------------------------------------------------------
;; TODO
;; Return the first amount elements of a stream as a list.
;;
;; Requirements:
;; - preserve parametric polymorphism
;; - consume only the requested portion of the stream
;; ------------------------------------------------------------

(: take-stream
   (All (A)
     (-> Integer
         (Streamof A)
         (Listof A))))
(define (take-stream amount values)
  '())

(define natural-numbers
  (naturals-from 1))

(displayln "First five natural numbers:")
(displayln (take-stream 5 natural-numbers))

(displayln "First three songs from a stream:")
(displayln
 (map Song-title
      (take-stream 3 (sequence->stream catalog))))

;; Expected:
;; (1 2 3 4 5)
;; (Everlong Creep Take Five)
