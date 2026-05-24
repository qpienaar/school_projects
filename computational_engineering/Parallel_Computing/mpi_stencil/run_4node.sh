#!/bin/bash
#SBATCH -J stencil_4node
#SBATCH -o stencil_4node.out
#SBATCH -e stencil_4node.err
#SBATCH -t 01:00:00
#SBATCH -N 4
#SBATCH -n 128
#SBATCH --partition=el8-rpi
#SBATCH --gres=gpu:4

module load xl_r spectrum-mpi cuda
export OMP_NUM_THREADS=1

EXEC=./stencil
HALO=64
STRONG_LOG=strong_4node.txt
WEAK_LOG=weak_4node.txt

rm -f $STRONG_LOG $WEAK_LOG

echo "=========================================" | tee -a $STRONG_LOG
echo "STRONG SCALING TESTS  (NumElements=30, HaloSize=64)" | tee -a $STRONG_LOG
echo "=========================================" | tee -a $STRONG_LOG
echo "" | tee -a $STRONG_LOG
echo "[STRONG-7]  4 nodes,  128 ranks" | tee -a $STRONG_LOG
mpirun -np 128 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $STRONG_LOG

echo ""  | tee -a $WEAK_LOG
echo "=========================================" | tee -a $WEAK_LOG
echo "WEAK SCALING TESTS  (2^24 elements/rank, HaloSize=64)" | tee -a $WEAK_LOG
echo "=========================================" | tee -a $WEAK_LOG
echo "" | tee -a $WEAK_LOG
echo "[WEAK-7]  4 nodes,  128 ranks,  NumElements=31  (2^31 total)" | tee -a $WEAK_LOG
mpirun -np 128 --bind-to core:overload-allowed $EXEC 31 $HALO 0 | tee -a $WEAK_LOG

echo "4-node tests complete."
