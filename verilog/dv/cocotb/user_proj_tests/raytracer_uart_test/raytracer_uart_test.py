from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb
from cocotb.triggers import ClockCycles


# rayTx is wired to GPIO pin 6 (CaravelUserProject.scala). The dedicated
# BufferedTx runs at 10 MHz / 115200 baud, so each bit period is ~87 user-clock
# cycles. A 2x2 frame produces 4 bytes (~40 bit periods), but we exit early
# once we see enough pin activity to confirm the FIFO -> BufferedTx -> pin path
# is functional -- exact bytes are already verified by the Chisel suite.
RAYTX_PIN = 6
WATCH_CYCLES = 1500000
MIN_EDGES = 4  # 4 bytes have at least 8 edges; 4 is a comfortable floor


@cocotb.test()
@report_test
async def raytracer_uart_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=700000)
    await caravelEnv.release_csb()

    cocotb.log.info("[TEST] Waiting for Caravel to signal that Wildcat has started rendering")
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info(f"[TEST] Watching GPIO pin {RAYTX_PIN} for serial activity")

    last = caravelEnv.monitor_gpio(RAYTX_PIN, RAYTX_PIN).integer
    edges = 0
    saw_low = (last == 0)
    saw_high = (last == 1)

    for _ in range(WATCH_CYCLES):
        cur = caravelEnv.monitor_gpio(RAYTX_PIN, RAYTX_PIN).integer
        if cur != last:
            edges += 1
            last = cur
        if cur == 0:
            saw_low = True
        else:
            saw_high = True
        if edges >= MIN_EDGES and saw_low and saw_high:
            cocotb.log.info(f"[TEST] Success -- observed {edges} edges on rayTx within window")
            return
        await ClockCycles(caravelEnv.clk, 1)

    assert False, (
        f"rayTx pin {RAYTX_PIN} did not show enough serial activity: "
        f"edges={edges}, saw_low={saw_low}, saw_high={saw_high}"
    )
