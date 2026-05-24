#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<stdbool.h>
#include<math.h>
#include<cuda.h>
#include<cuda_runtime.h>
#define TPB 1024
#define HALO 64

typedef unsigned long long ticks;

__global__ void stencil(int *x, int *y, int N, int gndx, int chunk_size){
    int stride = gridDim.x * blockDim.x; // block strides within a chunk
    int cindex = blockIdx.x * blockDim.x + threadIdx.x; // where in chunk I am
    int lindex = threadIdx.x + HALO; // where in block I am
    __shared__ int shared[TPB + 2*HALO];

    for (; cindex < chunk_size; cindex += stride){
        int gindex = cindex + gndx; // global position
        shared[lindex] = x[gindex]; // Load center value
        
        // Load halos (first halo threads handle this)
        if (threadIdx.x < HALO) {
            // Left HALO
            int left_index = gindex - HALO;
            if (left_index < 0) {
                shared[threadIdx.x] = 0;
            } else {
                shared[threadIdx.x] = x[left_index];
            }
            
            // Right HALO
            int right_index = gindex + blockDim.x;
            if (right_index < N) {
                shared[lindex + blockDim.x] = x[right_index];
            } else {
                shared[lindex + blockDim.x] = 0;
            }
        }
        // Compute stencil
        __syncthreads();
        int result = 0;
        for (int offset = -HALO; offset <= + HALO; offset++){
            result += shared[lindex + offset];
        }
        y[gindex] = result;
        __syncthreads();
    }
    
    __syncthreads();
}

// IBM POWER9 System clock with 512MHZ resolution.
static __inline__ ticks getticks(void)
{
//   struct timespec ts;
//   clock_gettime(CLOCK_MONOTONIC, &ts);
//   return (ticks)ts.tv_sec*1000000000ULL + ts.tv_nsec;
// } /*
  unsigned int tbl, tbu0, tbu1;

  do {
    __asm__ __volatile__ ("mftbu %0" : "=r"(tbu0));
    __asm__ __volatile__ ("mftb %0" : "=r"(tbl));
    __asm__ __volatile__ ("mftbu %0" : "=r"(tbu1));
  } while (tbu0 != tbu1);

  return (((unsigned long long)tbu0) << 32) | tbl;
} //*/

static __inline__ bool validate(int *out, int N){
    for (unsigned int i = 0; i < N; i++){
        if (i < HALO){
            if (out[i] != 1+HALO+i){
                printf("Error found. Expected %d, but encountered %d, at index %d\n", 1+HALO+i, out[i], i);
                return false; 
            }
        }
        else if (i >= (N - HALO)){
            if (out[i] != N - i + HALO){
                printf("Error found. Expected %d, but encountered %d, at index %d\n", N - i + HALO, out[i], i);
                return false;
            }
        }
        else if (out[i] != 2*HALO + 1){
            printf("Error found. Expected %d, but encountered %d, at index %d\n", N - i + HALO + 1, out[i], i);
            return false;
        }
    }
    return true;
}

int main(int argc, char ** argv){

    // collect inputs
    if (argc != 7){
        fprintf(stderr, "Incorrect number of arguments\n");
        return EXIT_FAILURE;
    }
    printf("Beginning execution\n");
    int NumElements = 30;
    // int halo = 64;
    // int TpB = 1024;
    int numBlocks = atoi(argv[4]);
    // int MemPrefetch = 1;
    int NumDevices = atoi(argv[6]);

    // allocate memory
    unsigned int N = 1<<NumElements;
    int chunk_size = N / NumDevices;

    int *y; int *x;
    cudaMallocManaged(&y, N*sizeof(int));
    cudaMallocManaged(&x, N*sizeof(int));
    for (unsigned int i = 0; i < N; i++){
        x[i] = 1;
    }

    // loop over GPUs, set device, prefetch chunk gpu is about to process, call kernel
    ticks start = getticks();
    for (unsigned int device = 0; device < NumDevices; device++){
        int gndx = device*chunk_size;
        cudaSetDevice(device);
        int begin, size;
        // ensure device has access to neighboring halos
        if (device == 0){
            begin = 0;
            size = chunk_size + HALO;
        } else if (device == NumDevices - 1){
            begin = gndx - HALO;
            size = chunk_size + HALO;
        } else {
            begin = gndx - HALO;
            size = chunk_size + 2*HALO;
        }
        cudaMemPrefetchAsync(&x[begin], size*sizeof(int), device);
        cudaMemPrefetchAsync(&y[gndx], chunk_size*sizeof(int), device);
        stencil <<<numBlocks, TPB>>>(x, y, N, gndx, chunk_size);
    }
    cudaDeviceSynchronize();
    ticks end = getticks();

    // Calculate elapsed time
    ticks elapsed = end - start;
    double seconds = (double)elapsed / 512000000.0;
    // double seconds = (double)elapsed / 1000000000.0;

    // Print
    printf("Execution time: %llu ticks\n", elapsed);
    printf("Execution time: %.6f seconds\n", seconds);
    
    if (validate(y, N)){
        printf("SUCCESS");
    }
    else{
        printf("FAIL");
    }

    cudaFree(x);
    cudaFree(y);
    return 0;   
}