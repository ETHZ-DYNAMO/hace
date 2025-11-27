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
#define NM 8
#define N 8
#define _N 64
#define N_shift 3


void kernel_3mm(int A[_N], int B[_N], int C[_N], int D[_N], int E[_N], int F[_N], int G[_N])
{
  int i, j, k;

LOOP17:   for (i = 0; i < NI; i++)

LOOP18:     for (j = 0; j < NJ; j++)

      {
        int tmp = E[(i<<N_shift) + j];
LOOP21:         for (k = 0; k < NK; ++k)

          tmp += A[(i<<N_shift) + k] * B[(k<<N_shift) + j];
      E[(i<<N_shift) + j] = tmp;
      }

LOOP26:   for (i = 0; i < NJ; i++)

LOOP27:     for (j = 0; j < NL; j++)

      {
        int tmp = F[(i<<N_shift) + j];
LOOP30:         for (k = 0; k < NM; ++k)

          tmp += C[(i<<N_shift) + k] * D[(k<<N_shift) + j];
      F[(i<<N_shift) + j] = tmp;
      }
LOOP34:   for (i = 0; i < NI; i++)

LOOP35:     for (j = 0; j < NL; j++)

      {
        int tmp = G[(i<<N_shift) + j];
LOOP38:         for (k = 0; k < NJ; ++k)

          tmp += E[(i<<N_shift)+k] * F[(k<<N_shift) + j];
      G[(i<<N_shift) + j] = tmp;
      }

}



