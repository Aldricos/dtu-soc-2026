#include <firmware_apis.h>
#include <stdint.h>

typedef struct {
    int byte_addr;
    int word;
} mem_init_t;

// apps/raytracer_mmio.s
const mem_init_t raytracer_mmio_test_img[] = {
    { 0x00000000, 0xf0050437 },
    { 0x00000004, 0xf00304b7 },
    { 0x00000008, 0x00100293 },
    { 0x0000000C, 0x00542823 },
    { 0x00000010, 0x00200293 },
    { 0x00000014, 0x00001337 },
    { 0x00000018, 0x01830313 },
    { 0x0000001C, 0x00830333 },
    { 0x00000020, 0x00532023 },
    { 0x00000024, 0x00001337 },
    { 0x00000028, 0x01c30313 },
    { 0x0000002C, 0x00830333 },
    { 0x00000030, 0x00532023 },
    { 0x00000034, 0x00100293 },
    { 0x00000038, 0x00542023 },
    { 0x0000003C, 0x00442303 },
    { 0x00000040, 0xfe031ee3 },
    { 0x00000044, 0x00400913 },
    { 0x00000048, 0x00000993 },
    { 0x0000004C, 0x00000a13 },
    { 0x00000050, 0x00842303 },
    { 0x00000054, 0xfe030ee3 },
    { 0x00000058, 0x00c42303 },
    { 0x0000005C, 0x0ff37313 },
    { 0x00000060, 0x0069e9b3 },
    { 0x00000064, 0x001a0a13 },
    { 0x00000068, 0xfff90913 },
    { 0x0000006C, 0xfe0912e3 },
    { 0x00000070, 0xcafe02b7 },
    { 0x00000074, 0x008a1313 },
    { 0x00000078, 0x0062e2b3 },
    { 0x0000007C, 0x0132e2b3 },
    { 0x00000080, 0x0054a023 },
    { 0x00000084, 0x0000006f },
};

const int wildcat_img_len =
    sizeof(raytracer_mmio_test_img) / sizeof(raytracer_mmio_test_img[0]);

// Caravel-side wishbone word addresses (decoded on bits [27:20]).
#define MEM_ADDR  (0x0200000 >> 2)   // WishboneInstrRam
#define COMM_CTRL (0x400000 >> 2)    // Wildcat reset / IMEM bank select
#define COMM      (0x500000 >> 2)    // Wildcat <-> Caravel comm register

void write_to_mem(int word, int addr) {
    USER_writeWord(word, MEM_ADDR + (addr >> 2));
}

void load_wildcat_program(void) {
    for (int i = 0; i < wildcat_img_len; i++) {
        write_to_mem(
            raytracer_mmio_test_img[i].word,
            raytracer_mmio_test_img[i].byte_addr
        );
    }
}

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    User_enableIF();

    // Hold Wildcat in reset, point IMEM mux at bank 0.
    USER_writeWord(1, COMM_CTRL);

    load_wildcat_program();

    // Release reset.
    USER_writeWord(0, COMM_CTRL);

    // Wildcat program writes a result word once the 4x4 frame has been
    // drained: 0xCAFE_<count>_<accum>. Spin until magic is set.
    unsigned int result;
    do {
        result = USER_readWord(COMM);
    } while ((result & 0xFFFF0000) != 0xCAFE0000);

    // Verify the FSM produced exactly 4 pixels for the 2x2 frame.
    // (Pixel values themselves are scene-dependent; charSky == 0x00, so an
    // all-sky frame would yield accum == 0 — that's still a valid render.)
    unsigned int count = (result >> 8) & 0xFF;
    if (count != 4) {
        while (1);
    }

    ManagmentGpio_write(1);

    while (1);
}
