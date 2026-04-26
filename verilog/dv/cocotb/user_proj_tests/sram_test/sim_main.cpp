#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vsky130_sram_1kbyte_1rw1r_32x256_8.h"

#include <iostream>

vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    Vsky130_sram_1kbyte_1rw1r_32x256_8* top = new Vsky130_sram_1kbyte_1rw1r_32x256_8;
    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open("sram_verilator.vcd");

    // --- Reset/Initialization ---
    top->clk0 = 0;
    top->clk1 = 0;
    top->csb0 = 1;
    top->web0 = 1;
    top->wmask0 = 0;
    top->addr0 = 0;
    top->din0 = 0;
    top->csb1 = 1;
    top->addr1 = 0;

    while (main_time < 200 && !Verilated::gotFinish()) {
        // --- Clock Toggle ---
        if ((main_time % 5) == 0) {
            top->clk0 = !top->clk0;
            top->clk1 = !top->clk1;
        }

        // --- Test Sequence ---
        if (main_time == 20) {
            std::cout << "Time " << main_time << ": Writing 0xDEADBEEF to address 0x10" << std::endl;
            top->csb0 = 0;
            top->web0 = 0; // Write enable
            top->addr0 = 0x10;
            top->din0 = 0xDEADBEEF;
            top->wmask0 = 0b1111;
        }
        
        if (main_time == 30) {
            top->csb0 = 1; // End write
            top->web0 = 1;
        }

        if (main_time == 40) {
            std::cout << "Time " << main_time << ": Reading from address 0x10 (Port 0)" << std::endl;
            top->csb0 = 0; // Start read
            top->web0 = 1; // Read operation
            top->addr0 = 0x10;
        }

        if (main_time == 50) {
            top->csb0 = 1; // End read
            if (top->dout0 == 0xDEADBEEF) {
                std::cout << "  [SUCCESS] Port 0 Read data: " << std::hex << top->dout0 << std::endl;
            } else {
                std::cout << "  [FAILURE] Port 0 Read data: " << std::hex << top->dout0 << ", Expected: DEADBEEF" << std::endl;
            }
        }
        
        if (main_time == 60) {
            std::cout << "Time " << main_time << ": Reading from address 0x10 (Port 1)" << std::endl;
            top->csb1 = 0; // Start read on port 1
            top->addr1 = 0x10;
        }

        if (main_time == 70) {
            top->csb1 = 1; // End read
             if (top->dout1 == 0xDEADBEEF) {
                std::cout << "  [SUCCESS] Port 1 Read data: " << std::hex << top->dout1 << std::endl;
            } else {
                std::cout << "  [FAILURE] Port 1 Read data: " << std::hex << top->dout1 << ", Expected: DEADBEEF" << std::endl;
            }
        }


        top->eval();
        tfp->dump(main_time);
        main_time++;
    }

    tfp->close();
    delete top;
    delete tfp;

    std::cout << "\nVerilator simulation finished." << std::endl;

    return 0;
}
