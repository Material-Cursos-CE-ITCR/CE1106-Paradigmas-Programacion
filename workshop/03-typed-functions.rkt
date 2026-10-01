#lang typed/racket

;; ============================================================
;; Functional Playlist Workshop
;; Step 03 - Typed Functions
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

;; ------------------------------------------------------------
;; TODO
;; Return only songs whose genre equals the requested genre.
;;
;; The type signature is already provided.
;; ------------------------------------------------------------

(: songs-by-genre (-> Symbol Playlist Playlist))
(define (songs-by-genre genre songs)
  '())

(displayln "Rock songs:")
(displayln
 (map Song-title
      (songs-by-genre 'rock catalog)))

;; Expected:
;; (Everlong Creep Come As You Are Dreams
;;  Smells Like Teen Spirit Back in Black Hysteria)
