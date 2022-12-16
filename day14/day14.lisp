(require :uiop)

(defvar *string* "498,4 -> 498,6 -> 496,6")

(defun parse-coord (s)
  (let ((parts (uiop:split-string s :separator ",")))
    (list (parse-integer (first parts)) (parse-integer (second parts)))))


(defparameter *points* (mapcar #'parse-coord (uiop:split-string *string* :separator "->")))

(format t "~A~%" *points*)

(defvar *lines* ())

(with-open-file (stream (second *posix-argv*)
                        :direction :input
                        :if-does-not-exist :error)
  (loop
    for line = (read-line stream nil)
    while line
    do (push line *lines*)))

(format t "~A~%" *lines*)



;; (defparameter *grid* (make-array '(2 2) :initial-element "."))
;; (setf (aref *grid* 1 1) 1)

;; (dotimes (i (array-dimension *grid* 0))
;;     (dotimes (j (array-dimension *grid* 1))
;;         (format t "~A" (aref *grid* i j)))
;;     (format t "~%"))