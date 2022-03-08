.POSIX:
CC = c99
CFLAGS = -I./include -std=c99 -Wall -Wextra -Wpedantic -O2 -g
LDFLAGS =
LDLIBS =
PREFIX = /usr/local

all: libsha3.a sha3sum sha3test

.SUFFIXES: .c .o
.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

libsha3.a: ./src/sha3.o
	ar rsv $@ ./src/sha3.o

sha3sum: ./src/sha3.o ./src/sha3sum.o
	$(CC) $(LDFLAGS) -o $@ ./src/sha3.o ./src/sha3sum.o $(LDLIBS)

sha3test: ./src/sha3.o ./src/sha3test.o
	$(CC) $(LDFLAGS) -o $@ ./src/sha3.o ./src/sha3test.o $(LDLIBS)

check: sha3test
	./sha3test

clean:
	rm -f ./src/*.o libsha3.a sha3sum sha3test

install:
	mkdir -p $(DESTDIR)$(PREFIX)/include \
		$(DESTDIR)$(PREFIX)/lib \
		$(DESTDIR)$(PREFIX)/bin
	install ./include/sha3.h $(DESTDIR)$(PREFIX)/include
	install -m 755 libsha3.a $(DESTDIR)$(PREFIX)/lib
	install -m 755 sha3sum $(DESTDIR)$(PREFIX)/bin

uninstall:
	rm -f \
		$(DESTDIR)$(PREFIX)/include/sha3.h \
		$(DESTDIR)$(PREFIX)/lib/libsha3.a \
		$(DESTDIR)$(PREFIX)/bin/sha3sum

.PHONY: all check clean install uninstall
