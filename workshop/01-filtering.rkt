#lang racket

;; ============================================================
;; Functional Playlist Workshop
;; Step 01 - Filtering
;; ============================================================

(struct Song (title artist genre duration popularity)
  #:transparent)

;; Simulates information already read from a file.
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
  (Song (list-ref row 0)
        (list-ref row 1)
        (list-ref row 2)
        (list-ref row 3)
        (list-ref row 4)))

(define catalog
  (map row->song raw-data))

(define (song-title song)
  (Song-title song))

;; ------------------------------------------------------------
;; TODO
;; Return a new list containing only songs whose popularity is
;; greater than or equal to min-popularity.
;;
;; Requirements:
;; - use filter
;; - use lambda
;; - do not use recursion
;; ------------------------------------------------------------

(define (popular-songs songs min-popularity)
  '())

(define result
  (popular-songs catalog 90))

(displayln "Songs with popularity >= 90:")
(displayln (map song-title result))

;; Expected:
;; (Creep Blinding Lights Billie Jean Take On Me
;;  Smells Like Teen Spirit Back in Black)
