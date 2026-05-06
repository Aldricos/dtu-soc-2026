from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb


@cocotb.test()
@report_test
async def raytracer_write_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=400000)
    await caravelEnv.release_csb()
    cocotb.log.info("[TEST] Roundtrip drainMode + write every other writable raytracer register")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("[TEST] PASS: all 12 writable addresses ack'd; drainMode roundtripped 0->1->0")
