//------------------------------------------------------------------------
// This code is adapted from the Polybench suite
//
// http://polybench.sourceforge.net
//------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>

#define N 32
#define _N 1024
#define N_shift 5


void mvt(int A[_N], int x1[N], int x2[N], int y1[N], int y2[N])
{
   int i, j, k;

LOOP16:    for (i = 0; i < N; i++) {

   	int tmp = x1[i];
LOOP18:     for (j = 0; j < N; j++)

      tmp = tmp + A[(i<<N_shift) + j] * y1[j];
    x1[i] = tmp;
	}

LOOP23:   for (i = 0; i < N; i++) {

  	int tmp = x2[i];
LOOP25:     for (j = 0; j < N; j++)

      tmp = tmp + A[(j<<N_shift) + i] * y2[j];
  	x2[i] = tmp;
	}
}
