// SPDX-FileCopyrightText: 2023 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <firmware_apis.h>

#define DMEM_BASE   (0x00000000 >> 2)

static void fail() {
    // Keep GPIO low and let testbench timeout
    while (1) { }
}

static void delay() {
    volatile int i;
    for (i = 0; i < 1000; i++) { }
}

static void check_word(unsigned int addr, unsigned int expected) {
    unsigned int value = USER_readWord(addr);
    if (value != expected) {
        fail();
    }
}

void main() {
    // Enable management GPIO as output to indicate success/failure
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);

    enableHkSpi(0); // disable housekeeping spi

    // Configure all GPIOs as user output
    GPIOs_configureAll(GPIO_MODE_USER_STD_OUT_MONITORED);
    GPIOs_loadConfigs();

    // Enable user project interface
    User_enableIF();

    delay();

    // ------------------------------------------------
    // Test 1: write distinct values to several words
    // ------------------------------------------------
    USER_writeWord(0x01234567, DMEM_BASE + 0);
    USER_writeWord(0x89ABCDEF, DMEM_BASE + 1);
    USER_writeWord(0xA5A5A5A5, DMEM_BASE + 2);
    USER_writeWord(0x5A5A5A5A, DMEM_BASE + 3);

    check_word(DMEM_BASE + 0, 0x01234567);
    check_word(DMEM_BASE + 1, 0x89ABCDEF);
    check_word(DMEM_BASE + 2, 0xA5A5A5A5);
    check_word(DMEM_BASE + 3, 0x5A5A5A5A);

    // ------------------------------------------------
    // Test 2: overwrite one word and verify neighbors
    // ------------------------------------------------
    USER_writeWord(0xDEADBEEF, DMEM_BASE + 2);

    check_word(DMEM_BASE + 0, 0x01234567);
    check_word(DMEM_BASE + 1, 0x89ABCDEF);
    check_word(DMEM_BASE + 2, 0xDEADBEEF);
    check_word(DMEM_BASE + 3, 0x5A5A5A5A);

    // ------------------------------------------------
    // Test 3: write/read some more spaced addresses
    // ------------------------------------------------
    USER_writeWord(0x11111111, DMEM_BASE + 8);
    USER_writeWord(0x22222222, DMEM_BASE + 16);
    USER_writeWord(0x33333333, DMEM_BASE + 32);
    USER_writeWord(0x44444444, DMEM_BASE + 64);

    check_word(DMEM_BASE + 8,  0x11111111);
    check_word(DMEM_BASE + 16, 0x22222222);
    check_word(DMEM_BASE + 32, 0x33333333);
    check_word(DMEM_BASE + 64, 0x44444444);

    // Re-check earlier values to catch accidental corruption
    check_word(DMEM_BASE + 0, 0x01234567);
    check_word(DMEM_BASE + 1, 0x89ABCDEF);
    check_word(DMEM_BASE + 2, 0xDEADBEEF);
    check_word(DMEM_BASE + 3, 0x5A5A5A5A);

    // ------------------------------------------------
    // All tests passed
    // ------------------------------------------------
    ManagmentGpio_write(1);

    return;
}