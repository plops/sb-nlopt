;; i macro-expanded the two macros define-foreign-stuff and
;; define-functions from nlopt-ffi.lisp to obtain the following
;; foreign definitions:

(PROGN
 (DEFINE-ALIEN-TYPE |ptrdiff_t| LONG)
 (DEFINE-ALIEN-TYPE |size_t| UNSIGNED-LONG)
 (DEFINE-ALIEN-TYPE |wchar_t| INT)
 (DEFINE-ALIEN-TYPE |nlopt_func|
                    (FUNCTION DOUBLE UNSIGNED (* DOUBLE) (* DOUBLE) (* T)))
 (DEFINE-ALIEN-TYPE |nlopt_mfunc|
                    (FUNCTION VOID UNSIGNED (* DOUBLE) UNSIGNED (* DOUBLE)
                     (* DOUBLE) (* T)))
 (DEFINE-ALIEN-TYPE |nlopt_precond|
                    (FUNCTION VOID UNSIGNED (* DOUBLE) (* DOUBLE) (* DOUBLE)
                     (* T)))
 (DEFINE-ALIEN-TYPE |44_/usr/local/include/nlopt.h|
     (ENUM |44_/usr/local/include/nlopt.h| (NLOPT_GN_DIRECT 0)
	   (NLOPT_GN_DIRECT_L 1) (NLOPT_GN_DIRECT_L_RAND 2)
	   (NLOPT_GN_DIRECT_NOSCAL 3) (NLOPT_GN_DIRECT_L_NOSCAL 4)
	   (NLOPT_GN_DIRECT_L_RAND_NOSCAL 5)
	   (NLOPT_GN_ORIG_DIRECT 6) (NLOPT_GN_ORIG_DIRECT_L 7)
	   (NLOPT_GD_STOGO 8) (NLOPT_GD_STOGO_RAND 9)
	   (NLOPT_LD_LBFGS_NOCEDAL 10) (NLOPT_LD_LBFGS 11)
	   (NLOPT_LN_PRAXIS 12) (NLOPT_LD_VAR1 13)
	   (NLOPT_LD_VAR2 14) (NLOPT_LD_TNEWTON 15)
	   (NLOPT_LD_TNEWTON_RESTART 16)
	   (NLOPT_LD_TNEWTON_PRECOND 17)
	   (NLOPT_LD_TNEWTON_PRECOND_RESTART 18)
	   (NLOPT_GN_CRS2_LM 19) (NLOPT_GN_MLSL 20)
	   (NLOPT_GD_MLSL 21) (NLOPT_GN_MLSL_LDS 22)
	   (NLOPT_GD_MLSL_LDS 23) (NLOPT_LD_MMA 24)
	   (NLOPT_LN_COBYLA 25) (NLOPT_LN_NEWUOA 26)
	   (NLOPT_LN_NEWUOA_BOUND 27) (NLOPT_LN_NELDERMEAD 28)
	   (NLOPT_LN_SBPLX 29) (NLOPT_LN_AUGLAG 30)
	   (NLOPT_LD_AUGLAG 31) (NLOPT_LN_AUGLAG_EQ 32)
	   (NLOPT_LD_AUGLAG_EQ 33) (NLOPT_LN_BOBYQA 34)
	   (NLOPT_GN_ISRES 35) (NLOPT_AUGLAG 36)
	   (NLOPT_AUGLAG_EQ 37) (NLOPT_G_MLSL 38)
	   (NLOPT_G_MLSL_LDS 39) (NLOPT_LD_SLSQP 40)
	   (NLOPT_LD_CCSAQ 41) (NLOPT_GN_ESCH 42)
	   (NLOPT_NUM_ALGORITHMS 43)))
 (DEFINE-ALIEN-TYPE |nlopt_algorithm| |44_/usr/local/include/nlopt.h|)
 (DEFINE-ALIEN-TYPE |48_/usr/local/include/nlopt.h|
     (ENUM |48_/usr/local/include/nlopt.h| (NLOPT_FAILURE -1)
	   (NLOPT_INVALID_ARGS -2) (NLOPT_OUT_OF_MEMORY -3)
	   (NLOPT_ROUNDOFF_LIMITED -4) (NLOPT_FORCED_STOP -5)
	   (NLOPT_SUCCESS 1) (NLOPT_STOPVAL_REACHED 2)
	   (NLOPT_FTOL_REACHED 3) (NLOPT_XTOL_REACHED 4)
	   (NLOPT_MAXEVAL_REACHED 5) (NLOPT_MAXTIME_REACHED 6)))
 (DEFINE-ALIEN-TYPE |nlopt_result| |48_/usr/local/include/nlopt.h|)
 (DEFINE-ALIEN-TYPE |nlopt_opt| (* (STRUCT |nlopt_opt_s|)))
 (DEFINE-ALIEN-TYPE |nlopt_munge| (FUNCTION (* T) (* T)))
 (DEFINE-ALIEN-TYPE |nlopt_munge2| (FUNCTION (* T) (* T) (* T)))
 (DEFINE-ALIEN-TYPE |nlopt_func_old|
     (FUNCTION DOUBLE INT (* DOUBLE) (* DOUBLE) (* T))))

