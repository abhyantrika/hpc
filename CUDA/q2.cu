#include <iostream>
#include <math.h>
#include <stdio.h>

__global__
void add(double *a,double*b,double* c,int n) {

    int id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id>0)
        c[id] = a[id] + b[id];

}

int main()
{

   int n = 100;

 // Device input vectors
    double *d_a;
    double *d_b;
    //Device output vector
    double *d_c;
 
    int i=0;

    cudaMallocManaged(&d_a,n*sizeof(double));
    cudaMallocManaged(&d_b,n*sizeof(double));
    cudaMallocManaged(&d_c,n*sizeof(double));

     for ( i = 0; i < n; i++) {
        d_a[i] = i;
        d_b[i] = i;
      }


    int blockSize = 512;
    // Number of thread blocks in grid
    int gridSize = (int)ceil((float)n/blockSize);

    add <<< gridSize,blockSize >>>(d_a,d_b,d_c,n);
        cudaDeviceSynchronize();

     printf("%d  %d\n",gridSize,blockSize );   

     for(i=0;i<n;i++)
     {
        printf("%f + %f = %f\n",d_a[i],d_b[i],d_c[i]);
     }  

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
     


    /*float maxError = 0.0f;
    for (int i = 0; i < n; i++)
    maxError = fmax(maxError, fabs(d_c[i]-3.0f));
    std::cout << "Max error: " << maxError << std::endl;*/

}
