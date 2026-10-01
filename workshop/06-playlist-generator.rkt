#lang lazy

;; ============================================================
;; Functional Playlist Workshop
;; Step 06 - Functional Playlist Generator
;;
;; Goal:
;; Integrate:
;;
;; - Pure functions
;; - map
;; - filter
;; - fold
;; - generic functions
;; - lazy evaluation
;;
;; The candidate playlists are generated lazily.
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
;; Convert raw rows to Song
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

(define (playlist-duration playlist)
  (foldl
   (lambda (song total)
     (+ total
        (Song-duration song)))
   0
   playlist))


;; Step 03

(define (songs-by-genre genre songs)
  (filter
   (lambda (song)
     (equal?
      (Song-genre song)
      genre))
   songs))


;; Step 04

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


;; Step 05

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
;; Playlist generation
;; ============================================================


;; ------------------------------------------------------------
;; combinations
;;
;; Generates all combinations of "amount" elements.
;;
;; Students do NOT need to implement this function.
;;
;; Under #lang lazy, combinations are produced only when they
;; are required by the rest of the program.
;; ------------------------------------------------------------

(define (combinations amount values)

  (cond

    [(= amount 0)
     (list '())]

    [(empty? values)
     '()]

    [else

     (append

      ;; Include the first element

      (map
       (lambda (combination)
         (cons
          (first values)
          combination))

       (combinations
        (- amount 1)
        (rest values)))


      ;; Ignore the first element

      (combinations
       amount
       (rest values)))]))


;; ------------------------------------------------------------
;; Candidate playlists
;;
;; Every candidate has exactly 3 songs.
;; ------------------------------------------------------------

(define candidate-playlists
  (combinations 3 catalog))


;; ============================================================
;; Playlist validation
;; ============================================================


;; ------------------------------------------------------------
;; A valid playlist must:
;;
;; 1. Have total duration <= 900 seconds.
;; 2. Every song must have popularity >= 80.
;;
;; Additional conditions will be added in the quiz.
;; ------------------------------------------------------------

(define (valid-playlist? playlist)

  (and

   (<= (playlist-duration playlist)
       900)

   (andmap
    (lambda (song)
      (>= (Song-popularity song)
          80))
    playlist)))


;; ============================================================
;; Exercise 06
;; ============================================================


;; ------------------------------------------------------------
;; Implement valid-playlists.
;;
;; Parameters:
;;
;; candidates -> lazy list of candidate playlists
;; amount     -> maximum number of results
;;
;; Return:
;;
;; A list containing the first "amount" playlists that satisfy
;; valid-playlist?.
;;
;; Requirements:
;;
;; - Use filter.
;; - Use take-lazy.
;; - Do not convert all candidates into a strict list first.
;; - Do not use mutation.
;;
;; Think of the pipeline:
;;
;; candidates
;;      |
;;      v
;; filter
;;      |
;;      v
;; take-lazy
;;      |
;;      v
;; result
;; ------------------------------------------------------------

(define (valid-playlists candidates amount)

  ;; TODO

  '())


;; ============================================================
;; Display helpers
;; ============================================================


(define (song->summary song)

  (list
   (Song-title song)
   (Song-artist song)
   (Song-popularity song)))


(define (playlist->summary playlist)

  (list
   'songs
   (map song->summary playlist)

   'duration
   (playlist-duration playlist)))


;; ============================================================
;; Application
;; ============================================================


(define recommendations
  (valid-playlists
   candidate-playlists
   5))


(printf "First 5 valid playlists:\n\n")

(printf "~a\n"
        (!! (map
             playlist->summary
             recommendations)))


;; ============================================================
;; Expected behavior
;; ============================================================

;; The program should return at most 5 playlists.
;;
;; Every returned playlist must:
;;
;; - contain exactly 3 songs
;; - have duration <= 900 seconds
;; - contain only songs with popularity >= 80