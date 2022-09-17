(uiop:define-package raylib-play
  (:use :cl :cl-raylib :player :platform)
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
  (:import-from #:player
                #:+box-height+
                #:+box-width+))
(in-package :raylib-play)

(defvar *player* nil)
(defvar *show-hitbox* nil)

;;; Rendering
(defmethod render ((p Platform))
  (draw-rectangle 0
                  (platform-height p)
                  (get-screen-width)
                  (platform-width p)
                  +brown+))

(defparameter *player-color* +red+)
(defmethod render ((p Player))
  (draw-rectangle (player-x p)
                  (player-y p)
                  +box-width+
                  +box-height+
                  *player-color*))

;;; Hitboxes
(defun platform-thickness () +floor-width+)

(defmethod hitbox ((p Player))
  (make-rectangle  :x (player-x p)
                   :y (player-y p)
                   :width (player-width p)
                   :height (player-width p)))

(defmethod hitbox ((p Platform))
  (make-rectangle  :x 0
                   :y (platform-height p)
                   :width (get-screen-width)
                   :height (platform-thickness)))

(-> maybe-jump (Player Platform) Player)
(defun maybe-jump (p floor)
  "Updates the characters speed but does not attempt to actually move the character"
  (if (hitting-floor-p p floor)
      (jump p floor)
      p))

(-> hitting-floor-p (Player Platform) Boolean)
(defun hitting-floor-p (p f)
  (or (>= (player-y p)
          (- (platform-height f)
             (player-height p)))
      (funcall (collides-with p) f)))

(-> apply-gravity (Player Platform) Player)
(defun apply-gravity (p floor)
  (let ((yspeed (player-y-speed p)))
    (if (hitting-floor-p p floor)
        (copy-player p :y-speed 0
                       :y (- (platform-height floor) (player-height p)))
        (copy-player p :y-speed (+ yspeed 1)
                       :y (+ (player-y p) yspeed)))))

(-> apply-x-controls (Player) Player)
(defun apply-x-controls (p)
  (cond
    ((is-key-down +key-l+) (right p))
    ((is-key-down +key-h+) (left p))
    (t p)))

(-> apply-y-controls (Player Platform) Player)
(defun apply-y-controls (p floor)
  (or (when (is-key-down +key-k+) (maybe-jump p floor))
      p))

(-> collides-with (Player) (-> (T) Boolean))
(defun collides-with (obj)
  (let ((hb (hitbox obj)))
    (lambda (other)
      (check-collision-recs hb (hitbox other)))))

(defun reset-player! ()
  (setf *player*
        (Player 0
                (- (- (get-screen-width) (default-player-width)) 200)
                0 0)))


(defun maybe-update-player (player enemies platforms)
  "Determin if the new updated position will cause an unwanted collision
if so manage the players position"
  (cond
    ((some (collides-with player) enemies) (reset-player!))
    ((some (partial #'hitting-floor-p player) platforms)  player)
    ;; Ensure boundries of screen are enforced
    ((> (player-x player) (- (get-screen-width) (player-width player)))
     *player*)
    ((< (player-x player) 0) *player*)
    (t player)))

(defparameter *pose* 0)
(defun next-pose ()
  (incf *pose*))

(defmethod render ((p Null))
  (error 'simple-error "trying to render nil"))

(defun game-loop (world)
  (let* ((player (or *player*
                     (reset-player!)))
         (floor (platform (- (get-screen-height) 10) 10)
                ;; (default-floor)
                )
         (sprite (load-texture
                  "craftpix-net-647526-free-3-cyberpunk-characters-pixel-art/2 Punk/Punk_run.png"))
         (platforms (list floor
                          ;; Platform for the player to jump from
                          (platform (- (get-screen-height) 50) 10)))
         (enemies (list (player 400 10 0 0)
                        (player 400 10 0 0)
                        (player 400 500 0 0))))
    ;; TODO clean this up with a macro or something
    (setf *player* (~> player
                       apply-x-controls
                       (maybe-update-player enemies platforms)
                       (apply-y-controls floor)
                       ;; (maybe-update-player enemies platforms)
                       (apply-gravity floor)
                       (maybe-update-player enemies platforms)))
    (let* ((pose-offset (/ (texture-width sprite) 6))
           (src (make-rectangle :x (float (+ 0.0 (* (next-pose) pose-offset)))
                                :y 0.0
                                :width pose-offset
                                :height (texture-height sprite)))
           (dest (make-rectangle :x (player-x *player*)
                                 :y (player-y *player*)
                                 :width (player-width *player*)
                                 :height  (player-height *player*))))
      (draw-texture-pro sprite src dest (make-vector2 :x 0.0
                                                      ;; (float (/ (get-screen-width) 2))
                                                      :y 0.0
                                                      ;; (float (/ (get-screen-height) 2))
                                                      )
                        0.0 +white+))

    ;; (render *player*)
    (let ((*player-color* +blue+))
      (dolist (en enemies)
        (render en)))
    (dolist (en platforms)
      (render en))
    (render floor)))


;; blah blah blah.
(defun main ()
  (let ((screen-width 800)
        (screen-height 450))
    (with-window (screen-width
                  screen-height
                  "raylib [core] example - generate random values")
      (set-target-fps 25) ; Set our game to run at 60 FPS
      (loop
        with world = nil
        until (window-should-close) ; dectect window close button or ESC key
        do (with-drawing
             (clear-background +raywhite+)
             (setf world (game-loop world)))))))
(main)
