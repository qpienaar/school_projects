**Numerical Design Optimization Project 3: Amusement Park Ride Optimization**

**Description**

This project investigated the optimization of a Tilt-A-Whirl amusement ride using surrogate-based numerical optimization techniques. The objective was to maximize the variability of car angular velocity, modeled as the standard deviation of angular velocity over time, as a proxy for ride unpredictability and rider excitement. The ride dynamics were modeled using a nonlinear ordinary differential equation and simulated in MATLAB using the ode45 solver. Three primary design variables were optimized: track angular velocity, track inclination angle, and car radius.

Because the objective function depended on computationally expensive time-domain simulations, a Gaussian Process surrogate model was constructed using Latin hypercube sampling and MATLAB’s GPML toolbox. Optimization was then performed on the surrogate using MATLAB’s fmincon solver with an active-set algorithm. A convergence study was conducted to balance simulation accuracy and computational cost, and the final optimized design achieved more than a 300% improvement in angular velocity variability relative to the nominal design while satisfying all design constraints.

**Instructions**

To recreate my results:
Download all Matlab files to a directory

Run runopt.m

**Skills**
Numerical design, constrained optimization, guassian process regression, surrogate modeling,
nonlinear dynamical systems, latin hypercube sampling, ODE's, technical writing

**Tools**
Matlab
