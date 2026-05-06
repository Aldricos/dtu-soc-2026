#include <firmware_apis.h>
#include <stdint.h>

typedef struct {
    int byte_addr;
    int word;
} mem_init_t;

// apps/raytracer_read.s -- reads busy / notEmpty / drainMode and beacons
// 0xCAFE0001 to comm only if all three return their reset default of 0.
const mem_init_t raytracer_read_test_img[] = {
    { 0x00000000, 0xf0050437 },
    { 0x00000004, 0xf00304b7 },
    { 0x00000008, 0x00442283 },
    { 0x0000000C, 0x02029263 },
    { 0x00000010, 0x00842283 },
    { 0x00000014, 0x00029e63 },
    { 0x00000018, 0x01042283 },
    { 0x0000001C, 0x00029a63 },
    { 0x00000020, 0xcafe02b7 },
    { 0x00000024, 0x00128293 },
    { 0x00000028, 0x0054a023 },
    { 0x0000002C, 0x0000006f },
    { 0x00000030, 0x0000006f },
};

const int wildcat_img_len =
    sizeof(raytracer_read_test_img) / sizeof(raytracer_read_test_img[0]);

#define MEM_ADDR  (0x0200000 >> 2)
#define COMM_CTRL (0x400000 >> 2)
#define COMM      (0x500000 >> 2)

void write_to_mem(int word, int addr) {
    USER_writeWord(word, MEM_ADDR + (addr >> 2));
}

void load_wildcat_program(void) {
    for (int i = 0; i < wildcat_img_len; i++) {
        write_to_mem(
            raytracer_read_test_img[i].word,
            raytracer_read_test_img[i].byte_addr
        );
    }
}

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    User_enableIF();

    USER_writeWord(1, COMM_CTRL);
    load_wildcat_program();
    USER_writeWord(0, COMM_CTRL);

    while ((USER_readWord(COMM) & 0xFFFF0000) != 0xCAFE0000);

    ManagmentGpio_write(1);

    while (1);
}
