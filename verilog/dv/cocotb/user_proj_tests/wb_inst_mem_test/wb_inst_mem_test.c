#include <firmware_apis.h>
#include <stdint.h>

#define IMEM_BASE (0x0200000 >> 2)   // instruction memory base

#define TEST_WORDS 16

uint32_t test_pattern(uint32_t i) {
    return 0xA5A50000 | i;          // recognizable pattern
}

void main(void)
{
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    User_enableIF();

    // WRITE PHASE
    for (uint32_t i = 0; i < TEST_WORDS; i++) {
        USER_writeWord(test_pattern(i), IMEM_BASE + i);
    }

    // READ + VERIFY PHASE
    bool fail = false;
    for (uint32_t i = 0; i < TEST_WORDS; i++) {
        uint32_t val = USER_readWord(IMEM_BASE + i);
        if (val != test_pattern(i)) {
            fail = true;
            break;
        }
    }
    if (fail == false) {
        ManagmentGpio_write(1);
    } // if fail is still false then pass the test, else do nothing and let the testbench timeout

    return;
}
