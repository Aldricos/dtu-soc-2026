#include <firmware_apis.h>
#include <stdint.h>

#define IMEM_BASE (0x0200000 >> 2)   // instruction memory base (word addr)

#define TEST_WORDS 10//2048               // full 8KB = 2048 words

uint32_t test_pattern(uint32_t i) {
    return 0xA5A50000 | i;          // recognizable pattern
}

void main(void)
{
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);          // 0 = busy / fail default
    enableHkSpi(0);

    User_enableIF();

    // ------------------------------------------------
    // WRITE PHASE
    // ------------------------------------------------
    for (uint32_t i = 0; i < TEST_WORDS; i++) {
        USER_writeWord(test_pattern(i), IMEM_BASE + i);
    }

    // ------------------------------------------------
    // READ + VERIFY PHASE
    // ------------------------------------------------
    int result = 0;
    for (uint32_t i = 0; i < TEST_WORDS; i++) {
        uint32_t val = USER_readWord(IMEM_BASE + i);
        if (val != test_pattern(i)) {
            result = 1;
            break;
        }
    }
    if (result == 0) {
        // indicate success by setting managment gpio high
        ManagmentGpio_write(1);
    } // else do nothing and let the testbench timeout

    return;
}
