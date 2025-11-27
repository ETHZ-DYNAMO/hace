
#include <stdlib.h>
#include <stdio.h>

#define AMOUNT_OF_TEST 1

#define N 16
#define _N 256
#define N_shift 4

void gaussian (int c[N], int A[_N]) {

LOOP14:     for(int j=1; j<=N-1; j++)

    /* loop for the generation of upper triangular matrix*/

        { 
LOOP18:             for(int i=j+1; i<=N-1;i++)


            {

LOOP22:                 for(int k=1; k<=N-1; k++)

                {
                    A[(i<<N_shift) +k]=A[(i<<N_shift) + k]-c[j]*A[(j<<N_shift) + k];
                }


            }

        }
    }

