(defsystem "raylib-play"
  :version "0.1.0"
  :depends-on (#:serapeum
               #:cl-raylib)
  :components ((:module "src"
                :components
                ((:file "player")
                 (:file "platform")
                 (:file "main")
                 )))
  :description ""
  :in-order-to ((test-op (test-op "raylib-play/tests"))))
