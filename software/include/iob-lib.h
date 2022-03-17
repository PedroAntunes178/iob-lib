#ifndef PC
//memory access macros
#define MEM_SET(type, location, value) (*((type*) (location)) = (value) )
#define MEM_GET(type, location)        (*((type*) (location)))

//stream access macros
#define IO_SET(base, location, value) (*((volatile int*) ( (base) + (sizeof(int)) * (location) )) = (value) )
#define IO_GET(base, location)        (*((volatile int*) ( (base) + (sizeof(int)) * (location) )))
#else // ifdef PC
//memory access functions
static void MEM_SET(int type, int location, int value);
static int MEM_GET(int type, int location);

//stream access functions
static void IO_SET(int base, int location, int value);
static int IO_GET(int base, int location);
#endif

