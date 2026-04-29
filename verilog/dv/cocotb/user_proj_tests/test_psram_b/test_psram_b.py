from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
@report_test
async def test_psram_b(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=100000)

    cocotb.log.info("Waiting for Management Core to configure IOs...")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("IOs configured! Wildcat is running...")

    cocotb.log.info("Monitoring CS2_n (Pin 21). Waiting for PSRAM B transaction...")

    cs2_found = False
    for _ in range(1000000):
        await RisingEdge(caravelEnv.clk)
        pin21_val = caravelEnv.monitor_gpio(21, 21).binstr
        if pin21_val == '0':
            cs2_found = True
            break

    assert cs2_found, "TEST FAILED: Wildcat never pulled CS2_n LOW!"

    cocotb.log.info("SUCCESS: CS2_n went low! PSRAM B SPI Transaction started.")
    cocotb.log.info("[TEST] pass")