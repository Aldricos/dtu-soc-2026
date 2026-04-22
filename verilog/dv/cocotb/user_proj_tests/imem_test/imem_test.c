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
#define IMEM_ADDR (0x200000>>2)
void main(){
    // Enable managment gpio as output to use as indicator for finishing configuration  
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0); // disable housekeeping spi
    // configure all gpios as  user out then chenge gpios from 32 to 37 before loading this configurations
    GPIOs_configureAll(GPIO_MODE_USER_STD_OUT_MONITORED);
    
    GPIOs_loadConfigs(); // load the configuration 
    User_enableIF(); // this necessary when reading or writing between wishbone and user project if interface isn't enabled no ack would be recieve and the command will be stuck
    

    volatile int i;
    for (i=0;i<1000;i++){}
    USER_writeWord(0x01234567,IMEM_ADDR+2);
    // for (i=0;i<1000;i++){}
    int check;
    check = USER_readWord(IMEM_ADDR+2);
    // for (i=0;i<1000;i++){}
    if (check == 0x01234567) {
        // indicate success by setting managment gpio high
        ManagmentGpio_write(1);
    } // else do nothing and let the testbench timeout

    return;
}