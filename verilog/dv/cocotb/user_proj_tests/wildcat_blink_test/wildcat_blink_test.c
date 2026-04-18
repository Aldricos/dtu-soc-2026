#include <firmware_apis.h>

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    // Configure pin 24 as user output
    GPIOs_configure(24, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_loadConfigs();

    // Signal testbench that setup is done
    ManagmentGpio_write(1);

    // Loop forever — Wildcat runs on its own
    while(1);
}