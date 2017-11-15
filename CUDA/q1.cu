#include <stdio.h>
#define NUM_BLOCKS 3	//Number of blocks
#define BLOCK_WIDTH 192	//number of threads in in the thread block

__global__ void hello()
{
    printf("Hello world! I'm a thread in block %d and my thread id is %d\n", blockIdx.x,threadIdx.x);
}


int main(int argc,char **argv)
{
    // launch the kernel
    hello<<<NUM_BLOCKS, BLOCK_WIDTH>>>();

    // force the printf()s to flush
    cudaDeviceSynchronize();

    printf("That's all!\n");

    return 0;
}

