# MPI Stencil

## Overview

This project implements a distributed one-dimensional stencil operation with MPI. Ranks hold portions of a large integer array, exchange halo data using nonblocking communication, compute local stencil values, and validate gathered output.

## Technical Approach And Results

Strong and weak scaling experiments were designed for RPI's AiMOS IBM POWER9 nodes, reaching up to 128 ranks across four nodes. The report records near-linear strong scaling for a fixed $2^{30}$-element case, reaching a reported $108 \times$ speedup over a 930-second serial baseline. Weak scaling held approximately $2^{24}$ elements per rank and revealed increasing multi-node overhead attributed to centralized scatter/gather work.

## Repository Contents

| File | Description |
| --- | --- |
| [`hw3.c`](hw3.c) | MPI stencil implementation and validation. |
| [`run_serial.sh`](run_serial.sh) | Serial-baseline Slurm run. |
| [`run_1node.sh`](run_1node.sh) | One-node strong and weak scaling cases. |
| [`run_2node.sh`](run_2node.sh) | Two-node scaling cases. |
| [`run_4node.sh`](run_4node.sh) | Four-node scaling cases. |
| [`hw3_draft.pdf`](hw3_draft.pdf) | Project report. |

## Build And Run

On an MPI/Slurm environment compatible with the AiMOS scripts:

```bash
mpicc -O2 -o stencil hw3.c -lm
sbatch run_serial.sh
sbatch run_1node.sh
sbatch run_2node.sh
sbatch run_4node.sh
```

## Skills And Tools

C, MPI, Slurm, distributed-memory programming, halo exchange, and scaling analysis.

## Course

[Parallel Computing](../)
