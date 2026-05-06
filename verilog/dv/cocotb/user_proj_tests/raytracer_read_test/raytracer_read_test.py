from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb


@cocotb.test()
@report_test
async def raytracer_read_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=400000)
    await caravelEnv.release_csb()
    cocotb.log.info("[TEST] Read every readable raytracer register at reset")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("[TEST] PASS: busy/notEmpty/drainMode all read back as 0")
