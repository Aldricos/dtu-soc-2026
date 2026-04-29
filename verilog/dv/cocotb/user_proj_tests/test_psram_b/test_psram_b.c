#include <firmware_apis.h>

#define IMEM_2_ADDR (0x300000 >> 2)
#define COMM_CTRL   (0x400000 >> 2)

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    // Configure Group 5 SPI Pins
    GPIOs_configure(16, GPIO_MODE_USER_STD_OUTPUT);       // CS0_n  (Flash)
    GPIOs_configure(17, GPIO_MODE_USER_STD_OUTPUT);       // MOSI
    GPIOs_configure(18, GPIO_MODE_USER_STD_INPUT_NOPULL); // MISO   (Input!)
    GPIOs_configure(19, GPIO_MODE_USER_STD_OUTPUT);       // SCK
    GPIOs_configure(20, GPIO_MODE_USER_STD_OUTPUT);       // CS1_n  (PSRAM A)
    GPIOs_configure(21, GPIO_MODE_USER_STD_OUTPUT);       // CS2_n  (PSRAM B)

    GPIOs_loadConfigs();
    User_enableIF();

    // RESET + select IMEM_2
    USER_writeWord(3, COMM_CTRL);

    uint32_t boot_program[] = {
        0x60000137, // lui x2, 0x60000  (PSRAM B base = 0x60000000)
        0x00012183, // lw x3, 0(x2)     (PSRAM B read → CS2_n LOW)
        0xFFDFF06F  // j loop
    };

    for (int i = 0; i < 3; i++) {
        USER_writeWord(boot_program[i], IMEM_2_ADDR + i);
    }

    // verify saved program
    bool status = true;
    for (int i = 0; i < 3; i++) {
        if (USER_readWord(IMEM_2_ADDR + i) != boot_program[i]) {
            status = false;
        }
    }

    if (status == true) {

        // Release RESET but keep IMEM_2
        USER_writeWord(2, COMM_CTRL);

        ManagmentGpio_write(1);
    }

    return;
}