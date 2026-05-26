# Multi-GPU CUDA Stencil

## Overview

This project distributes a one-dimensional stencil calculation across multiple NVIDIA GPUs using CUDA Unified Memory. Each GPU receives a partition and required halo region, launches work concurrently, and validates output against analytical stencil values.

## Technical Approach And Results

The benchmark was developed for a single IBM POWER9 AiMOS node with NVIDIA V100 GPUs. It varies CUDA block counts and the use of one, two, or four devices for a fixed $2^{30}$-element problem. The report records a best result with two GPUs, reaching a reported $3.58 \times$ speedup over a single-GPU baseline of 0.998 seconds; increased grid size produced little timing variation in the tested range.

## Repository Contents

| File | Description |
| --- | --- |
| [`hw2.cu`](hw2.cu) | CUDA stencil program using managed-memory prefetch and multiple device launches. |
| [`run_tests.sh`](run_tests.sh) | AiMOS/Slurm benchmark script. |
| [`hw2report.pdf`](hw2report.pdf) | Performance report. |

## Build And Run

On a compatible CUDA/AiMOS environment:

```bash
nvcc -o 1d-stencil-strided hw2.cu
bash run_tests.sh
```

## Skills And Tools

CUDA, C++, Unified Memory, GPU parallelism, Slurm, IBM POWER9, and performance analysis.

## Course

[Parallel Computing](../)
