//------------------------------------------------------------------------
// This code is adapted from the work of Jianyi Cheng
// "Combining Dynamic & Static Scheduling in High-level Synthesis"
//
// https://zenodo.org/record/3561115
//------------------------------------------------------------------------


#include <stdlib.h>
#include <stdio.h>


int gsum (int a[1000]) {
        int i;
        int d;
        int s= 0;

LOOP19:         for (i=0; i<1000; i++){

        #pragma HLS PIPELINE
        d = a[i];
              if (d >= 4)

              s += (((((d+(int)3)*d+(int)5)*d+(int)7)*d+(int)12)*d);

    }
return s;
}



