;; (load "~/.quicklisp/setup.lisp")
(ql:quickload "split-sequence")
(ql:quickload "cl-ppcre")

(require :split-sequence)
(require :cl-ppcre)
;; (require 'cl)


(remove-if-not #'evenp '(1 2 3 4 5 6 7 8 9 10))
(defvar str " coucou   les copains ! ")
(format t str)

;; (defvar splited (remove-if #'equal (split-sequence:SPLIT-SEQUENCE #\Space str)))
(defvar splited (split-sequence:SPLIT-SEQUENCE #\Space str))
(print splited)
(defvar splited_2 (cl-ppcre:split #\Space str))
(print splited_2)

