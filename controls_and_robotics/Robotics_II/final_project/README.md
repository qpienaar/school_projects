# Moving Target Visibility Graph

## Overview

This final project implements a Moving Target Visibility Graph (MTVG) for an agent intercepting a target that travels on a known trajectory through a two-dimensional environment with polygonal obstacles. Unlike a conventional visibility graph with a fixed destination, MTVG associates feasible meeting locations with interception timing and agent velocity constraints.

## Technical Approach

The Python implementation defines an `Agent` model for constant-velocity motion and a `Map` model for obstacle geometry, line-of-sight edges, time-based visibility intervals, and interception costs. `main.py` generates columns of triangular obstacles, compares static visibility-graph construction with the full MTVG pipeline, and produces timing and graph visualizations as obstacle density increases.

For constant target velocity and heading, position is updated as:

$$
\mathbf{x}(t) = \mathbf{x}_0 + v t
\begin{bmatrix}
\cos(\theta) \\
\sin(\theta)
\end{bmatrix}.
$$

## Repository Contents

| File | Description |
| --- | --- |
| [`agent.py`](agent.py) | Moving agent and target state model. |
| [`map.py`](map.py) | Visibility graph, visibility intervals, and edge-cost calculations. |
| [`main.py`](main.py) | Benchmark scenario generation, timing comparisons, and figures. |
| [`Final_RMQ.pdf`](Final_RMQ.pdf) | Final project report. |
| [`RMQ - FINAL PRESENTATIOn.pdf`](RMQ%20-%20FINAL%20PRESENTATIOn.pdf) | Final presentation slides. |

## Running The Experiment

Install NumPy and Matplotlib, then run:

```bash
python main.py
```

The script evaluates increasing obstacle-set counts and writes comparison/visibility figures as configured in the source.

## Skills And Tools

Robotic motion planning, visibility graphs, dynamic-target interception, Python, NumPy, and Matplotlib.

## Course

[Robotics II](../)
