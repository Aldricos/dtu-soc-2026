// SPDX-FileCopyrightText: 2023 Efabless Corporation

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <firmware_apis.h>

// address of the gcd module in words
#define IMEM_ADDR (0x300000>>2)
#define RESET_ADDR (0x400000>>2)

void main(){
    // Enable managment gpio as output to use as indicator for finishing configuration  
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0); // disable housekeeping spi
    // configure all gpios as  user out then chenge gpios from 32 to 37 before loading this configurations
    GPIOs_configureAll(GPIO_MODE_USER_STD_OUT_MONITORED);
    
    GPIOs_loadConfigs(); // load the configuration 
    User_enableIF(); // this necessary when reading or writing between wishbone and user project if interface isn't enabled no ack would be recieve and the command will be stuck

    // Wildcat reset is active high. Hold wc_2 in reset while programming IMEM.
    USER_writeWord(3, RESET_ADDR);

    uint32_t boot_program[] = {
    0xF0010237,
    0x00100193,
    0x00322023,
    0x00322023,
    0x00118193,
    0xFF9FF06F
    };
    int i =0;
    for (i=0;i<6;i++){
        USER_writeWord(boot_program[i],IMEM_ADDR+i);
    }
    bool status = true;
    for (i=0;i<6;i++){
        int j = USER_readWord(IMEM_ADDR+i);
        if (j!=boot_program[i])
            status = false;
    }
    if (status == true) {
        // Release wc_2 after the program has been loaded and checked.
        USER_writeWord(2, RESET_ADDR);
        ManagmentGpio_write(1);
    }
    return;
}
