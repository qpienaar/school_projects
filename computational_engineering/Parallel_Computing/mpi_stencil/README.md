**Parallel Computing MPI Stencil**

**Description**

This project implements a one-dimensional stencil application using MPI, developed and benchmarked on RPI's AiMOS supercomputing cluster using IBM POWER9 CPU nodes. Each rank is distributed a chunk of a large 1D integer array, exchanges halo regions with its neighbors via non-blocking MPI communication, and computes a stencil sum over a configurable halo radius. Rank zero coordinates data initialization, scattering, and final gathering, with results validated analytically against expected boundary and interior values.


Strong and weak scaling studies were conducted across one, two, and four compute nodes using up to 128 MPI ranks. Strong scaling results on a fixed array of 2^30 elements demonstrated near-linear speedup, reaching 108× at 128 ranks compared to the serial baseline of 930 seconds. Weak scaling experiments held per-rank workload constant at 2^24 elements, showing near-constant execution time of roughly 14–15 seconds across single-node configurations, with a gradual linear increase as the experiment scaled to multiple nodes — attributed to the centralized scatter and gather operations performed by rank zero becoming a serial bottleneck at scale.

**Instructions**

Device Prerequisites

IBM POWER9 CPU nodes (or compatible architecture supporting the getticks cycle counter at 512 MHz),
NVIDIA GPU (required for the AiMOS el8-rpi partition; 4 GPUs per node as configured in the sbatch scripts),
Spectrum MPI (spectrum-mpi module),
XL compiler (xl_r module),
CUDA toolkit (cuda module),
Slurm workload manager for job submission

Build: mpicc -O2 -o stencil hw3.c -lm

Run: 
sbatch run_serial.sh   # Serial baseline (1 rank)
sbatch run_1node.sh    # Strong and weak scaling, 1 node (up to 32 ranks)
sbatch run_2node.sh    # Strong and weak scaling, 2 nodes (64 ranks)
sbatch run_4node.sh    # Strong and weak scaling, 4 nodes (128 ranks)

**Skills**

Parallel computing, MPI distributed memory programming, HPC cluster computing, C programming, strong and weak scaling analysis, technical writing

**Tools**

C, MPI (Spectrum MPI), CUDA, Slurm, IBM POWER9 / AiMOS
