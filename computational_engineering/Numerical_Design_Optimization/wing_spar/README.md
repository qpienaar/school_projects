**Numerical Design Optimization Project 2: Wing Spar Optimization**

**Description**
This project investigated the structural optimization of a carbon fiber wing spar for a long-endurance unmanned aerial vehicle (UAV). The objective was to minimize spar mass while ensuring the structure could withstand expected aerodynamic loading during a 2.5g maneuver. The spar geometry was parameterized by its inner and outer radii along the span, and a finite element discretization based on Euler–Bernoulli beam theory was used to compute stress and deformation throughout the structure.

MATLAB’s fmincon optimizer with the active-set algorithm was used to perform the constrained optimization, with stress, manufacturability, and geometric limits imposed as constraints. Custom functions were developed to calculate stress distributions, spar volume, and analytical gradients using complex-step differentiation. A convergence study was conducted to determine an appropriate mesh resolution, and the final optimized design achieved a 62% reduction in mass relative to the nominal spar design while satisfying all structural constraints.

The following files were written by me, all others were supplied by the instructor:

run_opt.m

constrain.m

obj.m

ineq.m

get_radii.m

get_moment.m

calcload.m

plots.m

convergence_study.m

**Instructions**
To recreate my results, download all matlab files to a directory. Then run one of the below files.

run_opt.m will run the optimization and produce a design of the optimized wing spar

convergence_study.m will produce the plot used in the convergence study

plots.m will create plots illustrating the final optimization routine

**Skills**
Numerical design, constrained gradient based optimization, finite element discretization and analysis (FEA), Euler–Bernoulli beam modeling

**Tools**
Matlab
