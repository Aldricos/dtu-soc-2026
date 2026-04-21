
from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb

@cocotb.test()
@report_test
async def wb_inst_mem_test(dut):
    caravelEnv = await test_configure(dut,timeout_cycles=27649)

    cocotb.log.info(f"[TEST] Start Inst mem test")
    # wait for start of sending
    await caravelEnv.release_csb()

    cocotb.log.info(f"[TEST] Waiting Inst mem to signal pass")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info(f"[TEST] Received Inst mem pass signal")
