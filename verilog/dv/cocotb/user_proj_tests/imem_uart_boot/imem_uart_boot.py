from caravel_cocotb.caravel_interfaces import UART, report_test, test_configure
import cocotb
from cocotb.triggers import ClockCycles


WILDCAT_BLINK_PROGRAM = [
    0xF0010237,  # lui  x4, 0xf0010
    0x00100193,  # addi x3, x0, 1
    0x00322023,  # sw   x3, 0(x4)
    0x00322023,  # sw   x3, 0(x4)
    0x00118193,  # addi x3, x3, 1
    0xFF9FF06F,  # jal  x0, -8
]


def imem_uart_payload(words):
    """Encode IMEM words as: 2 hex chars count, then 8 hex chars per word."""
    return f"{len(words):02X}" + "".join(f"{word & 0xFFFFFFFF:08X}" for word in words)


async def drive_caravel_uart_rx(caravelEnv, payload, rx_pin=5, tx_pin=6):
    """Drive the Caravel management UART RX pin with ASCII payload bytes."""
    uart = UART(caravelEnv, uart_pins={"rx": rx_pin, "tx": tx_pin})
    caravelEnv.drive_gpio_in(rx_pin, 1)
    await ClockCycles(caravelEnv.clk, 5)

    for char in payload:
        await uart.uart_send_char(char)


@cocotb.test()
@report_test
async def imem_uart_boot(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=1500000)

    caravelEnv.drive_gpio_in(5, 1)
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("[TEST] Firmware is ready for UART IMEM payload")

    await drive_caravel_uart_rx(caravelEnv, imem_uart_payload(WILDCAT_BLINK_PROGRAM))
    cocotb.log.info("[TEST] UART payload sent, watching Wildcat LED on GPIO24")

    led = False
    blinkCounter = 0

    for _ in range(200000):
        val = caravelEnv.monitor_gpio(24, 24)
        if val == 1:
            if not led:
                led = True
                blinkCounter += 1
                cocotb.log.info("[TEST] Blink Counter: " + str(blinkCounter))
        elif val == 0:
            if led:
                led = False

        if blinkCounter >= 5:
            cocotb.log.info("[TEST] Success")
            return

        await ClockCycles(caravelEnv.clk, 1)

    assert False, "LED never blinked - programmable_IMEM UART boot did not run"
