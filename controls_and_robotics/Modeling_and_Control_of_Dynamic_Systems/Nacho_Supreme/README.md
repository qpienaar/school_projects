# Nacho Supreme Self-Balancing Toy

## Overview

This project proposes a feedback controller for a reaction-wheel self-balancing triangular-prism toy. A brushless DC motor drives the reaction wheel; a current sensor and inertial measurement unit provide feedback for stabilizing the chassis angle about its upright equilibrium.

## Technical Approach

The report derives transfer functions for motor electrical dynamics, reaction-wheel mechanics, and the inverted-pendulum chassis. Protected MATLAB sensor functions are characterized numerically using sinusoidal inputs and Bode plots. `motor_controller.m` assembles the modeled plant and nested controllers, then evaluates the design using step response, Bode response, and root locus.

## Repository Contents

| File | Description |
| --- | --- |
| [`motor_controller.m`](motor_controller.m) | Motor, plant, sensor, and controller transfer-function model. |
| [`sensor1_analysis.m`](sensor1_analysis.m) | Frequency-response characterization for the first sensor. |
| [`sensor2_analysis.m`](sensor2_analysis.m) | Frequency-response characterization for the second sensor. |
| `sensor1.p`, `sensor2.p` | Provided protected sensor models. |
| [`submission.pdf`](submission.pdf) | Formal modeling and control-system report. |

## Running The Model

Use MATLAB with Control System Toolbox. The analysis scripts inspect the sensor models, and `motor_controller.m` assembles and plots the closed-loop controller behavior.

## Skills And Tools

MATLAB, transfer functions, frequency-response identification, inverted-pendulum control, cascade feedback, Bode plots, and root locus.

## Course

[Modeling And Control Of Dynamic Systems](../)
