from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb
from cocotb.triggers import ClockCycles

@cocotb.test()
@report_test
async def wildcat_blink_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=10000000)

    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("[TEST] GPIO configured, watching for blink on pin 8")

    for _ in range(1000000):
        val = caravelEnv.monitor_gpio(8, 8)
        if val == 1:
            cocotb.log.info("[TEST] LED went high")
        elif val == 0:
            cocotb.log.info("[TEST] LED went low")
        await ClockCycles(caravelEnv.clk, 1)

    assert False, "LED never went high - Wildcat is not running"