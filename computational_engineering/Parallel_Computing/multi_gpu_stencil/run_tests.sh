#!/bin/bash
# PCP Assignment #2 - 1D Stencil Multi-GPU Test Runner
# Runs all 15 test cases: 5 GridSizes x 3 NumDevices configurations

BINARY="./1d-stencil-strided"
NUM_ELEMENTS=30       # 2^30 elements
HALO_SIZE=64
THREADS_PER_BLOCK=1024
MEM_PREFETCH=1        # Always enabled

GRID_SIZES=(1024 2048 4096 8192 16384)
NUM_DEVICES=(1 2 4)

LOG_FILE="results_$(date +%Y%m%d_%H%M%S).txt"

# ── Sanity checks ────────────────────────────────────────────────────────────
if [ ! -f "$BINARY" ]; then
    echo "ERROR: Binary '$BINARY' not found. Please compile first."
    echo "  e.g.  nvcc -o 1d-stencil-strided 1d-stencil-strided.cu"
    exit 1
fi

# ── Header ───────────────────────────────────────────────────────────────────
echo "=======================================================" | tee "$LOG_FILE"
echo " PCP Assignment #2 — 1D Stencil Multi-GPU Test Suite"  | tee -a "$LOG_FILE"
echo " $(date)"                                                | tee -a "$LOG_FILE"
echo "=======================================================" | tee -a "$LOG_FILE"
echo ""                                                        | tee -a "$LOG_FILE"
echo "Fixed parameters:"                                       | tee -a "$LOG_FILE"
echo "  NumElements (exponent) : $NUM_ELEMENTS  (2^$NUM_ELEMENTS elements)" | tee -a "$LOG_FILE"
echo "  HaloSize               : $HALO_SIZE"                  | tee -a "$LOG_FILE"
echo "  ThreadsPerBlock        : $THREADS_PER_BLOCK"          | tee -a "$LOG_FILE"
echo "  MemPrefetch            : $MEM_PREFETCH (enabled)"     | tee -a "$LOG_FILE"
echo ""                                                        | tee -a "$LOG_FILE"

# ── Run all 15 test cases ────────────────────────────────────────────────────
TOTAL=$((${#GRID_SIZES[@]} * ${#NUM_DEVICES[@]}))
COUNT=0

for DEVICES in "${NUM_DEVICES[@]}"; do
    echo "=======================================================" | tee -a "$LOG_FILE"
    echo " NUM DEVICES = $DEVICES"                                  | tee -a "$LOG_FILE"
    echo "=======================================================" | tee -a "$LOG_FILE"

    for GRID in "${GRID_SIZES[@]}"; do
        COUNT=$((COUNT + 1))
        echo ""                                                                          | tee -a "$LOG_FILE"
        echo "--- Test $COUNT / $TOTAL ---"                                              | tee -a "$LOG_FILE"
        echo "  GridSize=$GRID  NumDevices=$DEVICES"                                    | tee -a "$LOG_FILE"
        echo "  Command: $BINARY $NUM_ELEMENTS $HALO_SIZE $THREADS_PER_BLOCK $GRID $MEM_PREFETCH $DEVICES" | tee -a "$LOG_FILE"
        echo ""                                                                          | tee -a "$LOG_FILE"

        # Run and capture output + exit code
        OUTPUT=$("$BINARY" "$NUM_ELEMENTS" "$HALO_SIZE" "$THREADS_PER_BLOCK" \
                            "$GRID" "$MEM_PREFETCH" "$DEVICES" 2>&1)
        EXIT_CODE=$?

        echo "$OUTPUT" | tee -a "$LOG_FILE"

        if [ $EXIT_CODE -ne 0 ]; then
            echo "  *** WARNING: non-zero exit code ($EXIT_CODE) ***" | tee -a "$LOG_FILE"
        fi

        echo "" | tee -a "$LOG_FILE"
    done
done

# ── Summary ──────────────────────────────────────────────────────────────────
echo "=======================================================" | tee -a "$LOG_FILE"
echo " All $TOTAL tests complete."                             | tee -a "$LOG_FILE"
echo " Full log saved to: $LOG_FILE"                          | tee -a "$LOG_FILE"
echo "=======================================================" | tee -a "$LOG_FILE"
