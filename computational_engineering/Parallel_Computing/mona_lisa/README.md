**Parallel Computing Final Project**

**Description**

This project implements a fully parallel, multi-level Genetic Algorithm (GA) system for triangle-based image vectorization. A target raster image is approximated using a configurable set of semi-transparent triangles. Each candidate solution encodes the vertex coordinates and RGBA colors for up to 512 triangles, and fitness is evaluated under multiple loss functions using batched CUDA kernels that rasterize and score the entire population in a single multi-GPU launch. The system was developed and benchmarked as a high performance computing implementation, deployed on RPI's AiMOS supercomputing cluster using IBM POWER9 nodes equipped with NVIDIA V100 GPUs. An MPI island model distributes independent populations across cluster nodes with periodic ring migration to sustain diversity. 

Strong and weak scaling studies were conducted across single-node multi-GPU and multi-node MPI regimes. Strong scaling results showed a 5.3× speedup on a single node scaling from one to six GPUs, and approximately 20.8× across four nodes each equipped with six GPUs. Weak scaling experiments, which proportionally increased image resolution with GPU count to hold per-GPU workload constant, lead to near-constant wall time in the single-node multi-GPU regime. Multi-node weak scaling proved more complex, with render time rising substantially as each island was required to evaluate a proportionally larger image. 


My contributions to this project included conducting early-stage experimentation comparing dual annealing against a genetic algorithm to determine the best primary optimizer for the system, as well as synthesizing developing figures and tables presented in the results section, and authoring the results, analysis, and conclusion sections of the accompanying paper.

**Instructions**
To view the code for this project see the repository below
https://github.com/mohammed-elkomy/Proj-4320

**Skills**
Parallel computing, CUDA GPU acceleration, MPI computing, genetic algorithms, high performance computing, technical writing

**Tools**
Cuda, C, python
