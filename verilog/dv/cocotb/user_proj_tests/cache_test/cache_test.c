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
#define CACHE_BASE  (0xE0000000 >> 2)

static void fail() {
    // Keep GPIO low and let testbench timeout
    while (1) { }
}

static void delay() {
    volatile int i;
    for (i = 0; i < 1000; i++) { }
}

static void check_cache_word(unsigned int addr, unsigned int expected) {
    unsigned int value = USER_readWord(addr);
    if (value != expected) {
        fail();
    }
}

static void check_mem_word(unsigned int addr, unsigned int expected) {
    unsigned int value = USER_readWord(addr);
    if (value != expected) {
        fail();
    }
}

void main() {
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);

    enableHkSpi(0);
    GPIOs_configureAll(GPIO_MODE_USER_STD_OUT_MONITORED);
    GPIOs_loadConfigs();
    User_enableIF();

    delay();

    // ------------------------------------------------
    // Test 1: write several values through cache
    // ------------------------------------------------
    //USER_writeWord(0x01234567, CACHE_BASE + 0);
    //USER_writeWord(0x89ABCDEF, CACHE_BASE + 1);
    //USER_writeWord(0xA5A5A5A5, CACHE_BASE + 2);
    //USER_writeWord(0x5A5A5A5A, CACHE_BASE + 3);

    // Read back through cache
    //check_cache_word(CACHE_BASE + 0, 0x01234567);
    //check_cache_word(CACHE_BASE + 1, 0x89ABCDEF);
    //check_cache_word(CACHE_BASE + 2, 0xA5A5A5A5);
    //check_cache_word(CACHE_BASE + 3, 0x5A5A5A5A);

    // Verify backing memory sees the same values
    //check_mem_word(DMEM_BASE + 0, 0x01234567);
    //check_mem_word(DMEM_BASE + 1, 0x89ABCDEF);
    //check_mem_word(DMEM_BASE + 2, 0xA5A5A5A5);
    //check_mem_word(DMEM_BASE + 3, 0x5A5A5A5A);

    // ------------------------------------------------
    // Test 2: overwrite one cached word
    // ------------------------------------------------
    //USER_writeWord(0xDEADBEEF, CACHE_BASE + 2);

    //check_cache_word(CACHE_BASE + 0, 0x01234567);
    //check_cache_word(CACHE_BASE + 1, 0x89ABCDEF);
    //check_cache_word(CACHE_BASE + 2, 0xDEADBEEF);
    //check_cache_word(CACHE_BASE + 3, 0x5A5A5A5A);

    // Confirm write-through updated plain memory too
    //check_mem_word(DMEM_BASE + 0, 0x01234567);
    //check_mem_word(DMEM_BASE + 1, 0x89ABCDEF);
    //check_mem_word(DMEM_BASE + 2, 0xDEADBEEF);
    //check_mem_word(DMEM_BASE + 3, 0x5A5A5A5A);

    // ------------------------------------------------
    // Test 3: write/read spaced cached addresses
    // ------------------------------------------------
    //USER_writeWord(0x11111111, CACHE_BASE + 8);
    //USER_writeWord(0x22222222, CACHE_BASE + 16);
    //USER_writeWord(0x33333333, CACHE_BASE + 32);
    //USER_writeWord(0x44444444, CACHE_BASE + 64);

    //check_cache_word(CACHE_BASE + 8,  0x11111111);
    //check_cache_word(CACHE_BASE + 16, 0x22222222);
    //check_cache_word(CACHE_BASE + 32, 0x33333333);
    //check_cache_word(CACHE_BASE + 64, 0x44444444);

    // Verify uncached alias still matches
    //check_mem_word(DMEM_BASE + 8,  0x11111111);
    //check_mem_word(DMEM_BASE + 16, 0x22222222);
    //check_mem_word(DMEM_BASE + 32, 0x33333333);
    //check_mem_word(DMEM_BASE + 64, 0x44444444);

    // ------------------------------------------------
    // Test 4: read-back again through cache
    // This exercises repeated reads after allocation/fill
    // ------------------------------------------------
    //check_cache_word(CACHE_BASE + 8,  0x11111111);
    //check_cache_word(CACHE_BASE + 16, 0x22222222);
    //check_cache_word(CACHE_BASE + 32, 0x33333333);
    //check_cache_word(CACHE_BASE + 64, 0x44444444);

    // ------------------------------------------------
    // All tests passed
    // ------------------------------------------------
    ManagmentGpio_write(1);

    return;
}