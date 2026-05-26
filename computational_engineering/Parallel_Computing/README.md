# Parallel Computing

This course addresses efficient programming for parallel computers, including shared memory, message passing, data parallelism, algorithmic efficiency, and scientific applications of MPI and GPU computation.

## Projects

| Project | Description | Tools |
| --- | --- | --- |
| [Parallel Image Recreation And Rendering](mona_lisa/) | Genetic-algorithm image approximation using CUDA rendering and MPI island-model scaling. | CUDA, MPI, C/C++, Python |
| [MPI Stencil](mpi_stencil/) | Distributed one-dimensional stencil benchmark with strong and weak scaling studies. | C, MPI, Slurm |
| [Multi-GPU Stencil](multi_gpu_stencil/) | CUDA Unified Memory stencil distributed over NVIDIA GPUs. | CUDA, C++, Slurm |

## Concepts

- Domain decomposition, halo communication, GPU memory management, and kernel execution.
- Strong and weak scaling analysis on the AiMOS high performance computing cluster.
- Profiling performance bottlenecks and validating parallel numerical results.
