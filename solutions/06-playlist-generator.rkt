#lang lazy

;; ============================================================
;; Functional Playlist Workshop
;; Step 06 - Functional Playlist Generator
;;
;; Goal:
;; Integrate the concepts from the workshop:
;;
;; - Pure functions
;; - map
;; - filter
;; - fold
;; - Generic functions
;; - Lazy evaluation
;;
;; Candidate playlists are generated lazily.
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
;; Simulates information already read from a file.
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
;; Convert raw rows to Song structures
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
;; Step 01
;; ------------------------------------------------------------

(define (popular-songs songs min-popularity)
  (filter
   (lambda (song)
     (>= (Song-popularity song)
         min-popularity))
   songs))


;; ------------------------------------------------------------
;; Step 02
;; ------------------------------------------------------------

(define (playlist-duration playlist)
  (foldl
   (lambda (song total)
     (+ total
        (Song-duration song)))
   0
   playlist))


;; ------------------------------------------------------------
;; Step 03
;; ------------------------------------------------------------

(define (songs-by-genre genre songs)
  (filter
   (lambda (song)
     (equal?
      (Song-genre song)
      genre))
   songs))


;; ------------------------------------------------------------
;; Step 04
;; ------------------------------------------------------------

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


;; ------------------------------------------------------------
;; Step 05
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
;; Playlist generation
;; ============================================================


;; ------------------------------------------------------------
;; combinations
;;
;; Generates every combination of K elements from a list.
;;
;; IMPORTANT:
;;
;; Students do NOT need to implement this function.
;;
;; With #lang lazy, the complete collection of combinations
;; does not need to be constructed immediately.
;;
;; Example:
;;
;; (combinations 2 '(A B C))
;;
;; =>
;;
;; ((A B)
;;  (A C)
;;  (B C))
;; ------------------------------------------------------------

(define (combinations amount values)

  (cond

    ;; One way to choose zero elements:
    ;; choose nothing.
    [(= amount 0)
     (list '())]

    ;; Cannot choose elements from an empty list.
    [(empty? values)
     '()]

    [else

     (append

      ;; ------------------------------------------------------
      ;; Option 1:
      ;; Include the first element.
      ;; ------------------------------------------------------

      (map
       (lambda (combination)
         (cons
          (first values)
          combination))

       (combinations
        (- amount 1)
        (rest values)))


      ;; ------------------------------------------------------
      ;; Option 2:
      ;; Do not include the first element.
      ;; ------------------------------------------------------

      (combinations
       amount
       (rest values)))]))


;; ------------------------------------------------------------
;; Generate playlists containing exactly 3 songs.
;;
;; Because the language is lazy, candidate-playlists behaves
;; as a lazy sequence of combinations.
;; ------------------------------------------------------------

(define candidate-playlists
  (combinations 3 catalog))


;; ============================================================
;; Playlist validation
;; ============================================================


;; ------------------------------------------------------------
;; A valid playlist must:
;;
;; 1. Have a duration <= 15 minutes (900 seconds)
;; 2. Every song must have popularity >= 80
;;
;; The quiz will later ADD new conditions.
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
;; Step 06 - Main function
;; ============================================================


;; ------------------------------------------------------------
;; valid-playlists
;;
;; Receives:
;;
;; candidates -> lazy collection of candidate playlists
;; amount     -> maximum number of results wanted
;;
;; Returns the first "amount" valid playlists.
;;
;; Notice the functional pipeline:
;;
;; candidates
;;      |
;;      v
;; filter valid-playlist?
;;      |
;;      v
;; take-lazy amount
;;      |
;;      v
;; result
;; ------------------------------------------------------------

(define (valid-playlists candidates amount)

  (take-lazy
   amount

   (filter
    valid-playlist?
    candidates)))


;; ============================================================
;; Helper functions for displaying the result
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
             