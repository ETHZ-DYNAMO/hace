//------------------------------------------------------------------------
// This code is adapted from the Polybench suite
//
// http://polybench.sourceforge.net
//------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>

#define NI 8
#define NJ 8
#define NK 8
#define NL 8
#define N 8
#define N_shift 3
#define _N 64

void kernel_2mm(int alpha, int beta, int tmp[_N], int A[_N], int B[_N], int C[_N], int D[_N])
{
  int i, j, k;

LOOP15:   for (i = 0; i < NI; i++)

LOOP16:     for (j = 0; j < NJ; j++)

      {
        int x = tmp[(i<< N_shift) + j];
LOOP19:         for (k = 0; k < NK; ++k)

          x += alpha * A[(i<< N_shift) + k] * B[(k<<N_shift) + j];
        tmp[(i<<N_shift) + j] = x;
      }
LOOP23:   for (i = 0; i < NI; i++)

LOOP24:     for (j = 0; j < NL; j++)

      {
        int x = D[(i<<N_shift) + j]*beta;

LOOP28:         for (k = 0; k < NJ; ++k)

          x += tmp[(i<<N_shift) + k] * C[(k<<N_shift) + j];
        D[(i<<N_shift) + j] = x;
      }
}


