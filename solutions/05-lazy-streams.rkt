#lang lazy

;; ============================================================
;; Functional Playlist Workshop
;; Step 05 - Lazy Evaluation
;;
;; Goal:
;; Understand lazy evaluation using an infinite list.
;;
;; IMPORTANT:
;; Previous steps used #lang typed/racket.
;; From this point forward we use #lang lazy.
;;
;; Because Lazy Racket is not Typed Racket, type annotations
;; such as (: ...), All, Listof, Option, etc. are not used here.
;; ============================================================


;; ------------------------------------------------------------
;; Data model
;; ------------------------------------------------------------

(struct Song
  (title artist genre duration popularity)
  #:transparent)


;; ------------------------------------------------------------
;; Raw data
;;
;; Assume this information has already been read from a file.
;; Format:
;;
;; title, artist, genre, duration-in-seconds, popularity
;; ------------------------------------------------------------

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


;; ------------------------------------------------------------
;; Convert raw data into Song structures
;; ------------------------------------------------------------

(define (row->song row)
  (Song
   (list-ref row 0)
   (list-ref row 1)
   (list-ref row 2)
   (list-ref row 3)
   (list-ref row 4)))


(define catalog
  (map row->song raw-data))


;; ============================================================
;; Previous exercises - already solved
;; ============================================================


;; ------------------------------------------------------------
;; Step 01 - filter
;; ------------------------------------------------------------

(define (popular-songs songs min-popularity)
  (filter
   (lambda (song)
     (>= (Song-popularity song)
         min-popularity))
   songs))


;; ------------------------------------------------------------
;; Step 02 - fold
;; ------------------------------------------------------------

(define (playlist-duration songs)
  (foldl
   (lambda (song total)
     (+ total (Song-duration song)))
   0
   songs))


;; ------------------------------------------------------------
;; Step 03 - filtering by genre
;; ------------------------------------------------------------

(define (songs-by-genre genre songs)
  (filter
   (lambda (song)
     (equal? (Song-genre song)
             genre))
   songs))


;; ------------------------------------------------------------
;; Step 04 - generic first match
;;
;; In the previous Typed Racket exercise this function used
;; parametric polymorphism with All (A).
;;
;; The implementation remains generic, but Lazy Racket does
;; not use the Typed Racket annotation.
;; ------------------------------------------------------------

(define (first-match predicate values)
  (cond
    [(empty? values) #f]

    [(predicate (first values))
     (first values)]

    [else
     (first-match predicate
                  (rest values))]))


;; ============================================================
;; Step 05 - Lazy evaluation
;; ============================================================


;; ------------------------------------------------------------
;; Infinite sequence
;;
;; This function NEVER reaches an empty list.
;;
;; In strict evaluation:
;;
;; (naturals-from 1)
;;
;; would continue forever while trying to create the list.
;;
;; In Lazy Racket, the rest of the list is evaluated only
;; when it is required.
;; ------------------------------------------------------------

(define (naturals-from number)
  (cons number
        (naturals-from (+ number 1))))


(define natural-numbers
  (naturals-from 1))


;; ------------------------------------------------------------
;; Exercise / Solution
;;
;; Return at most "amount" elements from a lazy list.
;;
;; This function also works with finite lists.
;; ------------------------------------------------------------

(define (take-lazy amount values)
  (cond
    [(<= amount 0)
     '()]

    [(empty? values)
     '()]

    [else
     (cons
      (first values)

      (take-lazy
       (- amount 1)
       (rest values)))]))


;; ============================================================
;; Tests
;; ============================================================


;; ------------------------------------------------------------
;; Test 1
;;
;; natural-numbers is infinite, but only 10 values are needed.
;;
;; !! recursively forces the resulting lazy structure so that
;; it can be displayed completely.
;; ------------------------------------------------------------

(printf "First 10 natural numbers:\n")

(printf "~a\n\n"
        (!! (take-lazy
             10
             natural-numbers)))


;; ------------------------------------------------------------
;; Test 2
;;
;; Lazy filter over an infinite list.
;; ------------------------------------------------------------

(define even-numbers
  (filter
   (lambda (number)
     (= (remainder number 2) 0))
   natural-numbers))


(printf "First 5 even numbers:\n")

(printf "~a\n\n"
        (!! (take-lazy
             5
             even-numbers)))


;; ------------------------------------------------------------
;; Test 3
;;
;; Our generic function from the previous exercise still works.
;; ------------------------------------------------------------

(define first-very-popular-song
  (first-match
   (lambda (song)
     (>= (Song-popularity song) 90))
   catalog))


(printf "First song with popularity >= 90:\n")

(printf "~a\n"
        (!! first-very-popular-song))


;; ============================================================
;; Expected output
;; ============================================================

;; First 10 natural numbers:
;; (1 2 3 4 5 6 7 8 9 10)
;;
;; First 5 even numbers:
;; (2 4 6 8 10)
;;
;; First song with popularity >= 90:
;; #(struct:Song Creep Radiohead rock 238 91)