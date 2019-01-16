CC=gcc
INSTALL=install
prefix=/usr/local
CFLAGS=-Wall -ggdb -O2 -I.
LDFLAGS=

.PHONY : all test clean 

all: sha3test sha3sum

sha3.o: sha3.c
	$(CC) -c $(CFLAGS) -o $@ $<

sha3test.o : sha3test.c
	$(CC) -c $(CFLAGS) -o $@ $<

sha3sum.o : sha3sum.c
	$(CC) -c $(CFLAGS) -o $@ $<

sha3test: sha3.o sha3test.o
	$(CC) -o $@ $^ ${LDFLAGS}

test: sha3test
	./sha3test

sha3sum: sha3.o sha3sum.o 
	$(CC) -o $@ $^ ${LDFLAGS}

clean:
	-rm -f *.o sha3test
