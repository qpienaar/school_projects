#!/bin/bash
#SBATCH -J stencil_2node
#SBATCH -o stencil_2node.out
#SBATCH -e stencil_2node.err
#SBATCH -t 01:00:00
#SBATCH -N 2
#SBATCH -n 64
#SBATCH --partition=el8-rpi
#SBATCH --gres=gpu:4

module load xl_r spectrum-mpi cuda
export OMP_NUM_THREADS=1

EXEC=./stencil
HALO=64
STRONG_LOG=strong_2node.txt
WEAK_LOG=weak_2node.txt

rm -f $STRONG_LOG $WEAK_LOG

echo "=========================================" | tee -a $STRONG_LOG
echo "STRONG SCALING TESTS  (NumElements=30, HaloSize=64)" | tee -a $STRONG_LOG
echo "=========================================" | tee -a $STRONG_LOG
echo "" | tee -a $STRONG_LOG
echo "[STRONG-6]  2 nodes,  64 ranks" | tee -a $STRONG_LOG
mpirun -np 64 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $STRONG_LOG

echo ""  | tee -a $WEAK_LOG
echo "=========================================" | tee -a $WEAK_LOG
echo "WEAK SCALING TESTS  (2^24 elements/rank, HaloSize=64)" | tee -a $WEAK_LOG
echo "=========================================" | tee -a $WEAK_LOG
echo "" | tee -a $WEAK_LOG
echo "[WEAK-6]  2 nodes,  64 ranks,  NumElements=30  (2^30 total)" | tee -a $WEAK_LOG
mpirun -np 64 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $WEAK_LOG

echo "2-node tests complete."
