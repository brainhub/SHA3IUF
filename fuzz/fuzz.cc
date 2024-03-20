#include "sha3iuf/sha3.h"

int LLVMFuzzerTestOneInput(const uint8_t *Data, uint32_t Size) {
	sha3_context c;
	uint8_t b;
	uint8_t buf[512/8];
	unsigned is_keccak;

	if( Size < 1 )
		return 0;

	b = Data[0];
	Size --;
	Data ++;

	is_keccak = b & (1<<2);
	enum SHA3_FLAGS flags = (enum SHA3_FLAGS)(Data[1]);

	switch(b & 3) {
		case 0:
			sha3_Init256(&c);
			break;
		case 1:
			sha3_Init384(&c);
			break;
		case 2:
			sha3_Init512(&c);
			break;
		case 3:
			if(Size >= 2)
				sha3_HashBuffer((unsigned)Data[0] << 1,
						flags/*SHA3_FLAGS_KECCAK or NONE*/,
						Data + 2, Size-2, buf, sizeof(buf));
			return 0;
	}

	if( is_keccak )
		sha3_SetFlags( &c, SHA3_FLAGS_KECCAK );

	sha3_Update(&c, Data, Size);
	sha3_Finalize(&c);

	return 0;
}
