**Parallel Computing Multi-GPU CUDA Stencil**

**Description**

This project implements a one-dimensional stencil algorithm distributed across multiple NVIDIA GPUs using CUDA Unified Memory, developed and benchmarked on RPI's AiMOS supercomputing cluster on a single IBM POWER9 node. The input array is allocated via cudaMallocManaged and divided evenly across devices, with each GPU prefetched its assigned chunk plus halo boundary regions via cudaMemPrefetchAsync. All kernel launches are issued before any synchronization barrier, allowing devices to execute concurrently in parallel. Output correctness is validated analytically against expected boundary and interior stencil values.

Performance was evaluated across 15 test configurations varying grid size (1024–16384 CUDA blocks) and device count (1, 2, and 4 GPUs) on a fixed problem size of 2^30 elements. The 2-GPU configuration was optimal, achieving a 3.58× speedup over the single-GPU baseline of 0.998 seconds. Grid size had negligible impact on execution time across all configurations, and extended experiments at 2^31 and 2^32 elements confirmed this trend, leaving the nature of the performance bottleneck an open question for future investigation.

**Instructions**

Device Prerequisites

IBM POWER9 node or compatible architecture supporting the getticks cycle counter at 512 MHz,
1–4 NVIDIA V100 GPUs with support for CUDA Unified Memory and cudaMemPrefetchAsync,
CUDA toolkit (tested with the cuda module on AiMOS),
Slurm workload manager for job submission on AiMOS

Build: nvcc -o 1d-stencil-strided hw2.cu

Run: bash run_tests.sh

**Skills**
Parallel computing, CUDA GPU acceleration, multi-GPU programming, unified memory management, HPC cluster computing, performance analysis, technical writing

**Tools**
CUDA, C++, nvcc, IBM POWER9 / AiMOS
