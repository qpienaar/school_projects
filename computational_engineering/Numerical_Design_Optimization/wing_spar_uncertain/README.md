# Wing Spar Optimization Under Uncertainty

## Overview

This project extends structural optimization of a carbon-fiber UAV wing spar to uncertain aerodynamic loading. The objective is to minimize mass while requiring the annular beam to remain within a six-sigma stress limit under modeled disturbances.

## Technical Approach And Results

The MATLAB implementation evaluates an Euler-Bernoulli finite element beam model along a 7.5 m semi-span. Gaussian uncertainty in loading is propagated using Gauss-Hermite quadrature; the constraint uses the estimated mean and standard deviation of stress as $\mu_\sigma + 6\sigma_\sigma$. `fmincon` performs constrained optimization with complex-step gradients. The recorded result reduces mass by 70.68% relative to the nominal spar while satisfying the probabilistic stress condition.

## Repository Contents

| File Or Group | Description |
| --- | --- |
| [`opt_spar.m`](opt_spar.m) | Main optimization and plotting workflow. |
| [`SparWeight.m`](SparWeight.m), [`WingConstraints.m`](WingConstraints.m) | Objective and probabilistic constraints with gradients. |
| [`calc_statistic.m`](calc_statistic.m), [`calc_perturbation.m`](calc_perturbation.m), [`investigate_GHQ.m`](investigate_GHQ.m) | Uncertainty and quadrature evaluation. |
| [`fmincon_plots.m`](fmincon_plots.m), [`data.txt`](data.txt) | Results visualization and stored data. |
| `Calc*.m`, `*HermiteBasis.m`, [`GaussQuad.m`](GaussQuad.m), [`calc_load.m`](calc_load.m) | Finite element and loading support. |

## Running The Model

In MATLAB with Optimization Toolbox available, run `opt_spar.m` to perform the uncertain-load optimization and generate geometry and stress plots.

## Skills And Tools

MATLAB, uncertainty quantification, Gauss-Hermite quadrature, finite element analysis, complex-step differentiation, and constrained optimization.

## Course

[Numerical Design Optimization](../)
