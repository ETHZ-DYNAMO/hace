//------------------------------------------------------------------------
// This code is adapted from the Polybench suite
//
// http://polybench.sourceforge.net
//------------------------------------------------------------------------

#define N 32
#define N_int 32
#define _N 1024
#define N_shift 5

#include <stdlib.h>
#include <stdio.h>
#include <math.h>


void covariance(int data[_N], int symmat [_N], int mean[N])
{
  int i, j, j1, j2;
  int int_n = N_int;

  /* Determine mean of column vectors of input data matrix */
LOOP20:      for (j = 0; j < N; j++)

    {
      int x = 0;
LOOP23:       for (i = 0; i < N; i++)

         x += data[(i<<N_shift) + j];
      mean[j] = x/int_n;
    }

  /* Center the column vectors. */
LOOP29:   for (i = 0; i < N; i++)

LOOP30:     for (j = 0; j < N; j++)

      data[(i<<N_shift) + j] -= mean[j];

  /* Calculate the m * m covariance matrix. */
LOOP34:   for (j1 = 0; j1 < N; j1++)

LOOP35:     for (j2 = j1; j2 < N; j2++)

      {
        int x = 0;
LOOP38:         for (i = 0; i < N; i++)

	         x += data[(i<<N_shift) + j1] * data[(i<<N_shift) + j2];

        symmat[(j1<<N_shift) + j2] = x;
        symmat[(j2<<N_shift) + j1] = x;
      }
}






