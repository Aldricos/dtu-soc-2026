#include <firmware_apis.h>
#include <stdint.h>

typedef struct {
    int byte_addr;
    int word;
} mem_init_t;



const mem_init_t wildcat_blink_test_img[] = {
    { 0x00000000, 0xF0010237 },  // lui  x4, 0xf0010
    { 0x00000004, 0x00100193 },  // addi x3, x0, 1
    { 0x00000008, 0x00322023 },  // sw   x3, 0(x4)

    // loop:
    { 0x0000000C, 0x00322023 },  // sw   x3, 0(x4)
    { 0x00000010, 0x00118193 },  // addi x3, x3, 1
    { 0x00000014, 0xFF9FF06F },  // jal  x0, -8  (to 0x0C)
};

const int wildcat_img_len =
    sizeof(wildcat_blink_test_img) / sizeof(wildcat_blink_test_img[0]);

// address of the WB instruction memory module in words
#define MEM_ADDR (0x0200000 >> 2)

void write_to_mem(int word, int addr) {
    USER_writeWord(word, MEM_ADDR + (addr >> 2));
}


void load_wildcat_program(void)
{
    for (int i = 0; i < wildcat_img_len; i++) {
        write_to_mem(
            wildcat_blink_test_img[i].word,
            wildcat_blink_test_img[i].byte_addr
        );
    }
}


void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    // Configure pin 24 as user output
    GPIOs_configure(24, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_loadConfigs();

    User_enableIF();


    // Load Wildcat instruction memory
    load_wildcat_program();

    USER_writeWord(3, MEM_ADDR + (1020 >> 2));  // releases CPU 1111111100

    // Signal testbench that setup is done
    ManagmentGpio_write(1);

    // Loop forever — Wildcat runs on its own
    while(1);
}