#include <firmware_apis.h>

#define IMEM_2_ADDR (0x300000 >> 2) // imem bank 1
#define COMM_CTRL   (0x400000 >> 2)

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    // Configure Group 5 SPI Pins
    GPIOs_configure(0, GPIO_MODE_USER_STD_OUTPUT);       // CS0_n
    GPIOs_configure(1, GPIO_MODE_USER_STD_OUTPUT);       // MOSI
    GPIOs_configure(2, GPIO_MODE_USER_STD_INPUT_NOPULL); // MISO
    GPIOs_configure(3, GPIO_MODE_USER_STD_OUTPUT);       // SCK
    GPIOs_configure(4, GPIO_MODE_USER_STD_OUTPUT);       // CS1_n
    GPIOs_configure(5, GPIO_MODE_USER_STD_OUTPUT);       // CS2_n

    GPIOs_loadConfigs();
    User_enableIF();

    // RESET (Bit 0 = 1) AND select IMEM_2 (Bit 1 = 1)
    // Binary 11 = 3
    USER_writeWord(3, COMM_CTRL);

    uint32_t boot_program[] = {
        0x50000137, // lui x2, 0x50000  (Loads 0x50000000)
        0x00012183, // lw x3, 0(x2)     (read PSRAM A CS1_n LOW)
        0xFFDFF06F  // j loop           (loop forever)
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
        // Release RESET (Bit 0 = 0) BUT KEEP IMEM_2
        // Binary 10 = 2
        USER_writeWord(2, COMM_CTRL);

        ManagmentGpio_write(1);
    }

    return;
}