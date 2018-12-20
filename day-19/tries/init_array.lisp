(defvar x)

(setf x (make-array 6))
(print x)
(print (aref x 5))
(setf (aref x 5) "blue")
(print (aref x 5))


(setf x (make-array '(3 3) 
   :initial-contents '((0 1 2 ) (3 4 5) (6 7 8)))
)
(print x)

(setf x (make-array '(2 3 3) 
   :initial-contents '(((0 1 2 ) (3 4 5) (6 7 8)) ((10 11 12 ) (13 14 15) (16 17 18))))
)
(print x)
(print (aref x 1 1 1)) ;; must be 14

