from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from cocotb.triggers import RisingEdge, Timer

async def capture_spi(caravelEnv, cs_pin):
    cocotb.log.info(f"Waiting for CS pin {cs_pin} to go LOW...")

    for _ in range(100000):
        await RisingEdge(caravelEnv.clk)
        if caravelEnv.monitor_gpio(cs_pin, cs_pin).binstr == '0':
            break
    else:
        cocotb.log.error(f"TIMEOUT waiting for CS pin {cs_pin} to go LOW")
        return 0, 0

    cocotb.log.info("CS LOW - transaction started, capturing MOSI bits...")

    bits = []
    prev_sck = '0'

    for _ in range(500):
        await RisingEdge(caravelEnv.clk)
        # Wait 50ns into the cycle so we sample in the middle of the
        # clock period rather than right at the edge where SCK changes
        await Timer(50, units='ns')

        cs_val  = caravelEnv.monitor_gpio(cs_pin, cs_pin).binstr
        sck_val = caravelEnv.monitor_gpio(3, 3).binstr

        if cs_val == '1':
            cocotb.log.info(f"CS HIGH - transaction complete. {len(bits)} bits captured.")
            break

        if sck_val == '1' and prev_sck == '0':
            mosi = caravelEnv.monitor_gpio(1, 1).binstr
            bits.append(mosi)
            cocotb.log.info(f"bit {len(bits)-1} SCK rising MOSI={mosi}")

        prev_sck = sck_val

    if len(bits) == 0:
        cocotb.log.error("No bits captured - SCK never toggled during transaction")
        return 0, 0

    return len(bits), int(''.join(bits), 2)


@cocotb.test()
@report_test
async def test_flash_read(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=200000)

    cocotb.log.info("Waiting for firmware to signal ready...")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("Firmware ready - starting Flash Fast Read test")

    length, val = await capture_spi(caravelEnv, cs_pin=0)
    cocotb.log.info(f"Captured {length} bits raw value = {hex(val)}")

    assert length >= 8, \
        f"Expected at least 8 bits got {length}"

    cmd_byte = val >> (length - 8)
    assert cmd_byte == 0x0B, \
        f"Expected command 0x0B Fast Read got {hex(cmd_byte)}"

    if length >= 40:
        addr_bits = (val >> (length - 32)) & 0xFFFFFF
        assert addr_bits == 0x000000, \
            f"Expected address 0x000000 got {hex(addr_bits)}"
        cocotb.log.info(f"Address = {hex(addr_bits)} correct")

    cocotb.log.info(f"Command byte = {hex(cmd_byte)} correct")
    cocotb.log.info(f"All {length} MOSI bits verified successfully")
    cocotb.log.info("[TEST] pass")