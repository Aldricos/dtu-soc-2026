from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb
from cocotb.triggers import ClockCycles

@cocotb.test()
@report_test
async def floating_point_test(dut):
    caravelEnv = await test_configure(dut,timeout_cycles=100000)

    cocotb.log.info(f"[TEST] Start Caravel Wildcat communication test")  
    # wait for start of sending
    await caravelEnv.release_csb()

    cocotb.log.info(f"[TEST] Waiting for Caravel to signal pass")  
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info(f"[TEST] Received Caravel pass signal")
