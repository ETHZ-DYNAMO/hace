//------------------------------------------------------------------------
// This code is adapted from the Polybench suite
//
// http://polybench.sourceforge.net
//------------------------------------------------------------------------

#define N 32
#define _N 1024
#define N_shift 5

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

#include <stdlib.h>

void gemver(int alpha, int beta, int A[_N],
 int u1[N], int v1[N], int u2[N], int v2[N], int w[N], int x[N], int y[N], int z[N])
{
  int i, j;

LOOP20: for (i = 0; i < N; i++)

LOOP21:     for (j = 0; j < N; j++)

      A[(i<<N_shift)+j] = A[(i<<N_shift)+j] + u1[i] * v1[j] + u2[i] * v2[j];

LOOP24:   for (i = 0; i < N; i++) {

    int tmp = x[i];
LOOP26:     for (j = 0; j < N; j++)

      tmp = tmp + beta * A[(j<<N_shift)+i] * y[j];
    x[i] = tmp;
  }

LOOP31:   for (i = 0; i < N; i++)


    x[i] = x[i] + z[i];

LOOP35:   for (i = 0; i < N; i++) {

   int tmp = w[i];
LOOP37:     for (j = 0; j < N; j++)

      tmp = tmp +  alpha * A[(i<<N_shift)+j] * x[j];
    w[i] = tmp;
  }

}





