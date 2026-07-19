#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size);

int main(void) {
    static const size_t message_sizes[] = {
        0, 1, 7, 8, 143, 144, 145, 200, 512
    };
    uint8_t input[513];
    unsigned control;
    size_t i;
    size_t j;

    for( control = 0; control <= UINT8_MAX; control++ ) {
        input[0] = (uint8_t)control;
        for( i = 0; i < sizeof(message_sizes) / sizeof(message_sizes[0]); i++ ) {
            for( j = 0; j < message_sizes[i]; j++ )
                input[j + 1] = (uint8_t)(j * 37 + control);
            LLVMFuzzerTestOneInput(input, message_sizes[i] + 1);
        }
    }

    printf("Fuzz differential tests passed OK\n");
    return 0;
}
