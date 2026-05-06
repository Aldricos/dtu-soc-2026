#include <firmware_apis.h>
#include <stdint.h>

typedef struct {
    int byte_addr;
    int word;
} mem_init_t;

// apps/raytracer_write.s -- exercises every writable raytracer register.
// drainMode is the only register with a readback path, so we roundtrip it
// 0->1->0. The rest (cam/sphere/cols/rows/scale) are write-only; we just
// confirm the writes ack so the CPU doesn't stall on any of them.
const mem_init_t raytracer_write_test_img[] = {
    { 0x00000000, 0xf0050437 },
    { 0x00000004, 0xf00304b7 },
    { 0x00000008, 0x00100293 },
    { 0x0000000C, 0x00542823 },
    { 0x00000010, 0x01042303 },
    { 0x00000014, 0x0c629663 },
    { 0x00000018, 0x00000293 },
    { 0x0000001C, 0x00542823 },
    { 0x00000020, 0x01042303 },
    { 0x00000024, 0x0a629e63 },
    { 0x00000028, 0x123453b7 },
    { 0x0000002C, 0x67838393 },
    { 0x00000030, 0x00001337 },
    { 0x00000034, 0x00830333 },
    { 0x00000038, 0x00732023 },
    { 0x0000003C, 0x00001337 },
    { 0x00000040, 0x00430313 },
    { 0x00000044, 0x00830333 },
    { 0x00000048, 0x00732023 },
    { 0x0000004C, 0x00001337 },
    { 0x00000050, 0x00830313 },
    { 0x00000054, 0x00830333 },
    { 0x00000058, 0x00732023 },
    { 0x0000005C, 0x00001337 },
    { 0x00000060, 0x00c30313 },
    { 0x00000064, 0x00830333 },
    { 0x00000068, 0x00732023 },
    { 0x0000006C, 0x00001337 },
    { 0x00000070, 0x01030313 },
    { 0x00000074, 0x00830333 },
    { 0x00000078, 0x00732023 },
    { 0x0000007C, 0x00001337 },
    { 0x00000080, 0x01430313 },
    { 0x00000084, 0x00830333 },
    { 0x00000088, 0x00732023 },
    { 0x0000008C, 0x00400293 },
    { 0x00000090, 0x00001337 },
    { 0x00000094, 0x01830313 },
    { 0x00000098, 0x00830333 },
    { 0x0000009C, 0x00532023 },
    { 0x000000A0, 0x00001337 },
    { 0x000000A4, 0x01c30313 },
    { 0x000000A8, 0x00830333 },
    { 0x000000AC, 0x00532023 },
    { 0x000000B0, 0x00001337 },
    { 0x000000B4, 0x02030313 },
    { 0x000000B8, 0x00830333 },
    { 0x000000BC, 0x00732023 },
    { 0x000000C0, 0x00001337 },
    { 0x000000C4, 0x02430313 },
    { 0x000000C8, 0x00830333 },
    { 0x000000CC, 0x00732023 },
    { 0x000000D0, 0xcafe02b7 },
    { 0x000000D4, 0x00128293 },
    { 0x000000D8, 0x0054a023 },
    { 0x000000DC, 0x0000006f },
    { 0x000000E0, 0x0000006f },
};

const int wildcat_img_len =
    sizeof(raytracer_write_test_img) / sizeof(raytracer_write_test_img[0]);

#define MEM_ADDR  (0x0200000 >> 2)
#define COMM_CTRL (0x400000 >> 2)
#define COMM      (0x500000 >> 2)

void write_to_mem(int word, int addr) {
    USER_writeWord(word, MEM_ADDR + (addr >> 2));
}

void load_wildcat_program(void) {
    for (int i = 0; i < wildcat_img_len; i++) {
        write_to_mem(
            raytracer_write_test_img[i].word,
            raytracer_write_test_img[i].byte_addr
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
