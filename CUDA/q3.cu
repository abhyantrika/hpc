#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

#define N 3 // dim of matrix


//Fattened matrix multiplication . Kernel does not support x,y addressing
__global__ void mat_multiply(int* d_mat1, int* d_mat2, int* d_mat3, int width)
{
	int k,sum=0;
	int col = blockDim.x * blockIdx.x + threadIdx.x;
	int row = blockDim.y * blockIdx.y + threadIdx.y;

	if(row<width && col<width)
	{
		for(k=0;k<width;k++)
		{
			sum += d_mat1[row*width+k] * d_mat2[k*width+col];
		}
		d_mat3[row*width+col] = sum;
	}

}

int main()
{
	int i,j;
	int SIZE = N*N;
	//int BYTES = SIZE*sizeof(int);

	int *d_mat1, *d_mat2, *d_mat3;

	// allocate memory on the device
	cudaMallocManaged(&d_mat1,N*N*sizeof(int));
	cudaMallocManaged(&d_mat2,N*N*sizeof(int));
	cudaMallocManaged(&d_mat3,N*N*sizeof(int));

	// generate matrix on host
	for(i=0;i<N*N;i++) //linearize array
	{
			d_mat1[i] = 1;
			d_mat2[i] = 1;
			d_mat3[i] = 0;

	}

	dim3 dimGrid(1,1);
	dim3 dimBlock(N,N);

	// lauch kernel
	mat_multiply<<<dimGrid,dimBlock>>>(d_mat1,d_mat2,d_mat3,N);
	cudaDeviceSynchronize();

	for(i=0;i<N*N;i++)
	{
		
		printf("%d ",d_mat3[i]);
		if(i%N==0 && i>N)
			printf("\n");
	}
	printf("\n");
}