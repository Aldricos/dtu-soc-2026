from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb
from cocotb.triggers import ClockCycles


@cocotb.test()
@report_test
async def raytracer_mmio_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=700000)

    cocotb.log.info("[TEST] Start raytracer MMIO drain test")
    await caravelEnv.release_csb()

    cocotb.log.info("[TEST] Waiting for Caravel to signal pass")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("[TEST] Received pass signal -- raytracer rendered 2x2 frame and drained 4 pixels via MMIO")
