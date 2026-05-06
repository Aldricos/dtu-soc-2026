# Group 3: Booting from wishbone
In this project, we developed an additional instruction memory (RAM) and designed the means to switch between two different memories for instructions.
![width:500px](figures/group3/BlockDiagram.svg)
By using this design, we can program the Wildcat in user project by management core in Caravel. This can be done in 2 ways:
    1. Writing a program for Caravel management core (flash within Caravel) and program Wildcat core with it.
    2. Driving the UART connection from Caravel and using the management core to read from the uart and write to the Wildcat instruction memory.
# Design Details
3 components were designed to make the previous booting scenarios possible.
    1. Programmable_IMEM: This is the instruction RAM used to boot the Wildcat. As seen in the design picture, it has one interface that is connected to wishbone in order to be written from. Furthermore, it has another interface to communicate with Wildcat (which is named PipeCon). Inside this module, a 1 KB OpenRAM memory module is used that has 1 read and write port for wishbone and one read port for interface with Wildcat CPU. Instantiation of the memory module is shown below:
            val mem = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())
    Later, the macro for placement and voltage pins of the memory is implemented inopenlane/CaravelUserProject/config.json :
            "wc.imem_2.mem": {
                            "location": [
                                1100,
                                150
                            ],
                            "orientation": "N"
                        }
            "wc.imem_2.mem vccd1 vssd1 vccd1 vssd1",
    To connect this memory to wishbone, additional wishbone interface is added to CpuTop module under the name wb_2:
            val wb_2 = Flipped(new WishboneIO(32))
    This wishbone interface is connected to a switch inside CaravelUserProject.scala like below:
            is(0x3.U){
                wc.io.wb_2.cyc := wb.cyc
                wb.ack := wc.io.wb_2.ack
                wb.rdData := wc.io.wb_2.rdData
            }
    2. comm_controller: We needed a module to drive the reset of the Wildcat after the programming of IMEM is finished in order to ensure the booting process is ran smoothly. To do so, we designed a module called comm_controller. This module has a wishbone interface to connect to management core. Within this module, there is a 32-bit register with initial value of 0. The LSB of this register is used as a reset for Wildcat and the 1st bit of this register is used for the multiplexer explained later.
    3. IMEM_mux: To select between the two instruction memories implemented, a multiplexer was designed. This multiplexer has two inputs of PipeCon and has one output of PipeCon. The two inputs are connected to the PipeCon interfaces of the two instruction RAMs and the output is connected to CPU. The select signal of this multiplexer is connected to comm_controller. With this design, user can choose between the two instruction RAMs so if one of the RAMs has an issue in the layout process, the other one can still be used.
# How to use:
    To use this instruction RAM you have to add two defines in the c file of your test:
        #define IMEM_ADDR (0x300000>>2)
        #define RESET_ADDR (0x400000>>2)
    To use Caravel management core you also have to include provided APIs :
        #include <firmware_apis.h>
    To enable wishbone communication between management core and User_Project_Wrapper, this function should be called before any data transfer:
         User_enableIF();
    At the start of the booting process, Wildcat reset should be driven High. Also, based on which RAM you want to use, you have to write the second bit of the comm_controller to either 1 or 0. Writing to these addresses provided is possible with the function below:
        USER_writeWord(3, RESET_ADDR);
    Afterwards, you have to write your program with a for-loop in the instruction RAM similar to this:
        for (i=0;i<6;i++){
        USER_writeWord(boot_program[i],IMEM_ADDR+i);
        }
    After finishing the write, you should drive the reset of the Wildcat to low and it is finished.
# Test:
    To test the booting process, Wildcat blinking program was used. See the test in this path:
        verilog/dv/cocotb/user_proj_tests/imem_2_boot
    Furthermore, a UART boot program is also tested with this system. We used the uart in Caravel and drived it in simulation (cocotb) to test the booting process. Code for this test can be seen in the repository below:
        verilog/dv/cocotb/user_proj_tests/imem_uart_boot

# Area:
    The reported area unit is um^2.

    1. Programmable_IMEM
        Area: 81.3280 um^2 of standard-cell logic, plus one 400 x 500 um SRAM macro.
        Cell count: 8 cells total.
        Cells used:
            - 2 x sky130_fd_sc_hd__dfxtp_2: positive-edge D flip-flops. These store the local control state, such as the acknowledge signal.
            - 2 x sky130_fd_sc_hd__nand2_2: 2-input NAND gates used in the control logic.
            - 1 x sky130_fd_sc_hd__and3b_2: 3-input AND gate with one inverted input, used to combine control conditions compactly.
            - 1 x sky130_fd_sc_hd__and4bb_2: 4-input AND gate with two inverted inputs, also used in control decoding.
            - 1 x sky130_fd_sc_hd__inv_2: inverter, used to flip a Boolean control signal.
            - 1 x sky130_sram_1kbyte_1rw1r_32x256_8: the 1 KB OpenRAM macro itself, providing one read/write port and one read port.

    2. comm_controller
        Area: 1328.7744 um^2.
        Cell count: 100 cells total.
        Cells used:
            - 33 x sky130_fd_sc_hd__dfxtp_2: positive-edge D flip-flops. These implement the 32-bit control register plus the acknowledge register.
            - 32 x sky130_fd_sc_hd__a31o_2: complex AND-OR gates. These combine several conditions into one expression efficiently.
            - 32 x sky130_fd_sc_hd__o211a_2: complex OR-AND gates. These are also used for compact control and register update logic.
            - 1 x sky130_fd_sc_hd__and4bb_2: 4-input AND gate with two inverted inputs, used in address or write-condition decoding.
            - 1 x sky130_fd_sc_hd__inv_2: inverter.
            - 1 x sky130_fd_sc_hd__nand3_2: 3-input NAND gate.

    3. IMEM_mux
        Area: 375.3600 um^2.
        Cell count: 34 cells total.
        Cells used:
            - 33 x sky130_fd_sc_hd__mux2_1: 2-to-1 multiplexers. These select whether the CPU sees signals from instruction memory 0 or instruction memory 1.
            - 1 x sky130_fd_sc_hd__inv_2: inverter, used to generate the opposite of the select signal so one memory is enabled while the other is disabled.
    
