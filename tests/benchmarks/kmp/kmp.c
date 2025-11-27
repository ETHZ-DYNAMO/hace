#include <stdio.h>



#include <stdlib.h>

#define PATTERN_SIZE 4
#define STRING_SIZE 1000

int kmp(int pattern[PATTERN_SIZE], int input[STRING_SIZE], int kmpNext[PATTERN_SIZE]) {
    int i, q;
    int n_matches = 0;

    int k;
    k = 0;
    kmpNext[0] = 0;

    loop1: for(q = 1; q < PATTERN_SIZE; q++){
    	int tmp = pattern[q];
        loop2: while(k > 0 && pattern[k] != tmp){
            k = kmpNext[q];
        }
        if(pattern[k] == tmp){
            k++;
        }
        kmpNext[q] = k;
    }

    q = 0;
    loop3: for(i = 0; i < STRING_SIZE; i++){
    	int tmp = input[i];
        loop4: while (q > 0 && pattern[q] != tmp){
            q = kmpNext[q];
        }
        if (pattern[q] == tmp){
            q++;
        }
        if (q >= PATTERN_SIZE){
            n_matches++;
            q = kmpNext[q - 1];
        }
    }
    return n_matches;
}

