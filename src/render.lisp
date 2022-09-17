(uiop:define-package render
  (:use :cl :cl-raylib :player )
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
  (:export :render))
(in-package :raylib-play)
