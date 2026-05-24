#!/bin/bash
#SBATCH -J stencil_1node
#SBATCH -o stencil_1node.out
#SBATCH -e stencil_1node.err
#SBATCH -t 30
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --partition=el8-rpi
#SBATCH --gres=gpu:4

module load xl_r spectrum-mpi cuda
export OMP_NUM_THREADS=1

EXEC=./stencil
HALO=64
STRONG_LOG=strong_1node.txt
WEAK_LOG=weak_1node.txt

rm -f $STRONG_LOG $WEAK_LOG

# ─────────────────────────────────────────
# STRONG SCALING  (NumElements=30, HaloSize=64)
# ─────────────────────────────────────────
echo "=========================================" | tee -a $STRONG_LOG
echo "STRONG SCALING TESTS  (NumElements=30, HaloSize=64)" | tee -a $STRONG_LOG
echo "=========================================" | tee -a $STRONG_LOG

echo "" | tee -a $STRONG_LOG
echo "[STRONG-1]  1 node,  2 ranks" | tee -a $STRONG_LOG
mpirun -np 2 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $STRONG_LOG

echo "" | tee -a $STRONG_LOG
echo "[STRONG-2]  1 node,  4 ranks" | tee -a $STRONG_LOG
mpirun -np 4 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $STRONG_LOG

echo "" | tee -a $STRONG_LOG
echo "[STRONG-3]  1 node,  8 ranks" | tee -a $STRONG_LOG
mpirun -np 8 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $STRONG_LOG

echo "" | tee -a $STRONG_LOG
echo "[STRONG-4]  1 node,  16 ranks" | tee -a $STRONG_LOG
mpirun -np 16 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $STRONG_LOG

echo "" | tee -a $STRONG_LOG
echo "[STRONG-5]  1 node,  32 ranks" | tee -a $STRONG_LOG
mpirun -np 32 --bind-to core:overload-allowed $EXEC 30 $HALO 0 | tee -a $STRONG_LOG

# ─────────────────────────────────────────
# WEAK SCALING  (2^24 elements per rank, HaloSize=64)
# ─────────────────────────────────────────
echo ""  | tee -a $WEAK_LOG
echo "=========================================" | tee -a $WEAK_LOG
echo "WEAK SCALING TESTS  (2^24 elements/rank, HaloSize=64)" | tee -a $WEAK_LOG
echo "=========================================" | tee -a $WEAK_LOG

echo "" | tee -a $WEAK_LOG
echo "[WEAK-1]  1 node,  2 ranks,  NumElements=25  (2^25 total)" | tee -a $WEAK_LOG
mpirun -np 2 --bind-to core:overload-allowed $EXEC 25 $HALO 0 | tee -a $WEAK_LOG

echo "" | tee -a $WEAK_LOG
echo "[WEAK-2]  1 node,  4 ranks,  NumElements=26  (2^26 total)" | tee -a $WEAK_LOG
mpirun -np 4 --bind-to core:overload-allowed $EXEC 26 $HALO 0 | tee -a $WEAK_LOG

echo "" | tee -a $WEAK_LOG
echo "[WEAK-3]  1 node,  8 ranks,  NumElements=27  (2^27 total)" | tee -a $WEAK_LOG
mpirun -np 8 --bind-to core:overload-allowed $EXEC 27 $HALO 0 | tee -a $WEAK_LOG

echo "" | tee -a $WEAK_LOG
echo "[WEAK-4]  1 node,  16 ranks,  NumElements=28  (2^28 total)" | tee -a $WEAK_LOG
mpirun -np 16 --bind-to core:overload-allowed $EXEC 28 $HALO 0 | tee -a $WEAK_LOG

echo "" | tee -a $WEAK_LOG
echo "[WEAK-5]  1 node,  32 ranks,  NumElements=29  (2^29 total)" | tee -a $WEAK_LOG
mpirun -np 32 --bind-to core:overload-allowed $EXEC 29 $HALO 0 | tee -a $WEAK_LOG

echo "1-node tests complete."
