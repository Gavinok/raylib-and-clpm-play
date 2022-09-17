(uiop:define-package platform
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
  (:export #:default-floor
           #:platform-height
           #:platform-width
           #:platform
           #:+floor-width+))

(in-package :platform)
(defconst +floor-hight+ 600)
(defconst +floor-width+ 2)

(defconstructor Platform
  (height integer)
  (width integer))

(defun default-floor ()
  (Platform (- +floor-hight+ +floor-width+) +floor-width+))
