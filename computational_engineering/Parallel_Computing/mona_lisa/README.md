# Parallel Image Recreation And Rendering

## Overview

This final project implements a parallel genetic-algorithm system that approximates a raster target image using overlapping semi-transparent triangles. Candidate images encode triangle positions and RGBA colors; CUDA kernels render and score populations while MPI distributes evolving populations across an island model.

## Technical Approach And Results

The implementation targeted RPI's AiMOS cluster with IBM POWER9 nodes and NVIDIA V100 GPUs. Single-node multi-GPU tests reached a reported $5.3 \times$ speedup from one to six GPUs, and four-node testing reached approximately $20.8 \times$ relative speedup. The project also evaluated weak scaling as image resolution increased with GPU count.

Contributions documented in the report include early comparison of dual annealing with a genetic algorithm, production of results figures and tables, and authorship of the results, analysis, and conclusion sections.

## Repository Contents

| File | Description |
| --- | --- |
| [`Parallel_Programming_Project.pdf`](Parallel_Programming_Project.pdf) | Final project paper with implementation and performance analysis. |

The implementation source is maintained in the collaborating project repository: [mohammed-elkomy/Proj-4320](https://github.com/mohammed-elkomy/Proj-4320).

## Skills And Tools

Parallel computing, CUDA rendering, MPI, genetic algorithms, performance scaling, C/C++, Python, and technical writing.

## Course

[Parallel Computing](../)
