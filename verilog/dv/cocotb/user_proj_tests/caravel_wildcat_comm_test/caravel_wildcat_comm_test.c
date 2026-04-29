#include <firmware_apis.h>
#include <stdint.h>

typedef struct {
    int byte_addr;
    int word;
} mem_init_t;

const mem_init_t caravel_wildcat_comm_test_img[] = {
    { 0x00000000, 0xc00000b7 },  // li      x1, 0xc0000000
    { 0x00000004, 0x0000a103 },  // lw      x2, 0(x1)
    { 0x00000008, 0x0020a023 },  // sw      x2, 0(x1)
    { 0x0000000C, 0xff5ff06f },  // j       loop
};

const int wildcat_img_len =
    sizeof(caravel_wildcat_comm_test_img) / sizeof(caravel_wildcat_comm_test_img[0]);

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
            caravel_wildcat_comm_test_img[i].word,
            caravel_wildcat_comm_test_img[i].byte_addr
        );
    }
}

bool verify_wildcat_program(void)
{
    for (int i = 0; i < wildcat_img_len; i++) {
        if (USER_readWord(MEM_ADDR + (caravel_wildcat_comm_test_img[i].byte_addr >> 2)) !=
            caravel_wildcat_comm_test_img[i].word) {
            return false;
        }
    }

    return true;
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
    
    if (!verify_wildcat_program()) {
        while(1);
    }

    // Release reset while keeping the mux pointed at IMEM0.
    USER_writeWord(0, COMM_CTRL);

    // WishboneInstrRam enables CPU fetch after a write to address 0xFF in the selected IMEM.
    USER_writeWord(3, MEM_ADDR + (1020 >> 2));  // releases CPU 1111111100

    // Write "0xDEADBEEF" to Wildcat
    USER_writeWord(0xDEADBEEF, COMM);

    // Read "0xDEADBEEF" from Wildcat
    while (USER_readWord(COMM) != 0xDEADBEEF);

    // Signal testbench that test has passed
    ManagmentGpio_write(1);

    // Loop forever — Wildcat runs on its own
    while(1);
}
