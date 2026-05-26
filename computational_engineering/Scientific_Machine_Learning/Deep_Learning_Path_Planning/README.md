# Deep Learning Path Planning

## Overview

This project tests whether a convolutional neural network can supply a useful heuristic for A* search on randomly generated obstacle maps. The model estimates cost-to-go from an encoded map, query cell, and goal cell, with the goal of exploring fewer states than a Euclidean-distance baseline while monitoring path optimality.

## Technical Approach

- Generate connected maps with random, wall, and room-style obstacles.
- Compute target path costs with A* and train a CNN on three-channel map inputs.
- Compare mean-squared-error training with an asymmetric piecewise absolute-error loss that penalizes heuristic overestimation.
- Evaluate learned and capped learned heuristics against Euclidean A* on $20 \times 20$ maps.

The final report records a 34.2% search-cost reduction for the directly applied piecewise-loss heuristic, with a 25.9% overestimation rate. Capping the learned value with the admissible baseline retained optimality while producing a smaller 5.5% search-cost reduction.

## Repository Contents

| File | Description |
| --- | --- |
| [`astar.py`](astar.py) | A* implementation and heuristic interfaces. |
| [`cnn.py`](cnn.py) | Neural-network definition. |
| [`map.py`](map.py) | Obstacle-map generation and visualization. |
| [`mainv2.py`](mainv2.py) | Training and evaluation using the asymmetric heuristic loss. |
| [`alpha_sweep.py`](alpha_sweep.py) | Loss-parameter sweep support. |
| `mse_model.pt`, `heuristic_model.pt` | Saved PyTorch model weights. |
| [`SciMLFinal.pdf`](SciMLFinal.pdf) | Final project report. |

## Running The Experiment

Use a Python environment with PyTorch, NumPy, and Matplotlib. Run `mainv2.py` to load or train the heuristic model and evaluate search behavior; `alpha_sweep.py` supports investigation of the asymmetric-loss weight.

## Skills And Tools

Path planning, A* search, neural-network training, heuristic admissibility, Python, PyTorch, NumPy, and Matplotlib.

## Course

[Scientific Machine Learning](../)
