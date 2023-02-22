CC=gcc

file1: Q1
	./Q1

file2: Q2
	./Q2

% : %.c
	$(CC) -o $@ $<

clean:
	rm -rf *.o
	rm -rf Q1 Q2
