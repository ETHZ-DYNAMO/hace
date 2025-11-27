#include <stdio.h>
#include <stdlib.h>

#define AMOUNT_OF_TEST 1

int test_args(int input_a, int input_b, int input_c) {

  int result;
  result = (input_a*3) + input_b - input_c;
  return result;
}

