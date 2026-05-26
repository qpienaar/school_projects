# Wing Spar Optimization

## Overview

This project minimizes the mass of a carbon-fiber wing spar for a long-endurance UAV while satisfying stress and geometry constraints during a $2.5g$ maneuver. The spar is represented as an annular beam with spanwise inner and outer radii as design variables.

## Technical Approach And Results

A finite element model based on Euler-Bernoulli beam theory computes displacement and tensile stress. MATLAB `fmincon` performs active-set constrained optimization, and supporting routines provide load construction, objective and constraint evaluation, and convergence plots. The project report records a 62% mass reduction relative to the nominal design while meeting the structural constraints.

## Repository Contents

| File Or Group | Description |
| --- | --- |
| [`run_opt.m`](run_opt.m) | Main optimization entry point and final plots. |
| [`convergence_study.m`](convergence_study.m), [`plots.m`](plots.m) | Study and visualization scripts. |
| [`obj.m`](obj.m), [`constrain.m`](constrain.m), [`ineq.m`](ineq.m) | Optimization objective and constraints. |
| [`calc_load.m`](calc_load.m), [`get_radii.m`](get_radii.m), [`get_moment.m`](get_moment.m) | Design and loading utilities. |
| `Calc*.m`, `*HermiteBasis.m`, [`GaussQuad.m`](GaussQuad.m) | Beam finite element support functions. |
| [`NDO Proj 2.pdf`](NDO%20Proj%202.pdf) | Project report. |

## Running The Model

In MATLAB with Optimization Toolbox available, run `run_opt.m` for the optimized spar design, `convergence_study.m` for mesh investigation, or `plots.m` for supporting figures.

## Skills And Tools

MATLAB, constrained optimization, finite element analysis, Euler-Bernoulli beams, and gradient-based design.

## Course

[Numerical Design Optimization](../)
