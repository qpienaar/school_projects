# Mechatronics: Self-Balancing Segway Control Design

This project models, linearizes, and designs a feedback control system for a self-balancing Segway robot. The controller aims to maintain the robot's vertical balance (tilt angle $\theta = 0$) and control its horizontal displacement. 

---

## System Dynamics
The system is modeled as an inverted pendulum on a cart. The state vector is defined as:
$$x = \begin{bmatrix} p \\ \dot{p} \\ \theta \\ \dot{\theta} \end{bmatrix}$$
where:
* $p$ is the horizontal displacement (m)
* $\dot{p}$ is the linear velocity (m/s)
* $\theta$ is the tilt angle of the body (rad)
* $\dot{\theta}$ is the angular velocity (rad/s)

The input $u$ is the motor control voltage. The equations of motion are non-linear, and the system is unstable in open-loop.

---

## Directory Contents

The following files are located in this directory:

### MATLAB Scripts & Functions
* **[rhs.m](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/rhs.m)**: Defines the non-linear state derivative vector ($\dot{x}$) for the Segway's equations of motion. It resolves the internal reaction forces by setting up and solving a matrix system $Az = b$ for the acceleration components.
* **[GetLinModFtxu.m](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/GetLinModFtxu.m)**: A utility function that numerically computes the Jacobian matrices $A$ and $B$ for any system function handle using central finite differences around a given state and input.
* **[determineABK.m](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/determineABK.m)**: Designs the Linear Quadratic Regulator (LQR) state-feedback controller. It linearizes the system, calculates optimal gains ($K$), and simulates both standard state feedback and integrated state feedback (which introduces an extra state to eliminate steady-state position error).
* **[simulate_sys.m](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/simulate_sys.m)**: Simulates the open-loop response of the non-linear Segway model to a constant voltage input using `ode45`.

### Simulink Models
* **[nonlinmodel.slx](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/nonlinmodel.slx)**: Non-linear simulation model of the Segway system.
* **[linmodel.slx](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/linmodel.slx)**: Linear state-space model used to simulate the closed-loop performance.
* **[hardware_implimentation.slx](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/hardware_implimentation.slx)**: Simulink configuration ready for hardware deployment.

---

## Instructions

1. **Linearize and Design Controller**:
   Run the [determineABK.m](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/determineABK.m) script. This will:
   * Perform numerical linearization about the stable equilibrium ($x_s = [0, 0, 0, 0]^T$, $u_s = 0$).
   * Calculate LQR state-feedback gain matrices for both basic LQR and LQR with integral action.
   * Simulate the closed-loop models and plot the displacement and tilt angle over time.
2. **Open-Loop Simulation**:
   Run [simulate_sys.m](file:///home/quintenpienaar/github/controls_and_robotics/Mechatronics/segway/simulate_sys.m) to observe the unstable open-loop behavior of the non-linear equations of motion.
