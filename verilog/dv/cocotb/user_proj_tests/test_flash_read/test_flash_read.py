from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from cocotb.triggers import RisingEdge

async def capture_spi(caravelEnv, cs_pin):
    cocotb.log.info(f"Waiting for CS pin {cs_pin} to go LOW...")
    while caravelEnv.monitor_gpio(cs_pin, cs_pin).binstr != '0':
        await RisingEdge(caravelEnv.clk)

    cocotb.log.info("CS LOW - transaction started, capturing MOSI bits...")

    bits = ""
    prev_sck = '0'
    while True:
        await RisingEdge(caravelEnv.clk)
        if caravelEnv.monitor_gpio(cs_pin, cs_pin).binstr == '1': break

        sck = caravelEnv.monitor_gpio(19, 19).binstr

        if sck == '1' and prev_sck == '0':
            bits += caravelEnv.monitor_gpio(17, 17).binstr
        prev_sck = sck

    # Pad to exactly 72 bits if Python missed the last dummy clock
    bits = bits.ljust(72, '0')
    return len(bits), bits

@cocotb.test()
@report_test
async def test_flash_read(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=200000)

    cocotb.log.info("Waiting for firmware to signal ready...")
    await caravelEnv.wait_mgmt_gpio(1)

    cocotb.log.info("Monitoring CS0_n (Pin 16)...")

    # FLASH CS0_n IS NOW PIN 16!
    length, bits_str = await capture_spi(caravelEnv, cs_pin=16)

    # Extract directly from the string to preserve leading zeros
    cmd_str  = bits_str[0:8]
    addr_str = bits_str[8:32]

    cmd_byte  = int(cmd_str, 2)
    addr_bits = int(addr_str, 2)

    cocotb.log.info(f"Captured Command = {hex(cmd_byte)}")
    cocotb.log.info(f"Captured Address = {hex(addr_bits)}")

    assert cmd_byte == 0x0B, f"Expected command 0x0B Fast Read got {hex(cmd_byte)}"
    assert addr_bits == 0x000000, f"Expected address 0x000000 got {hex(addr_bits)}"

    cocotb.log.info("SUCCESS: Flash Read 0x0B matched")
    cocotb.log.info("[TEST] pass")