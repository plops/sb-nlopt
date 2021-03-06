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
	     (pointer (let* ((next (car (cdr ffi-type)))
			      (pnext (convert-ffi-type-to-alien next)))
			 (if (or (eq pnext 'void)
				 (eq pnext '|_IO_lock_t|))
			     ;; sb-alien definitions of void pointers are different from those of
			     ;; ffigen4: we have to convert (pointer (void)) to (* T)
			     '(*  t)
			     (if (eq (first next) 'function)
				 pnext
				 `(* ,pnext)))))
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

;; the following is a version of the nlopt tutorial in common lisp
;; i'm sure that lispier wrapper functions can be introduced

(sb-alien::define-alien-callback myfunc double ((n unsigned) (x (* double)) (grad (* double)) (data (* t)))
  (declare (ignorable n data))
  (unless (null-alien grad)
    (setf (deref grad 0) 0d0
	  (deref grad 1) (/ .5d0 (sqrt (deref x 1)))))
  (sqrt (deref x 1)))

(sb-alien::define-alien-callback myconstraint
    double ((n unsigned) (x (* double))
	    (grad (* double)) (data (* t)))
  (declare (ignorable n))
  (let* ((d (sap-alien (alien-sap data) (* double)))
	 (a (deref d 0))
	 (b (deref d 1))
	 (x0 (deref x 0))
	 (x1 (deref x 1))
	 (q (+ (* a x0) b)))
    (unless (null-alien grad)
      (setf (deref grad 0) (* 3d0 a (expt q 2))
	    (deref grad 1) -1d0))
    (- (expt q 3) x1)))

(defparameter *opt* (|nlopt_create| 'NLOPT_LD_MMA 2))

(let ((a (make-array 2 :element-type 'double-float
		     :initial-contents '(-1d200 0d0))))
 (sb-sys:with-pinned-objects (a)
   (|nlopt_set_lower_bounds| *opt* (sb-sys:vector-sap a))))

(|nlopt_set_min_objective| *opt* myfunc
			   (sb-sys:int-sap 0))


(let ((a (make-array 2 :element-type 'double-float
		     :initial-contents '(2d0 0d0))))
 (sb-sys:with-pinned-objects (a)
   (|nlopt_add_inequality_constraint|
    *opt* myconstraint (sb-sys:vector-sap a) 1d-8)))

(let ((a (make-array 2 :element-type 'double-float
		     :initial-contents '(-1d0 1d0))))
 (sb-sys:with-pinned-objects (a)
   (|nlopt_add_inequality_constraint|
    *opt* myconstraint (sb-sys:vector-sap a) 1d-8)))

(|nlopt_set_xtol_rel| *opt* 1d-4)


(let ((x (make-array 2 :element-type 'double-float
		     :initial-contents '(-1.234d0 5.678d0)))
      (minf (make-array 1 :element-type 'double-float
			:initial-contents '(1d3)
			)))
 (sb-sys:with-pinned-objects (x minf)
   (|nlopt_optimize| *opt*
		     (sb-sys:vector-sap x)
		     (sb-sys:vector-sap minf))
   (aref minf 0)))
