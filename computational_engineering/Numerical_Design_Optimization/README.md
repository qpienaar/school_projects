# Numerical Design Optimization

This course applies numerical optimization to engineering design, covering gradient-based constrained and unconstrained methods, derivative evaluation, surrogate models, gradient-free methods, multi-objective design, and optimization under uncertainty.

## Projects

| Project | Description | Tools |
| --- | --- | --- |
| [Wing Spar Optimization](wing_spar/) | Mass minimization of an annular UAV wing spar under structural stress constraints. | MATLAB, `fmincon`, finite elements |
| [Amusement Park Ride Optimization](amusement_park/) | Surrogate-based optimization of nonlinear Tilt-A-Whirl dynamics. | MATLAB, GPML, `ode45`, `fmincon` |
| [Wing Spar Optimization Under Uncertainty](wing_spar_uncertain/) | Robust spar design with uncertain loading and six-sigma stress constraints. | MATLAB, Gauss-Hermite quadrature, `fmincon` |

## Concepts

- Finite element structural analysis and convergence studies.
- Complex-step derivatives for gradient-based optimization.
- Gaussian-process surrogate models and uncertainty quantification.
