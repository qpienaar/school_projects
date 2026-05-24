#!/bin/bash
#SBATCH -J stencil_serial
#SBATCH -o stencil_serial.out
#SBATCH -e stencil_serial.err
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --partition=el8-rpi
#SBATCH --gres=gpu:4

module load xl_r spectrum-mpi cuda
export OMP_NUM_THREADS=1

EXEC=./stencil
HALO=64
SERIAL_LOG=serial_baseline.txt

rm -f $SERIAL_LOG

echo "=========================================" | tee -a $SERIAL_LOG
echo "SERIAL BASELINE  (NumElements=30, HaloSize=64)" | tee -a $SERIAL_LOG
echo "=========================================" | tee -a $SERIAL_LOG
echo "" | tee -a $SERIAL_LOG
echo "[SERIAL]  1 node,  1 rank" | tee -a $SERIAL_LOG
mpirun -np 1 --bind-to core:overload-allowed $EXEC 30 $HALO 1 | tee -a $SERIAL_LOG

echo "Serial baseline complete."
