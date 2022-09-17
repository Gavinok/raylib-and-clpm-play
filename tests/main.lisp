(defpackage raylib-play/tests/main
  (:use :cl
        :raylib-play
        :rove))
(in-package :raylib-play/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :raylib-play)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
