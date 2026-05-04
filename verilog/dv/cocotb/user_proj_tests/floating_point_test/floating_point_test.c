#include <firmware_apis.h>
#include <stdint.h>

typedef struct {
    int byte_addr;
    int word;
} mem_init_t;

// apps/floating_point.s
const mem_init_t floating_point_test_img[] = {
    { 0x00000000, 0xf0040437 },
    { 0x00000004, 0x400f24b7 },
    { 0x00000008, 0xbbd48493 },
    { 0x0000000C, 0x3f800937 },
    { 0x00000010, 0x3f0009b7 },
    { 0x00000014, 0x00000293 },
    { 0x00000018, 0x00942023 },
    { 0x0000001C, 0x01242223 },
    { 0x00000020, 0x00542423 },
    { 0x00000024, 0x01042a03 },
    { 0x00000028, 0x020a0463 },
    { 0x0000002C, 0x00200293 },
    { 0x00000030, 0x01342023 },
    { 0x00000034, 0x01442223 },
    { 0x00000038, 0x00542423 },
    { 0x0000003C, 0x01042483 },
    { 0x00000040, 0x00048863 },
    { 0x00000044, 0xc0000437 },
    { 0x00000048, 0x00942023 },
    { 0x0000004C, 0x0000006f },
    { 0x00000050, 0x00100493 },
    { 0x00000054, 0xff1ff06f },
};

const int wildcat_img_len =
    sizeof(floating_point_test_img) / sizeof(floating_point_test_img[0]);

// address of the WB instruction memory module in words
#define MEM_ADDR (0x0200000 >> 2)
#define COMM_CTRL (0x400000 >> 2)
#define COMM (0x500000 >> 2)

void write_to_mem(int word, int addr) {
    USER_writeWord(word, MEM_ADDR + (addr >> 2));
}

void load_wildcat_program(void)
{
    for (int i = 0; i < wildcat_img_len; i++) {
        write_to_mem(
            floating_point_test_img[i].word,
            floating_point_test_img[i].byte_addr
        );
    }
}

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    User_enableIF();

    // comm_controller bit 1 selects the instruction RAM bank and bit 0 controls reset.
    // Keep Wildcat in reset while programming IMEM0.
    USER_writeWord(1, COMM_CTRL);

    // Load Wildcat instruction memory
    load_wildcat_program();
    
    // Release reset while keeping the mux pointed at IMEM0.
    USER_writeWord(0, COMM_CTRL);

    // Read "0x3FCF1BBD" from Wildcat which is the f32 representation of the golden ratio phi=1.618034
    while (USER_readWord(COMM) != 0x3FCF1BBD);

    // Signal testbench that test has passed
    ManagmentGpio_write(1);

    // Loop forever — Wildcat runs on its own
    while(1);
}
