#include <firmware_apis.h>
#include <stdint.h>

typedef struct {
    int byte_addr;
    int word;
} mem_init_t;

// apps/raytracer_uart.s
const mem_init_t raytracer_uart_test_img[] = {
    { 0x00000000, 0xf0050437 },
    { 0x00000004, 0xf00304b7 },
    { 0x00000008, 0x00042823 },
    { 0x0000000C, 0x00200293 },
    { 0x00000010, 0x00001337 },
    { 0x00000014, 0x01830313 },
    { 0x00000018, 0x00830333 },
    { 0x0000001C, 0x00532023 },
    { 0x00000020, 0x00001337 },
    { 0x00000024, 0x01c30313 },
    { 0x00000028, 0x00830333 },
    { 0x0000002C, 0x00532023 },
    { 0x00000030, 0x00100293 },
    { 0x00000034, 0x00542023 },
    { 0x00000038, 0xcafe02b7 },
    { 0x0000003C, 0x00128293 },
    { 0x00000040, 0x0054a023 },
    { 0x00000044, 0x0000006f },
};

const int wildcat_img_len =
    sizeof(raytracer_uart_test_img) / sizeof(raytracer_uart_test_img[0]);

#define MEM_ADDR  (0x0200000 >> 2)
#define COMM_CTRL (0x400000 >> 2)
#define COMM      (0x500000 >> 2)

void write_to_mem(int word, int addr) {
    USER_writeWord(word, MEM_ADDR + (addr >> 2));
}

void load_wildcat_program(void) {
    for (int i = 0; i < wildcat_img_len; i++) {
        write_to_mem(
            raytracer_uart_test_img[i].word,
            raytracer_uart_test_img[i].byte_addr
        );
    }
}

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    // Pin 6 is the dedicated raytracer UART TX (see CaravelUserProject.scala).
    // The boot-time gpio_config in .cf/project.json already sets it to user
    // output, but mirror wildcat_blink_test and configure it explicitly.
    GPIOs_configure(6, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_loadConfigs();

    User_enableIF();

    USER_writeWord(1, COMM_CTRL);
    load_wildcat_program();
    USER_writeWord(0, COMM_CTRL);

    // Wildcat writes 0xCAFE0001 to COMM the moment it has pulsed start.
    // Once we see it, the testbench should begin watching pin 6 for serial
    // activity at 115200 baud.
    while (USER_readWord(COMM) != 0xCAFE0001);

    ManagmentGpio_write(1);

    while (1);
}
