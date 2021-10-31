void memory_copy(char* source, char* dest, int num_of_bytes) {
  for(int i = 0; i < num_of_bytes; ++i)
	  *(dest + i) = *(source + i);
}
