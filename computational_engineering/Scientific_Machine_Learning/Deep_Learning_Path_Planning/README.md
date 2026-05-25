**Scientific Machine Learning: Efficient Path Planning with Neural Networks**

**Description**

This project investigates whether a convolutional neural network can be trained to serve as an improved heuristic for the A* path planning algorithm on randomly generated obstacle maps where traditional Euclidean distance performs poorly. A CNN is trained to estimate the true cost-to-goal from any free cell given a 3-channel input encoding the map layout, query position, and goal position. Two loss functions are compared during training: standard MSE (main.py) and a custom piecewise MAE loss that applies an asymmetric penalty to overestimates relative to the true cost, encouraging the network to learn admissible heuristics.

Four experimental configurations were evaluated against a pure Euclidean baseline across 100 randomly generated 20×20 maps in rooms, walls, and random obstacle styles. Using the learned heuristic directly with piecewise MAE achieved the best search cost reduction of 34.2% with a 25.9% overestimation rate, while capping the heuristic at the Euclidean lower bound preserved 100% admissibility and optimality at a more modest 5.5% reduction. Results confirm that neural networks can meaningfully reduce A* search cost, and that asymmetric loss functions improve admissibility without fully sacrificing efficiency.

**Instructions**

Install all Python files to a directory.

main.py - Trains with standard MSE loss and saves the model to mse_model.pt.

mainv2.py - On first run trains with piecewise MAE loss and saves to heuristic_model.pt. On subsequent runs the saved model is loaded automatically. 

Set RUN_ALPHA_SWEEP = True in mainv2.py to determine a desired alpha2 parameter

**Skills**

Path planning and search algorithms, Neural network design and training, technical presentations

**Tools**
Python, PyTorch, NumPy, Matplotlib
