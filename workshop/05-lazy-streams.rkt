#lang lazy

;; ============================================================
;; Functional Playlist Workshop
;; Step 05 - Lazy Evaluation
;;
;; Goal:
;; Understand lazy evaluation using infinite lists.
;;
;; IMPORTANT:
;; Previous steps used #lang typed/racket.
;; From this point forward we use #lang lazy.
;; ============================================================


;; ------------------------------------------------------------
;; Data model
;; ------------------------------------------------------------

(struct Song
  (title artist genre duration popularity)
  #:transparent)


;; ------------------------------------------------------------
;; Raw data
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


;; Step 01

(define (popular-songs songs min-popularity)
  (filter
   (lambda (song)
     (>= (Song-popularity song)
         min-popularity))
   songs))


;; Step 02

(define (playlist-duration songs)
  (foldl
   (lambda (song total)
     (+ total (Song-duration song)))
   0
   songs))


;; Step 03

(define (songs-by-genre genre songs)
  (filter
   (lambda (song)
     (equal? (Song-genre song)
             genre))
   songs))


;; Step 04
;;
;; This function was previously implemented in Typed Racket
;; using parametric polymorphism.
;;
;; In Lazy Racket we keep the same generic implementation.

(define (first-match predicate values)
  (cond
    [(empty? values)
     #f]

    [(predicate (first values))
     (first values)]

    [else
     (first-match
      predicate
      (rest values))]))


;; ============================================================
;; Step 05 - Lazy evaluation
;; ============================================================


;; ------------------------------------------------------------
;; Infinite sequence
;;
;; This function never reaches an empty list.
;;
;; Lazy Racket evaluates only the portion that is needed.
;; ------------------------------------------------------------

(define (naturals-from number)
  (cons number
        (naturals-from (+ number 1))))


(define natural-numbers
  (naturals-from 1))


;; ------------------------------------------------------------
;; Exercise 05
;;
;; Implement take-lazy.
;;
;; It receives:
;;
;; amount -> maximum number of values to obtain
;; values -> finite or infinite lazy list
;;
;; It must return at most "amount" elements.
;;
;; Requirements:
;;
;; - Use recursion.
;; - Do not use mutation.
;; - It must work with an infinite list.
;; - Stop when amount reaches 0.
;; - Also stop if the input list is empty.
;; ------------------------------------------------------------

(define (take-lazy amount values)

  ;; TODO
  ;;
  ;; Suggested cases:
  ;;
  ;; 1. amount <= 0
  ;; 2. values is empty
  ;; 3. otherwise:
  ;;      keep first
  ;;      continue with rest

  '())


;; ============================================================
;; Tests
;; ============================================================


;; ------------------------------------------------------------
;; Test 1
;; ------------------------------------------------------------

(printf "First 10 natural numbers:\n")

(printf "~a\n\n"
        (!! (take-lazy
             10
             natural-numbers)))


;; Expected:
;;
;; (1 2 3 4 5 6 7 8 9 10)


;; ------------------------------------------------------------
;; Test 2
;;
;; filter is also lazy in #lang lazy.
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


;; Expected:
;;
;; (2 4 6 8 10)


;; ------------------------------------------------------------
;; Test 3
;; ------------------------------------------------------------

(define first-very-popular-song
  (first-match
   (lambda (song)
     (>= (Song-popularity song) 90))
   catalog))


(printf "First song with popularity >= 90:\n")

(printf "~a\n"
        (!! first-very-popular-song))