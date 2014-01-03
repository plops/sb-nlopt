// this is from the nlopt tutorial
#include <stdio.h>
#include <math.h>
#include <nlopt.h>
double myfunc(unsigned n, const double *x, double *grad, void *my_func_data)
{
    if (grad) {
        grad[0] = 0.0;
        grad[1] = 0.5 / sqrt(x[1]);
    }
    return sqrt(x[1]);
}
typedef struct {
    double a, b;
} my_constraint_data;
double myconstraint(unsigned n, const double *x, double *grad, void *data)
{
    my_constraint_data *d = (my_constraint_data *) data;
    double a = d->a, b = d->b;
    if (grad) {
        grad[0] = 3 * a * (a*x[0] + b) * (a*x[0] + b);
        grad[1] = -1.0;
    }
    return ((a*x[0] + b) * (a*x[0] + b) * (a*x[0] + b) - x[1]);
 }
double lb[2] = { -HUGE_VAL, 0 }; /* lower bounds */
nlopt_opt opt;
int main(int argc,char**argv)
{
  opt = nlopt_create(NLOPT_LD_MMA, 2); /* algorithm and dimensionality */
  nlopt_set_lower_bounds(opt, lb);
  nlopt_set_min_objective(opt, myfunc, NULL);

  my_constraint_data data[2] = { {2,0}, {-1,1} };
  nlopt_add_inequality_constraint(opt, myconstraint, &data[0], 1e-8);
  nlopt_add_inequality_constraint(opt, myconstraint, &data[1], 1e-8);
  nlopt_set_xtol_rel(opt, 1e-4);double x[2] = { 1.234, 5.678 };  /* some initial guess */
  double minf; /* the minimum objective value, upon return */
  int n = nlopt_optimize(opt, x, &minf); 
  if (n < 0) {
    printf("nlopt failed!\n");
  }
  else {
    printf("%d found minimum at f(%g,%g) = %0.10g\n", n, x[0], x[1], minf);
  nlopt_destroy(opt);
}

// this programs output is:
// 4 found minimum at f(0.333333,0.296296) = 0.5443310474
