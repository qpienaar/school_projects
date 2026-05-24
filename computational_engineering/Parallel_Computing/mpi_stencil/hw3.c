#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<stdbool.h>
#include<math.h>
#include <mpi.h>

typedef unsigned long long ticks;

// IBM POWER9 System clock with 512MHZ resolution.
static __inline__ ticks getticks(void)
{
  unsigned int tbl, tbu0, tbu1;

  do {
    __asm__ __volatile__ ("mftbu %0" : "=r"(tbu0));
    __asm__ __volatile__ ("mftb %0" : "=r"(tbl));
    __asm__ __volatile__ ("mftbu %0" : "=r"(tbu1));
  } while (tbu0 != tbu1);

  return (((unsigned long long)tbu0) << 32) | tbl;
}

static void serial_stencil(const int *x, int *y, long N, int halo)
{
    for (long i = 0; i < N; i++) {
        int result = 0;
        for (int off = -halo; off <= halo; off++) {
            long j = i + off;
            result += (j >= 0 && j < N) ? x[j] : 0;
        }
        y[i] = result;
    }
}

static __inline__ bool validate(int *out, int N, int halo){
    for (unsigned int i = 0; i < N; i++){
        if (i < halo){
            if (out[i] != 1+halo+i){
                printf("Error found. Expected %d, but encountered %d, at index %d\n", 1+halo+i, out[i], i);
                return false; 
            }
        }
        else if (i >= (N - halo)){
            if (out[i] != N - i + halo){
                printf("Error found. Expected %d, but encountered %d, at index %d\n", N - i + halo, out[i], i);
                return false;
            }
        }
        else if (out[i] != 2*halo + 1){
            printf("Error found. Expected %d, but encountered %d, at index %d\n", N - i + halo + 1, out[i], i);
            return false;
        }
    }
    return true;
}

int main(int argc, char ** argv){

    // initialize MPI environment
    MPI_Init(&argc, &argv);

    int rank, num_ranks;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &num_ranks);

    if (argc != 4) {
        if (rank == 0)
            fprintf(stderr, "Usage: %s NumElements HaloSize Serial(0/1)\n", argv[0]);
        MPI_Finalize();
        return EXIT_FAILURE;
    }

    int NumElements = atoi(argv[1]);
    int halo = atoi(argv[2]);
    int do_serial = atoi(argv[3]);

    long N = 1L <<NumElements;
    long chunk_size = N / num_ranks;

    // rank 0 allocates and initializes arrays
    int *x = NULL; int *y = NULL;
    if (rank == 0){
        x = (int *)malloc(N*sizeof(int));
        y = (int *)malloc(N*sizeof(int));

        for (long i = 0; i < N; i++){
            x[i] = 1;
        }
    }
    if (rank == 0){
        printf("Beginning execution: N=%ld (2^%d), HaloSize=%d, Ranks=%d, Serial=%d\n", N, NumElements, halo, num_ranks, do_serial);
    }

    long buf_size = chunk_size + 2*halo;
    int *localx = (int *)calloc(buf_size, sizeof(int)); // create local array with all zeros
    int *localy = (int *)malloc(chunk_size*sizeof(int));

    MPI_Barrier(MPI_COMM_WORLD);
    ticks start;
    if (rank == 0){
        start = getticks();
    }

    MPI_Scatter(x, (int)chunk_size, MPI_INT, localx + halo, (int)chunk_size, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Request reqs[4];
    int nreqs = 0;

    // recv first
    if (rank > 0) {
        MPI_Irecv(localx, halo, MPI_INT, rank - 1, 0, MPI_COMM_WORLD, &reqs[nreqs++]);
    }
    if (rank < num_ranks - 1){
        MPI_Irecv(localx + halo + chunk_size, halo, MPI_INT, rank+1, 1, MPI_COMM_WORLD, &reqs[nreqs++]);
    }
    
    // then send
    if (rank > 0){
        // send left edge to rank-1
        MPI_Isend(localx+halo, halo, MPI_INT, rank-1, 1, MPI_COMM_WORLD, &reqs[nreqs++]);
    }
    if (rank < num_ranks - 1){
        // send right edge to rank+1
        MPI_Isend(localx + chunk_size, halo, MPI_INT, rank+1, 0, MPI_COMM_WORLD, &reqs[nreqs++]);
    }
    MPI_Waitall(nreqs, reqs, MPI_STATUSES_IGNORE);

    // compute stencil
    for (long i = 0; i < chunk_size; i++){
        int result = 0;
        for (int offset = -halo; offset <= halo; offset++){
            result += localx[halo+i+offset];
        }
        localy[i] = result;
    }

    MPI_Gather(localy, (int)chunk_size, MPI_INT, y, (int)chunk_size, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0){
        ticks end = getticks();

        // Calculate elapsed time
        ticks elapsed = end - start;
        double seconds = (double)elapsed / 512000000.0;

        // Print MPI results
        printf("MPI Execution time: %.6f seconds\n", seconds);
        
        // Validate MPI result
        if (validate(y, N, halo)){
            printf("MPI SUCCESS\n");
        } else {
            printf("MPI FAIL\n");
        }

        // Optional serial run
        if (do_serial) {
            int *y_serial = (int *)malloc(N * sizeof(int));

            ticks serial_start = getticks();
            serial_stencil(x, y_serial, N, halo);
            ticks serial_end_t = getticks();
            ticks serial_elapsed = serial_end_t - serial_start;
            double serial_secs = (double)serial_elapsed / 512000000.0;

            printf("Serial Execution time: %.6f seconds\n", serial_secs);
            printf("Speedup (serial / MPI): %.2fx\n", (double)serial_elapsed / (double)elapsed);

            // Validate serial result
            if (validate(y_serial, N, halo)){
                printf("Serial SUCCESS\n");
            } else {
                printf("Serial FAIL\n");
            }

            free(y_serial);
        }

        free(x);
        free(y);
    } 

    free(localx);
    free(localy);
 
    MPI_Finalize();
    return 0;
}