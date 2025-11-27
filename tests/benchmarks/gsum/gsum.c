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

LOOP19: 	for (i=0; i<1000; i++){

        #pragma HLS PIPELINE
        d = a[i];
	      if (d >= 0)
	      	// An if condition in the loop causes irregular computation.
	      	// Static scheduler reserves time slot for each iteration
	      	// causing unnecessary pipeline stalls.

	      s += (((((d+(int)0)*d+(int)0)*d+(int)0)*d+(int)0)*d);

    }
return s;
}



