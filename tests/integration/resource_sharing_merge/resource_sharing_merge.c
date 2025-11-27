
int resource_sharing_merge(int arg_A, int arg_B, int arg_C)
{
	if(arg_A == 0) {
		return arg_C + arg_B;
	}else{
		return arg_A + 1;
	}
}
