#include <firmware_apis.h>

#define IMEM_2_ADDR (0x300000 >> 2)
#define COMM_CTRL   (0x400000 >> 2)

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    GPIOs_configure(16, GPIO_MODE_USER_STD_OUTPUT);       // CS0_n
    GPIOs_configure(17, GPIO_MODE_USER_STD_OUTPUT);       // MOSI
    GPIOs_configure(18, GPIO_MODE_USER_STD_INPUT_NOPULL); // MISO
    GPIOs_configure(19, GPIO_MODE_USER_STD_OUTPUT);       // SCK
    GPIOs_configure(20, GPIO_MODE_USER_STD_OUTPUT);       // CS1_n
    GPIOs_configure(21, GPIO_MODE_USER_STD_OUTPUT);       // CS2_n

    GPIOs_loadConfigs();
    User_enableIF();

    USER_writeWord(3, COMM_CTRL);

    // Assembly: lui x2, 0x41000 | sw x0, 0(x2) | j loop
    // Writing anything to 0x4100_0000 triggers the Magic Erase
    uint32_t boot_program[] = {
        0x41000137, // lui x2, 0x41000
        0x00012023, // sw x0, 0(x2)
        0xFFDFF06F  // j loop
    };

    for (int i = 0; i < 3; i++) {
        USER_writeWord(boot_program[i], IMEM_2_ADDR + i);
    }

    bool status = true;
    for (int i = 0; i < 3; i++) {
        if (USER_readWord(IMEM_2_ADDR + i) != boot_program[i]) status = false;
    }

    if (status == true) {
        USER_writeWord(2, COMM_CTRL);
        ManagmentGpio_write(1);
    }
    return;
}