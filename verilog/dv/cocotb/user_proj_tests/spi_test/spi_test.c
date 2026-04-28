#include <firmware_apis.h>

#define IMEM_BASE (0x0200000 >> 2)

void main(void) {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    User_enableIF();

    // Write Wildcat's program into WishboneInstrRam
    // objdump of apps/spi_psram_a.s:
    //   0x0: 0x50000137  lui  sp, 0x50000  (sp = 0x5000_0000)
    //   0x4: 0x00012183  lw   gp, 0(sp)    (read PSRAM A CS1_n LOW)
    //   0x8: 0xFFDFF06F  j    0x4          (loop forever)
    USER_writeWord(0x50000137, IMEM_BASE + 0);
    USER_writeWord(0x00012183, IMEM_BASE + 1);
    USER_writeWord(0xFFDFF06F, IMEM_BASE + 2);

    // Unlock Wildcat
    // From WishboneInstrRam.v: cpuEnable sets when io_wb_addr[9:2] == 8'hff
    // That means Wishbone byte address offset = 0xFF << 2 = 0x3FC
    // As a word index: IMEM_BASE + (0x3FC >> 2) = IMEM_BASE + 0xFF
    USER_writeWord(0x1, IMEM_BASE + 0xFF);

    // Group 5 SPI pins
    GPIOs_configure(0, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_configure(1, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_configure(2, GPIO_MODE_USER_STD_INPUT_NOPULL);
    GPIOs_configure(3, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_configure(4, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_configure(5, GPIO_MODE_USER_STD_OUTPUT);

    GPIOs_loadConfigs();

    ManagmentGpio_write(1);
}