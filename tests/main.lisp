(defpackage clatwork/tests/main
  (:use :cl
        :clatwork
        :rove))
(in-package :clatwork/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :clatwork)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
