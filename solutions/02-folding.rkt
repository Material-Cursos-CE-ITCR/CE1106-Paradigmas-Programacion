#lang racket

;; ============================================================
;; Functional Playlist Workshop
;; Step 02 - Folding
;; ============================================================

(struct Song (title artist genre duration popularity)
  #:transparent)

(define raw-data
  '(("Everlong" "Foo Fighters" rock 250 86)
    ("Creep" "Radiohead" rock 238 91)
    ("Take Five" "Dave Brubeck" jazz 324 72)
    ("Blinding Lights" "The Weeknd" pop 200 95)
    ("Come As You Are" "Nirvana" rock 219 88)
    ("Billie Jean" "Michael Jackson" pop 294 93)
    ("So What" "Miles Davis" jazz 545 70)
    ("Dreams" "Fleetwood Mac" rock 257 89)
    ("Take On Me" "a-ha" pop 225 90)
    ("Master of Puppets" "Metallica" metal 515 84)
    ("Smells Like Teen Spirit" "Nirvana" rock 301 94)
    ("Back in Black" "AC/DC" rock 255 92)
    ("Hysteria" "Muse" rock 227 82)
    ("Levitating" "Dua Lipa" pop 203 87)
    ("The Trooper" "Iron Maiden" metal 252 78)))

(define (row->song row)
  (apply Song row))

(define catalog
  (map row->song raw-data))

;; Solution from Step 01.
(define (popular-songs songs min-popularity)
  (filter
   (lambda (song)
     (>= (Song-popularity song) min-popularity))
   songs))

;; ------------------------------------------------------------
;; TODO
;; Return the total duration, in seconds, of all songs.
;;
;; Requirement:
;; - use foldl or foldr
;; - do not use explicit recursion
;; ------------------------------------------------------------

(define (playlist-duration songs)
  (foldl
   (lambda (song total)
     (+ total (Song-duration song)))
   0
   songs))

(define sample-playlist
  (take catalog 3))

(displayln "Sample playlist:")
(displayln (map Song-title sample-playlist))
(displayln "Total duration:")
(displayln (playlist-duration sample-playlist))

;; Expected total duration:
;; 812
