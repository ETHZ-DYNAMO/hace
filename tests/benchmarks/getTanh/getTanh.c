#include <stdio.h>
//------------------------------------------------------------------------
// This code is adapted from the work of Jianyi Cheng
// "Combining Dynamic & Static Scheduling in High-level Synthesis"
//
// https://zenodo.org/record/3561115
//------------------------------------------------------------------------


#include <stdlib.h>

void getTanh (int A[1000], int addr[1000]){
	int i;
 	int result, beta; 

LOOP16:  	for (i=0; i<1000; i++){

 		
 		int address = addr[i];
 		beta = A[address];

 		if (beta >=(int)1){
 			result = (int)1;
 		}
 		else {
 			result = ((beta*beta+(int)19)*beta*beta + (int)3)*beta;
 		}
 		A[address] = result;
 	}

}


