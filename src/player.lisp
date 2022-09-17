(uiop:define-package player
  (:use :cl :cl-raylib)
  (:import-from #:serapeum
                #:->
                #:~>
                #:~>>
                #:defconstructor
                #:defconst
                #:comment
                #:example
                #:op
                #:partial)
  (:export :player
           #:player-width
           #:player-height
           #:player-x
           #:player-y
           #:player-x-speed
           #:player-y-speed
           #:jump
           #:left
           #:copy-player
           #:right
           #:default-player-width
           #:hitbox
           #:render))

(in-package :player)

(defconst +box-height+ 90)
(defconst +box-width+ 90)
(defconst +move-distance+ 10)
(defconst +jump-distance+ 20)
(defconst +jump-speed+ 20)

(defconstructor Player
  (y integer)
  (x integer)
  (y-speed integer)
  (x-speed integer))

(defun default-player-width ()
  +box-width+)

(-> player-width (Player) Integer)
(defun player-width (p)
  (declare (ignore p))
  +box-width+)

(-> player-height (Player) Integer)
(defun player-height (p)
  (declare (ignore p))
  +box-height+)

;;; Player Movement
(-> jump (Player t &optional number) Player)
(defun jump (p floor &optional (jump-distance +move-distance+))
  "Make character jump"
  (copy-player p
               :y-speed (- 0 +jump-speed+)
               :y (- (player-y p) +jump-distance+)))

(EXAMPLE
  (jump (player 10 0 0 0) (platform 10 0)) ;=> (player 10 0 -20 0)
  (jump (player 11 0 0 0) (platform 10 0)) ;=> (player 11 0 0 0)
  )


(-> right (Player &optional number) Player)
(defun right (p &optional (distance +move-distance+))
  "Move character right"
  (copy-player p :x (+ (player-x p) distance)))

(EXAMPLE
  (player-(right (player 10 0 0 0))) ;=> (player 10 20 0 0)
  )

(-> left (Player &optional number) Player)
(defun left (p &optional (distance +move-distance+))
  "Move character left"
  (copy-player p :x (- (player-x p) distance)))

(EXAMPLE
  (left (player 10 0 0 0)) ;=> (player 10 -20 0 0)
  )



