#define A_ROWS 32
#define A_COLS 32
#define B_ROWS 32
#define B_COLS 32

#include <stdlib.h>
#include <stdio.h>

#define TOT_DIM 1024

#define N_SHIFT 5

// matrix multiplication of a A*B matrix
void matrix (int in_a[TOT_DIM], int in_b[TOT_DIM], int out_c[TOT_DIM])
{
    int i,j,k;
    loop1: for (i = 0; i < A_ROWS; i++)
    {
        loop2: for (j = 0; j < B_COLS; j++)
        {
            int sum_mult = 0;
            loop3: for (k = 0; k < A_COLS; k++)
            {
                sum_mult += in_a[(i<<N_SHIFT)+k] * in_b[(k<<N_SHIFT)+j];
            }
            out_c[(i<<N_SHIFT)+j] = sum_mult;
        }
    }
}

