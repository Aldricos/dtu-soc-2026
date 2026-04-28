from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
@report_test
async def spi_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=100000)

    cocotb.log.info("Waiting for Management Core to configure IOs...")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("IOs configured! Wildcat is running...")

    cocotb.log.info("Monitoring CS1_n (Pin 4). Waiting for Wildcat to trigger PSRAM A...")

    cs1_found = False
    for _ in range(1000000):
        await RisingEdge(caravelEnv.clk)
        pin4_val = caravelEnv.monitor_gpio(4, 4).binstr
        if pin4_val == '0':
            cs1_found = True
            break

    assert cs1_found, "TEST FAILED: Wildcat never pulled CS1_n LOW!"

    cocotb.log.info("SUCCESS: CS1_n went low! SPI Transaction started.")
    cocotb.log.info("[TEST] pass")