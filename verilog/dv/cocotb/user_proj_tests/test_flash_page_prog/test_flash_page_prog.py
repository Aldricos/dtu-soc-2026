from caravel_cocotb.caravel_interfaces import test_configure, report_test
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

    return len(bits), bits

@cocotb.test()
@report_test
async def test_flash_page_prog(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=200000)
    await caravelEnv.wait_mgmt_gpio(1)

    cocotb.log.info("Monitoring CS0_n (Pin 16) for WREN...")

    # 1. Capture Transaction 1: WREN (8 bits)
    len1, bits1 = await capture_spi(caravelEnv, cs_pin=16)
    cmd1 = int(bits1, 2)
    cocotb.log.info(f"Txn 1 Captured: {len1} bits, Val = {hex(cmd1)}")

    assert len1 == 8, f"WREN: Expected 8 bits, got {len1}"
    assert cmd1 == 0x06, f"WREN: Expected 0x06, got {hex(cmd1)}"

    cocotb.log.info("WREN successful! Waiting for Page Program...")

    # 2. Capture Transaction 2: Page Program (64 bits)
    len2, bits2 = await capture_spi(caravelEnv, cs_pin=16)

    cmd2  = int(bits2[0:8], 2)
    addr2 = int(bits2[8:32], 2)
    data2 = int(bits2[32:64], 2)

    cocotb.log.info(f"Txn 2 Captured: Cmd={hex(cmd2)}, Addr={hex(addr2)}, Data={hex(data2)}")

    assert len2 == 64, f"PageProg: Expected 64 bits, got {len2}"
    assert cmd2 == 0x02, f"PageProg: Expected command 0x02, got {hex(cmd2)}"
    assert addr2 == 0x000000, f"PageProg: Expected address 0x0, got {hex(addr2)}"
    assert data2 == 0x000000AB, f"PageProg: Expected data 0xAB, got {hex(data2)}"

    cocotb.log.info("SUCCESS: WREN + Page Program matched")
    cocotb.log.info("[TEST] pass")