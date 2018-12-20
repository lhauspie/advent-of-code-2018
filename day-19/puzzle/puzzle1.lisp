(ql:quickload "cl-ppcre")
(require :cl-ppcre)


(defun affectation (a b) a)
(defun equals_op (a b) (if (= a b) 1 0))
(defun greater_than_op (a b) (if (> a b) 1 0))


(defun opri (op instruction registers)
    (setf 
        (aref registers (aref instruction 3)) ;; where to put the result
        (funcall op (aref registers (aref instruction 1)) (aref instruction 2)) ;; Calculation of the result
    )
)

(defun opir (op instruction registers)
    (setf 
        (aref registers (aref instruction 3)) ;; where to put the result
        (funcall op (aref instruction 1) (aref registers (aref instruction 2))) ;; Calculation of the result
    )
)

(defun oprr (op instruction registers)
    (setf 
        (aref registers (aref instruction 3)) ;; where to put the result
        (funcall op (aref registers (aref instruction 1)) (aref registers (aref instruction 2))) ;; Calculation of the result
    )
)

(defun opii (op instruction registers)
    (setf 
        (aref registers (aref instruction 3)) ;; where to put the result
        (funcall op (aref instruction 1) (aref instruction 2)) ;; Calculation of the result
    )
)

(defun _addi (instruction registers) (opri #'+ instruction registers))
(defun _addr (instruction registers) (oprr #'+ instruction registers))
(defun _muli (instruction registers) (opri #'* instruction registers))
(defun _mulr (instruction registers) (oprr #'* instruction registers))
(defun _seti (instruction registers) (opii #'affectation instruction registers))
(defun _setr (instruction registers) (opri #'affectation instruction registers))
(defun _eqrr (instruction registers) (oprr #'equals_op  instruction registers))
(defun _gtrr (instruction registers) (oprr #'greater_than_op  instruction registers))


(defun opcode_to_function (opcode)
    (cond
        ((string= opcode "addi") (lambda (instruction registers) (_addi instruction registers)))
        ((string= opcode "addr") (lambda (instruction registers) (_addr instruction registers)))
        ((string= opcode "muli") (lambda (instruction registers) (_muli instruction registers)))
        ((string= opcode "mulr") (lambda (instruction registers) (_mulr instruction registers)))
        ((string= opcode "seti") (lambda (instruction registers) (_seti instruction registers)))
        ((string= opcode "setr") (lambda (instruction registers) (_setr instruction registers)))
        ((string= opcode "eqrr") (lambda (instruction registers) (_eqrr instruction registers)))
        ((string= opcode "gtrr") (lambda (instruction registers) (_gtrr instruction registers)))
        (T (print "Instruction not implemented"))
    )
)

(defun extract (line)
    (let 
        ( ;; variables declaration
            (extracted (make-array 4 :initial-contents '("" 0 0 0)))
            (splited_line (cl-ppcre:split #\Space line))
        )
        (loop for i from 0 to 3 do
            (if (= i 0)
                (setf (aref extracted i) (opcode_to_function (nth i splited_line))) ;; the first element has to stay a string
                (setf (aref extracted i) (parse-integer (nth i splited_line))) ;; all other elements have to become numbers
            )
        )
        extracted ;; return statement
    )
)

(defun execute_instruction (instruction registers)
    (funcall (aref instruction 0) instruction registers)
)




(defvar registers (make-array 6))

;; (execute_instruction (extract "addi 4 16 4") registers)
;; (print "addi") (print registers) ;; #(0 0 0 0 16 0)

;; (execute_instruction (extract "seti 4 16 5") registers)
;; (print "seti") (print registers) ;; #(0 0 0 0 16 4)

;; (execute_instruction (extract "seti 5 0 0") registers)
;; (print "seti") (print registers) ;; #(5 0 0 0 16 4)

;; (execute_instruction (extract "eqrr 0 1 1") registers)
;; (print "eqrr") (print registers) ;; #(5 0 0 0 16 4)

;; (execute_instruction (extract "eqrr 1 1 1") registers)
;; (print "eqrr") (print registers) ;; #(5 1 0 0 16 4)





(defvar file_content 
    (with-open-file (stream "input.txt")
        (loop for line = (read-line stream nil 'foo)
            until (eq line 'foo)
            collect line
        )
    )
)

;; parsing the first line to get the instruction_pointer_index
(defvar instruction_pointer_index (parse-integer (nth 1 (cl-ppcre:split #\Space (nth 0 file_content)))))

(defvar instructions
    ;; ignoring the first line to build the instructions set
    (loop for i from 1 to (- (list-length file_content) 1)
        collect (extract (nth i file_content))
    )
)
(defvar nb_instructions (list-length instructions))



;; Resolve first Puzzle
(setf registers (make-array 6))
(defvar instruction_pointer 0)
(terpri)
;; while the `instruction_pointer` is lower than the number of instructions
(loop while (< instruction_pointer nb_instructions) do
    (execute_instruction (nth instruction_pointer instructions) registers)
    (incf (aref registers instruction_pointer_index)) ;; point to next instruction
    (setf instruction_pointer (aref registers instruction_pointer_index))
)
(terpri) (terpri)
(print registers)
(print (aref registers 0))




;; Resolve second Puzzle
(setf registers (make-array 6))
(setf (aref registers 0) 1)
(setf instruction_pointer 0)
(terpri)
(loop for i from 0 to 21 do
    (execute_instruction (nth instruction_pointer instructions) registers)
    (incf (aref registers instruction_pointer_index)) ;; point to next instruction
    (setf instruction_pointer (aref registers instruction_pointer_index))
    (print registers)
)
(terpri) (terpri)
(print registers)
(print (aref registers 5))



;; resolving the second puzzle by processing all instructions until the end will be too long
;; by retro engineering the process, it appears to be about summing all divisors of register[5]

;; NO TIME TO RESOLVE THIS BY CODING SO I USED THIS SITE : https://www.dcode.fr/divisors-list-number
;;      Enter the register[5] (=10551329) in the field
;;      Select the radio button `Calculate sum of divisors (including N)`
;;      And then hit CALCULATE ==> 10628484