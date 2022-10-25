(defpackage #:clatwork
  (:use :cl))
(in-package :clatwork)

(defparameter *base-url* "https://api.chatwork.com/v2")

(defun string-empty-p (s)
  (or (null s) (string= s "")))

(defun string-not-empty-p (s)
  (not (string-empty-p s)))

(deftype non-empty-string ()
  `(and string (satisfies string-not-empty-p)))

(defclass config ()
  ((token
     :type string
     :initarg :token
     :initform (error "token is empty."))
    (base-url
      :type string
      :initarg :base-url
      :initform (error "base-url is empty."))
    (endpoints
      :type list
      :initarg :endpoints
      :initform ())))

(defmethod initialize-instance :after ((self config) &key)
  (with-slots (token base-url) self
    (assert (typep token 'non-empty-string))
    (assert (typep base-url 'non-empty-string))))

(defgeneric append-endpoints (self more-endpoints))

(defmethod append-endpoints ((self config) more-endpoints)
  (let ((new-instance (cl-mop:deep-copy self)))
    (with-slots (endpoints) self
      (setf (slot-value new-instance 'endpoints) (append endpoints more-endpoints)))
    new-instance))

(defun str (&rest args)
  (with-output-to-string (s)
    (dolist (arg args)
      (princ arg s))))

(defmethod to-uri ((self config))
  (with-slots (base-url endpoints) self
    (format nil "~{~a~^/~}" (cons base-url endpoints))))

(defun clatwork (&key token (base-url *base-url*))
  (make-instance 'config :token token :base-url base-url))

(defclass me (config) ())

(defmacro define-endpoint (name roots lambda-list &body body)
  `(progn
     (defclass ,name ,roots ())
     (defmethod ,(intern (str '/ name)) ((self ,(car roots)) ,@lambda-list)
       (let ((more-endpoints (progn ,@body)))
         (with-slots (token base-url endpoints) self
           (make-instance (quote ,name)
             :token token
             :base-url base-url
             :endpoints (append endpoints more-endpoints)))))))

(define-endpoint me (config) ()
  '("me"))

(define-endpoint my (config) ()
  '("my"))

(define-endpoint status (my) ()
  '("status"))

(define-endpoint tasks (my) ()
  '("tasks"))

(define-endpoint rooms (config) (&optional room-id)
  (let ((room-id (and room-id (str room-id))))
    (apply #'list "rooms" room-id)))
