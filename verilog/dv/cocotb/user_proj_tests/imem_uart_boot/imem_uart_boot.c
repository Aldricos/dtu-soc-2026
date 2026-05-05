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
#include <stdbool.h>
#include <stdint.h>

// User Wishbone offsets are word offsets from USER_SPACE_ADDR.
#define PROG_IMEM_ADDR (0x300000 >> 2)
#define COMM_CTRL_ADDR (0x400000 >> 2)

#define UART_RX_GPIO 5
#define UART_TX_GPIO 6
#define WILDCAT_LED_GPIO 24
#define MAX_IMEM_WORDS 64

static uint8_t uart_read_u8(void)
{
    uint8_t value = (uint8_t)UART_readChar();
    UART_popChar();
    return value;
}

static uint8_t hex_value(uint8_t c)
{
    if (c >= '0' && c <= '9') {
        return c - '0';
    }
    if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    }
    if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    }
    return 0xff;
}

static uint8_t uart_read_hex_nibble(bool *ok)
{
    uint8_t nibble = hex_value(uart_read_u8());
    if (nibble > 0x0f) {
        *ok = false;
        return 0;
    }
    return nibble;
}

static uint8_t uart_read_hex_byte(bool *ok)
{
    uint8_t high = uart_read_hex_nibble(ok);
    uint8_t low = uart_read_hex_nibble(ok);
    return (high << 4) | low;
}

static uint32_t uart_read_hex_word(bool *ok)
{
    uint32_t word = 0;
    for (int i = 0; i < 8; i++) {
        word = (word << 4) | uart_read_hex_nibble(ok);
    }
    return word;
}

void main()
{
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    enableHkSpi(0);

    GPIOs_configure(UART_RX_GPIO, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(UART_TX_GPIO, GPIO_MODE_MGMT_STD_OUTPUT);
    GPIOs_configure(WILDCAT_LED_GPIO, GPIO_MODE_USER_STD_OUTPUT);
    GPIOs_loadConfigs();

    User_enableIF();
    UART_enableRX(true);
    UART_enableTX(true);

    // Keep Wildcat reset asserted and select programmable_IMEM while loading.
    USER_writeWord(3, COMM_CTRL_ADDR);

    // Tell cocotb that firmware is ready to receive the UART payload.
    ManagmentGpio_write(1);

    bool ok = true;
    uint8_t word_count = uart_read_hex_byte(&ok);

    if (word_count == 0 || word_count > MAX_IMEM_WORDS) {
        ok = false;
        word_count = 0;
    }

    ManagmentGpio_write(0);

    for (uint8_t i = 0; i < word_count; i++) {
        uint32_t word = uart_read_hex_word(&ok);
        USER_writeWord(word, PROG_IMEM_ADDR + i);
        if (USER_readWord(PROG_IMEM_ADDR + i) != word) {
            ok = false;
        }
    }

    if (ok) {
        // Release reset while keeping bit 1 set so Wildcat fetches from programmable_IMEM.
        USER_writeWord(2, COMM_CTRL_ADDR);
        ManagmentGpio_write(1);
    }

    while (1);
}
