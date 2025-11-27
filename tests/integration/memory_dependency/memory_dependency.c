int memory_dependency(int value, int *addr) {
	addr[0] = value;
	return addr[0];
}
