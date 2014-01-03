(defpackage :nlopt-ffi (:use :cl :sb-alien))
(in-package :nlopt-ffi)

(declaim (optimize (debug 3) (safety 3) (speed 0)))

;; load the ffi file that has been generated using ffigen4 (which is a
;; gcc 4.0 that can parse headers and outputs s-expressions)
(eval-when (:compile-toplevel :execute :load-toplevel)
 (defparameter *nlopt-ffi*
   (with-open-file (f "nlopt.ffi")
     (loop for l = (read f nil nil) while l collect l))))

(eval-when (:execute :compile-toplevel :load-toplevel)
 (define-condition ffi-doesnt-support-long-float () ())

 (defun convert-ffi-type-to-alien (ffi-type &key (struct t))
   (if (consp ffi-type)
       (if (member (car ffi-type) '(int long unsigned-long float double unsigned unsigned-short
				    char unsigned-char short void))
	   (car ffi-type)
	   (case (car ffi-type)
	     (signed-char '(signed 8))
	     (long-long '(signed 64))
	     (unsigned-long-long '(unsigned 64))
	     (long-double ;; i'm not sure what to do about functions with long double arguments
	      (error 'ffi-doesnt-support-long-float))
	     (pointer `(* ,(let* ((next (car (cdr ffi-type)))
				  (pnext (convert-ffi-type-to-alien next)))
				 (if (or (eq pnext 'void)
					 (eq pnext '|_IO_lock_t|))
				     ;; sb-alien definitions of void pointers are different from those of
				     ;; ffigen4: we have to convert (pointer (void)) to (* T)
				     t
				     pnext))))
	     (enum-ref ; `(enum ,(intern (second ffi-type)))
	       (intern (second ffi-type))
	      )
	     (union-ref `(union ,(intern (second ffi-type))))
	     (transparent-union-ref `(union ,(intern (second ffi-type))))
	     (struct-ref (when struct `(struct ,(intern (second ffi-type)))))
	     (typedef (intern (second ffi-type)))
	     (array
	      `(array ,(convert-ffi-type-to-alien (third ffi-type)) ,(second ffi-type)))
	     (function
	      (let ((params (second ffi-type))
		    (ret (third ffi-type)))
		`(function  ,(convert-ffi-type-to-alien ret)
			    ,@(mapcar #'convert-ffi-type-to-alien params))))
	     (t (error "reference to unhandled ffi-type ~a." ffi-type))))
       (error "ffi-type ~a is not a list." ffi-type))))

(defmacro define-foreign-stuff ()
  `(progn
     ,@(remove-if #'null
	(loop for e in (remove-if-not #'(lambda (x) (member x '(struct type
							   union transparent-union enum
							   )))
				      *nlopt-ffi* :key #'first) collect
	     (destructuring-bind (entity _ name rest) e
	       (declare (ignorable name _))
	       (case entity
		 (type
		  (let ((ty (convert-ffi-type-to-alien rest :struct
						       t)))
		    (when (and ty (not (eq ty 'void)))
		      ;; they do typedef _IO_lock_t void, i can't
		      ;; represent this as an alien type, for now i'll
		      ;; fix it by manually replacing it with t in
		      ;; pointers (see convert-ffi-type-to-alien)
		      `(define-alien-type ,(intern name) ,ty))))
		 (enum
		  `(progn
		     (define-alien-type ,(intern name)
			 (enum ,(intern name) ,@(loop for (n v) in rest collect
						     (list (intern n) v))))
		     #+nil ,@(loop for (n v) in rest collect
				  `(defparameter ,(intern (format nil "*~a*" n)) ,v))))
		 (t
		  `(define-alien-type ,(intern name)
		       (,(if (eq entity 'transparent-union)
			     'union
			     entity) ,(intern name)
			 ,@(loop for (name (_ type a b)) in rest collect
				`(,(intern name) ,(convert-ffi-type-to-alien type))))))))))))

;; unions, types and structs must be defined in the order as they
;; occur in the ffi file, so that the size of structs and unions is
;; known when referred to
(define-foreign-stuff)

(defmacro define-functions ()
  `(progn
     ,@(remove-if #'null
		  (loop for e in (remove-if-not #'(lambda (x) (eq x 'function)) *nlopt-ffi* :key #'first) collect
		       (destructuring-bind (function _ name (fun params ret) extra) e
			 (declare (ignorable function _ extra fun))
			 (handler-case
			     `(define-alien-routine ,(intern name)
			,(convert-ffi-type-to-alien ret)
				,@(let ((a 0))
				       (mapcar #'(lambda (x) (list (intern (format nil "P~a" (incf a)))
							      ;; unfortunately, the argument names are not stored in output
							      ;; of ffigen4, therefore i just use P1, P2, ...
							      (convert-ffi-type-to-alien x))) params)))
			   (ffi-doesnt-support-long-float ())))))))


(load-shared-object "libnlopt.so")

(define-functions)
