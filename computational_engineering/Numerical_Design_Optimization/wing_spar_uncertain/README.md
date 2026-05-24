**Numerical Design Optimization Project 4**

**Description**

This project investigated the structural optimization of a carbon-fiber wing spar for a long-endurance unmanned aerial vehicle (UAV) under uncertain aerodynamic loading conditions. The objective was to minimize spar mass while subject to stochastic loading repersenting of gusts of wind and other in-flight disturbances. The wing spar was modeled as a circular annulus beam using Euler–Bernoulli beam theory and discretized with a finite element mesh to compute stress distributions along the span.

Uncertainty in aerodynamic loading was modeled using normally distributed random variables, and Gauss–Hermite quadrature was used to estimate the mean and standard deviation of stress within the spar. MATLAB’s fmincon optimizer with an active-set algorithm was used to perform the constrained optimization, while gradients of both the objective and constraint functions were computed using complex-step differentiation. A convergence study was conducted to determine appropriate finite element and quadrature resolutions, and the final optimized design achieved a 70.68% reduction in mass relative to the nominal spar design while satisfying six-sigma stress constraints.

The following files were written by me, all others were supplied by the instructor:
opt_spar.m, calc_statistics.m, WingConstraints.m, investigate_GHQ.m, fmincon_plots.m, calc_pertubation.m, calc_load.m, 

**Instructions**

Download all Matlab files to a directory, run opt_spar.m

**Skills**

Numerical design, constrained gradient based optimization, Finite element discretization and analysis (FEA), Euler–Bernoulli beam theory, Gauss–Hermite quadrature
Complex-step differentiation, technical writing

**Tools**
Matlab
