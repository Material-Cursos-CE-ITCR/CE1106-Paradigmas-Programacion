#lang typed/racket

(require racket/stream)

;; ============================================================
;; Functional Playlist Workshop
;; Step 06 - Playlist Generator
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

(: take-stream
   (All (A)
     (-> Integer
         (Streamof A)
         (Listof A))))
(define (take-stream amount values)
  (cond
    [(or (<= amount 0) (stream-empty? values)) '()]
    [else
     (cons (stream-first values)
           (take-stream (sub1 amount)
                        (stream-rest values)))]))

;; Creates playlists of three consecutive songs lazily.
(: candidate-playlists (-> Playlist (Streamof Playlist)))
(define (candidate-playlists songs)
  (if (< (length songs) 3)
      empty-stream
      (stream-cons
       (list (list-ref songs 0)
             (list-ref songs 1)
             (list-ref songs 2))
       (candidate-playlists (rest songs)))))

;; Existing workshop rules for a valid playlist.
(: valid-playlist? (-> Playlist Boolean))
(define (valid-playlist? playlist)
  (and (= (length playlist) 3)
       (<= (playlist-duration playlist) 900)
       (andmap
        (lambda ([song : Song])
          (>= (Song-popularity song) 70))
        playlist)))

;; ------------------------------------------------------------
;; TODO
;; Return the first amount playlists that satisfy valid-playlist?.
;;
;; Requirements:
;; - filter the Stream directly
;; - use take-stream
;; - do not convert all candidates to a list before filtering
;; ------------------------------------------------------------

(: valid-playlists
   (-> (Streamof Playlist)
       Integer
       (Listof Playlist)))
(define (valid-playlists candidates amount)
  '())

(: print-playlist (-> Playlist Void))
(define (print-playlist playlist)
  (displayln (map Song-title playlist))
  (displayln
   (string-append "Duration: "
                  (number->string (playlist-duration playlist))
                  " seconds"))
  (newline))

(define candidates
  (candidate-playlists catalog))

(define recommendations
  (valid-playlists candidates 3))

(displayln "First three valid playlists:")
(for-each print-playlist recommendations)
