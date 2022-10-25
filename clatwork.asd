(ql:quickload
  '("alexandria"
     "cl-ppcre"
     "cl-mop"
     "arrows"
     "quri"
     "dexador"
     "cl-json"))

(asdf:defsystem "clatwork"
  :version "0.1.0"
  :author "kat0limi"
  :license ""
  :depends-on ("alexandria"
               "cl-ppcre"
               "cl-mop"
               "arrows"
               "quri"
               "dexador"
               "cl-json")
  :components ((:module "src"
                :components
                ((:file "clatwork"))))
  :description "")

(asdf:defsystem "clatwork/tests"
  :author "kat0limi"
  :license ""
  :depends-on ("clatwork"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for clatwork")
  ;; :perform (test-op (op c) (symbol-call :rove :run c)))
