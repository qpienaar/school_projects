# Self-Balancing Segway Control

## Overview

This project models and stabilizes a two-wheeled self-balancing robot as an inverted pendulum. The control objective is to regulate body tilt near the upright equilibrium while controlling horizontal displacement.

## System Model

The nonlinear state is

$$
x = \begin{bmatrix} p & \dot{p} & \theta & \dot{\theta} \end{bmatrix}^{T},
$$

where $p$ is displacement and $\theta$ is body tilt. Motor voltage is the control input. `rhs.m` evaluates the coupled wheel and pendulum dynamics, and `GetLinModFtxu.m` obtains numerical Jacobians about the upright equilibrium for state-space controller design.

## Technical Approach

`determineABK.m` linearizes the nonlinear model and computes a linear-quadratic regulator (LQR) gain using weighted position, velocity, angle, and angular-rate states. Simulink models support nonlinear closed-loop simulation, linear-model investigation, and hardware-oriented implementation. An accompanying video records physical-system behavior.

## Repository Contents

| File | Description |
| --- | --- |
| [`rhs.m`](rhs.m) | Nonlinear equations of motion. |
| [`GetLinModFtxu.m`](GetLinModFtxu.m) | Central-difference numerical linearization utility. |
| [`determineABK.m`](determineABK.m) | LQR gain design and controller simulations. |
| [`simulate_sys.m`](simulate_sys.m) | Open-loop nonlinear simulation using `ode45`. |
| [`nonlinmodel.slx`](nonlinmodel.slx) | Nonlinear Simulink model. |
| [`linmodel.slx`](linmodel.slx) | Linear Simulink model. |
| [`hardware_implimentation.slx`](hardware_implimentation.slx) | Hardware implementation model. |
| [`VID-20251121-WA0004.mp4`](VID-20251121-WA0004.mp4) | Recorded physical demonstration. |

## Running The Model

Use MATLAB with Simulink and Control System Toolbox. Run `simulate_sys.m` to inspect the nonlinear open-loop dynamics or `determineABK.m` to construct the LQR controller and execute the configured closed-loop simulation.

## Skills And Tools

MATLAB, Simulink, nonlinear dynamics, numerical linearization, state-space control, and LQR design.

## Course

[Mechatronics](../)
