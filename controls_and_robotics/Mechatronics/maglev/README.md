# Magnetic Levitation Control

## Overview

This project models and controls a solenoid-based magnetic levitation system. A magnet's vertical position is regulated by voltage applied to an electromagnet, using measured actuator/sensor behavior and nonlinear dynamic simulation.

## Technical Approach

`MagLev_Data.m` organizes measurements of air gap, PWM command, voltage, Hall-sensor output, and measured magnetic force. The nonlinear state model in `rhs.m` represents vertical motion and coil current. `simulate.m` explores free fall and forced response, linearizes about a levitating equilibrium, constructs a continuous and discrete compensator, and prepares filter/controller coefficients for Simulink use.

## Repository Contents

| File | Description |
| --- | --- |
| [`MagLev_Data.m`](MagLev_Data.m) | Recorded actuator/sensor characterization data and accessors. |
| [`rhs.m`](rhs.m) | Nonlinear magnet and solenoid dynamics. |
| [`GetLinModFtxu.m`](GetLinModFtxu.m) | Numerical linearization utility. |
| [`simulate.m`](simulate.m) | Analysis, controller design, and model execution script. |
| [`lin_maglev.slx`](lin_maglev.slx) | Linearized simulation model. |
| [`nonlin_maglev.slx`](nonlin_maglev.slx) | Nonlinear simulation model. |
| [`Maglev_Hardware_25a_R1.slx`](Maglev_Hardware_25a_R1.slx) | Hardware-oriented Simulink model. |
| [`VID-20251207-WA0002.mp4`](VID-20251207-WA0002.mp4) | Recorded system demonstration. |

## Running The Model

Use MATLAB with Simulink and Control System Toolbox, then execute `simulate.m` to reproduce the model analyses and controller coefficient generation.

## Skills And Tools

MATLAB, Simulink, nonlinear modeling, system linearization, magnetic levitation, compensator design, and sensor characterization.

## Course

[Mechatronics](../)
