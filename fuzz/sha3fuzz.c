#include "sha3.h"

#include <limits.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    static const unsigned bit_sizes[] = { 224, 256, 384, 512 };
    sha3_context c;
    const void *hash;
    uint8_t expected[512 / 8];
    uint8_t scratch[512 / 8];
    uint8_t control;
    unsigned bit_size;
    enum SHA3_FLAGS flags;
    size_t offset;

    if( Size < 1 || Size - 1 > UINT_MAX )
        return 0;

    control = Data[0];
    Size--;
    Data++;

    bit_size = bit_sizes[control & 3];
    flags = (control & (1 << 2)) ? SHA3_FLAGS_KECCAK : SHA3_FLAGS_NONE;

    if( sha3_HashBuffer(bit_size, flags, Data, (unsigned)Size, expected,
                sizeof(expected)) != SHA3_RETURN_OK )
        abort();

    switch(control & 3) {
        case 0:
            sha3_Init224(&c);
            break;
        case 1:
            sha3_Init256(&c);
            break;
        case 2:
            sha3_Init384(&c);
            break;
        default:
            sha3_Init512(&c);
            break;
    }

    if( sha3_SetFlags(&c, flags) != flags )
        abort();

    offset = 0;
    switch((control >> 3) & 3) {
        case 0:
            sha3_Update(&c, Data, Size);
            break;
        case 1:
            while( offset < Size )
                sha3_Update(&c, Data + offset++, 1);
            break;
        case 2:
            while( offset < Size ) {
                size_t chunk = Size - offset < 7 ? Size - offset : 7;
                sha3_Update(&c, Data + offset, chunk);
                offset += chunk;
            }
            break;
        default:
            while( offset < Size ) {
                size_t chunk = 1 + Data[offset] % 151;
                if( chunk > Size - offset )
                    chunk = Size - offset;
                sha3_Update(&c, Data + offset, chunk);
                offset += chunk;
            }
            break;
    }

    hash = sha3_Finalize(&c);
    if( memcmp(hash, expected, bit_size / 8) != 0 )
        abort();

    if( (control & (1 << 7)) && Size >= 2 )
        sha3_HashBuffer((unsigned)Data[0] << 1,
                (enum SHA3_FLAGS)Data[1], Data + 2, (unsigned)Size - 2,
                scratch, sizeof(scratch));

    return 0;
}
