# Amusement Park Ride Optimization

## Overview

This project optimizes a Tilt-A-Whirl-style amusement ride by maximizing variation in car angular velocity as a proxy for an unpredictable ride experience. Design variables include track angular velocity, inclination angle, and car radius.

## Technical Approach And Results

MATLAB `ode45` integrates a nonlinear ride model. Because repeated time-domain evaluations are expensive, Latin hypercube samples are used to train a Gaussian-process surrogate with the GPML toolbox, and `fmincon` searches the surrogate design space. The report records an improvement of more than 300% in angular-velocity variability relative to the nominal design while satisfying design constraints.

## Repository Contents

| File | Description |
| --- | --- |
| [`runopt.m`](runopt.m) | Sampling, surrogate fitting, and optimization workflow. |
| [`obj.m`](obj.m) | Dynamic-simulation objective evaluation. |
| [`determineT.m`](determineT.m) | Simulation-horizon investigation. |
| [`scale.m`](scale.m) | Design-variable scaling helper. |
| [`fmincon_plots.m`](fmincon_plots.m), [`testing0bj.m`](testing0bj.m) | Visualization and objective exploration. |
| [`fmincon.txt`](fmincon.txt) | Recorded optimization output. |
| [`NDOProj3.pdf`](NDOProj3.pdf) | Project report. |

## Running The Model

Configure the GPML toolbox path at the start of `runopt.m`, then execute that script in MATLAB with Optimization Toolbox and Statistics and Machine Learning Toolbox support.

## Skills And Tools

MATLAB, nonlinear ODE simulation, Latin hypercube sampling, Gaussian-process regression, surrogate optimization, and `fmincon`.

## Course

[Numerical Design Optimization](../)
