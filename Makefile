.POSIX:
CC = cc
AR = ar
ARFLAGS = rsv
CFLAGS = -std=c99 -Wall -Wextra -Wpedantic -O2 -g
LDFLAGS =
LDLIBS =
FUZZ_CC = clang
FUZZ_CFLAGS = -std=c99 -g -O1 -fsanitize=fuzzer,address,undefined
PREFIX = /usr/local

all: libsha3.a sha3sum sha3test

.SUFFIXES: .c .o
.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

sha3.o sha3sum.o sha3test.o: sha3.h

libsha3.a: sha3.o
	$(AR) $(ARFLAGS) $@ sha3.o

sha3sum: sha3.o sha3sum.o
	$(CC) $(LDFLAGS) -o $@ sha3.o sha3sum.o $(LDLIBS)

sha3fuzz: sha3.c fuzz/sha3fuzz.c
	$(FUZZ_CC) $(FUZZ_CFLAGS) -I . -o $@ sha3.c fuzz/sha3fuzz.c

sha3fuzztest: sha3.o sha3fuzz.o sha3fuzztest.o
	$(CC) $(LDFLAGS) -o $@ sha3.o sha3fuzz.o sha3fuzztest.o $(LDLIBS)

sha3fuzz.o: fuzz/sha3fuzz.c sha3.h
	$(CC) -c $(CFLAGS) -I . -o $@ fuzz/sha3fuzz.c

sha3fuzztest.o: tests/sha3fuzztest.c
	$(CC) -c $(CFLAGS) -I . -o $@ tests/sha3fuzztest.c

sha3test: sha3.o sha3test.o
	$(CC) $(LDFLAGS) -o $@ sha3.o sha3test.o $(LDLIBS)

check: sha3test sha3sum sha3fuzztest
	./sha3test
	./tests/sha3sumtest.sh ./sha3sum
	./sha3fuzztest

test: check

clean:
	rm -f *.o libsha3.a sha3sum sha3test sha3fuzz sha3fuzztest

install: libsha3.a sha3sum
	mkdir -p $(DESTDIR)$(PREFIX)/include \
		$(DESTDIR)$(PREFIX)/lib \
		$(DESTDIR)$(PREFIX)/bin
	install -m 644 sha3.h $(DESTDIR)$(PREFIX)/include
	install -m 644 libsha3.a $(DESTDIR)$(PREFIX)/lib
	install -m 755 sha3sum $(DESTDIR)$(PREFIX)/bin

uninstall:
	rm -f \
		$(DESTDIR)$(PREFIX)/include/sha3.h \
		$(DESTDIR)$(PREFIX)/lib/libsha3.a \
		$(DESTDIR)$(PREFIX)/bin/sha3sum

.PHONY: all check test clean install uninstall
