/* -------------------------------------------------------------------------
 * Run SHA-3 (NIST FIPS 202) on the given file. 
 *
 * Call as
 *
 * sha3sum 224|256|384|512 file_path
 *
 * See sha3.c for additional details. 
 *
 * Jun 2018. Andrey Jivsov. crypto@brainhub.org
 * ---------------------------------------------------------------------- */

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

#include "sha3.h"

static void help(const char *argv0) {
    printf("To call: %s 224|256|384|512 [-k] file_path.\n", argv0);
}

static void byte_to_hex(uint8_t b, char s[3]) {
    unsigned i=1;
    s[0] = s[1] = '0';
    s[2] = '\0';
    while(b) {
        unsigned t = b & 0x0f;
        if( t < 10 ) {
            s[i] = '0' + t;
        } else {
            s[i] = 'a' + t - 10;
        }
        i--;
        b >>= 4;
    }
}

int main(int argc, char *argv[])
{
    sha3_context c;
    const uint8_t *hash;
    unsigned image_size;
    const char *file_path;
    int fd;
    uint8_t buffer[32768];
    ssize_t bytes_read;
    unsigned i;
    unsigned use_keccak = 0;
    char *end;
    unsigned long parsed_size;

    if( argc != 3 && argc != 4 ) {
	    help(argv[0]);
	    return 1;
    }

    errno = 0;
    parsed_size = strtoul(argv[1], &end, 10);
    if( errno == ERANGE || end == argv[1] || *end != '\0' ||
            parsed_size > UINT_MAX ) {
        help(argv[0]);
        return 1;
    }
    image_size = (unsigned)parsed_size;
    switch( image_size ) {
	case 224:
	case 256:
	case 384:
	case 512:
		break;
	default:
		help(argv[0]);
		return 1;
    }

    file_path = argv[2];

    if( argc == 4 && strcmp(file_path, "-k") == 0 )  {
        use_keccak = 1;
        file_path = argv[3];
    }
    else if( argc == 4 ) {
        help(argv[0]);
        return 1;
    }

    fd = open(file_path, O_RDONLY);
    if( fd == -1 ) {
	    fprintf(stderr, "Cannot open file '%s' for reading: %s\n",
                    file_path, strerror(errno));
	    return 2;
    }

    if( sha3_Init(&c, image_size) != SHA3_RETURN_OK ) {
        close(fd);
        fprintf(stderr, "Failed to initialize SHA3-%u\n", image_size);
        return 2;
    }

    if( use_keccak ) {
        enum SHA3_FLAGS flags2 = sha3_SetFlags(&c, SHA3_FLAGS_KECCAK);
        if( flags2 != SHA3_FLAGS_KECCAK )  {
	    fprintf(stderr, "Failed to set Keccak mode\n");
            close(fd);
            return 2;
        }
    }

    while( (bytes_read = read(fd, buffer, sizeof(buffer))) > 0 )
        sha3_Update(&c, buffer, (size_t)bytes_read);
    if( bytes_read < 0 ) {
        fprintf(stderr, "Cannot read file '%s': %s\n", file_path,
                strerror(errno));
        close(fd);
        return 2;
    }
    if( close(fd) != 0 ) {
        fprintf(stderr, "Cannot close file '%s': %s\n", file_path,
                strerror(errno));
        return 2;
    }

    hash = sha3_Finalize(&c);

    for(i=0; i<image_size/8; i++) {
	    char s[3];
	    byte_to_hex(hash[i],s);
	    printf("%s", s);
    }
    printf("  %s\n", file_path);

    return 0;
}