(PROGN
  (DEFINE-ALIEN-ROUTINE |nlopt_algorithm_name| (* CHAR) (P1 |nlopt_algorithm|))
  (DEFINE-ALIEN-ROUTINE |nlopt_srand| VOID (P1 UNSIGNED-LONG))
  (DEFINE-ALIEN-ROUTINE |nlopt_srand_time| VOID)
  (DEFINE-ALIEN-ROUTINE |nlopt_version| VOID (P1 (* INT)) (P2 (* INT))
			(P3 (* INT)))
  (DEFINE-ALIEN-ROUTINE |nlopt_create| |nlopt_opt| (P1 |nlopt_algorithm|)
			(P2 UNSIGNED))
  (DEFINE-ALIEN-ROUTINE |nlopt_destroy| VOID (P1 |nlopt_opt|))
  (DEFINE-ALIEN-ROUTINE |nlopt_copy| |nlopt_opt|
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_optimize| |nlopt_result| (P1 |nlopt_opt|)
			(P2 (* DOUBLE)) (P3 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_min_objective| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 (* T)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_max_objective| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 (* T)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_precond_min_objective| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 |nlopt_precond|)
    (P4 (* T)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_precond_max_objective| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 |nlopt_precond|)
    (P4 (* T)))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_algorithm| |nlopt_algorithm|
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_dimension| UNSIGNED
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_lower_bounds| |nlopt_result| (P1 |nlopt_opt|)
			(P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_lower_bounds1| |nlopt_result|
    (P1 |nlopt_opt|) (P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_lower_bounds| |nlopt_result|
    (P1 (* (STRUCT |nlopt_opt_s|))) (P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_upper_bounds| |nlopt_result| (P1 |nlopt_opt|)
			(P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_upper_bounds1| |nlopt_result|
    (P1 |nlopt_opt|) (P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_upper_bounds| |nlopt_result|
    (P1 (* (STRUCT |nlopt_opt_s|))) (P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_remove_inequality_constraints| |nlopt_result|
    (P1 |nlopt_opt|))
  (DEFINE-ALIEN-ROUTINE |nlopt_add_inequality_constraint| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 (* T))
    (P4 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_add_precond_inequality_constraint| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 |nlopt_precond|)
    (P4 (* T)) (P5 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_add_inequality_mconstraint| |nlopt_result|
    (P1 |nlopt_opt|) (P2 UNSIGNED) (P3 |nlopt_mfunc|)
    (P4 (* T)) (P5 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_remove_equality_constraints| |nlopt_result|
    (P1 |nlopt_opt|))
  (DEFINE-ALIEN-ROUTINE |nlopt_add_equality_constraint| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 (* T))
    (P4 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_add_precond_equality_constraint| |nlopt_result|
    (P1 |nlopt_opt|) (P2 |nlopt_func|) (P3 |nlopt_precond|)
    (P4 (* T)) (P5 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_add_equality_mconstraint| |nlopt_result|
    (P1 |nlopt_opt|) (P2 UNSIGNED) (P3 |nlopt_mfunc|)
    (P4 (* T)) (P5 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_stopval| |nlopt_result| (P1 |nlopt_opt|)
			(P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_stopval| DOUBLE
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_ftol_rel| |nlopt_result| (P1 |nlopt_opt|)
			(P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_ftol_rel| DOUBLE
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_ftol_abs| |nlopt_result| (P1 |nlopt_opt|)
			(P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_ftol_abs| DOUBLE
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_xtol_rel| |nlopt_result| (P1 |nlopt_opt|)
			(P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_xtol_rel| DOUBLE
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_xtol_abs1| |nlopt_result| (P1 |nlopt_opt|)
			(P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_xtol_abs| |nlopt_result| (P1 |nlopt_opt|)
			(P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_xtol_abs| |nlopt_result|
    (P1 (* (STRUCT |nlopt_opt_s|))) (P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_maxeval| |nlopt_result| (P1 |nlopt_opt|)
			(P2 INT))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_maxeval| INT (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_maxtime| |nlopt_result| (P1 |nlopt_opt|)
			(P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_maxtime| DOUBLE
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_force_stop| |nlopt_result| (P1 |nlopt_opt|))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_force_stop| |nlopt_result| (P1 |nlopt_opt|)
			(P2 INT))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_force_stop| INT
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_local_optimizer| |nlopt_result|
    (P1 |nlopt_opt|) (P2 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_population| |nlopt_result| (P1 |nlopt_opt|)
			(P2 UNSIGNED))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_population| UNSIGNED
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_vector_storage| |nlopt_result|
    (P1 |nlopt_opt|) (P2 UNSIGNED))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_vector_storage| UNSIGNED
    (P1 (* (STRUCT |nlopt_opt_s|))))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_default_initial_step| |nlopt_result|
    (P1 |nlopt_opt|) (P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_initial_step| |nlopt_result| (P1 |nlopt_opt|)
			(P2 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_initial_step1| |nlopt_result|
    (P1 |nlopt_opt|) (P2 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_initial_step| |nlopt_result|
    (P1 (* (STRUCT |nlopt_opt_s|))) (P2 (* DOUBLE))
    (P3 (* DOUBLE)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_munge| VOID (P1 |nlopt_opt|)
			(P2 |nlopt_munge|) (P3 |nlopt_munge|))
  (DEFINE-ALIEN-ROUTINE |nlopt_munge_data| VOID (P1 |nlopt_opt|)
			(P2 |nlopt_munge2|) (P3 (* T)))
  (DEFINE-ALIEN-ROUTINE |nlopt_minimize| |nlopt_result| (P1 |nlopt_algorithm|)
			(P2 INT) (P3 |nlopt_func_old|) (P4 (* T))
			(P5 (* DOUBLE)) (P6 (* DOUBLE)) (P7 (* DOUBLE))
			(P8 (* DOUBLE)) (P9 DOUBLE) (P10 DOUBLE) (P11 DOUBLE)
			(P12 DOUBLE) (P13 (* DOUBLE)) (P14 INT) (P15 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_minimize_constrained| |nlopt_result|
    (P1 |nlopt_algorithm|) (P2 INT) (P3 |nlopt_func_old|)
    (P4 (* T)) (P5 INT) (P6 |nlopt_func_old|) (P7 (* T))
    (P8 |ptrdiff_t|) (P9 (* DOUBLE)) (P10 (* DOUBLE))
    (P11 (* DOUBLE)) (P12 (* DOUBLE)) (P13 DOUBLE)
    (P14 DOUBLE) (P15 DOUBLE) (P16 DOUBLE) (P17 (* DOUBLE))
    (P18 INT) (P19 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_minimize_econstrained| |nlopt_result|
    (P1 |nlopt_algorithm|) (P2 INT) (P3 |nlopt_func_old|)
    (P4 (* T)) (P5 INT) (P6 |nlopt_func_old|) (P7 (* T))
    (P8 |ptrdiff_t|) (P9 INT) (P10 |nlopt_func_old|)
    (P11 (* T)) (P12 |ptrdiff_t|) (P13 (* DOUBLE))
    (P14 (* DOUBLE)) (P15 (* DOUBLE)) (P16 (* DOUBLE))
    (P17 DOUBLE) (P18 DOUBLE) (P19 DOUBLE) (P20 DOUBLE)
    (P21 (* DOUBLE)) (P22 DOUBLE) (P23 DOUBLE) (P24 INT)
    (P25 DOUBLE))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_local_search_algorithm| VOID
    (P1 (* |nlopt_algorithm|)) (P2 (* |nlopt_algorithm|))
    (P3 (* INT)))
  (DEFINE-ALIEN-ROUTINE |nlopt_set_local_search_algorithm| VOID
    (P1 |nlopt_algorithm|) (P2 |nlopt_algorithm|) (P3 INT))
  (DEFINE-ALIEN-ROUTINE |nlopt_get_stochastic_population| INT)
  (DEFINE-ALIEN-ROUTINE |nlopt_set_stochastic_population| VOID (P1 INT)))
