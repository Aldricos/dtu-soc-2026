from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb
from cocotb.triggers import ClockCycles

@cocotb.test()
@report_test
async def video_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=700000)

    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("[TEST] GPIO configured, waiting for horizontal sync pulse to start")

    state = "waiting"
    cycles = 0
    ACTIVE = 200
    FRONT_PORCH = 10
    SYNC_PULSE = 32
    BACK_PORCH = 22
    EXPECTED_CYCLES = ACTIVE + FRONT_PORCH + SYNC_PULSE + BACK_PORCH

    for _ in range(100000):
        hSync = caravelEnv.monitor_gpio(23, 23)
        if hSync == 0 and state == "waiting":
            state = "sync_pulse"
            cycles = 0
            cocotb.log.info("[TEST] horizontal sync pulse started, waiting for horizontal sync pulse to stop")
        if hSync == 1 and state == "sync_pulse":
            assert cycles == SYNC_PULSE, f"expected horizontal sync pulse to last {SYNC_PULSE} cycles but lasted {cycles} cycles"
            state = "active_video"
            cycles = 0
            cocotb.log.info("[TEST] horizontal sync pulse stopped, waiting for horizontal sync pulse to start")
        if hSync == 0 and state == "active_video":
            assert cycles == BACK_PORCH + ACTIVE + FRONT_PORCH, f"expected active video to last {BACK_PORCH + ACTIVE + FRONT_PORCH} cycles but lasted {cycles} cycles"
            cocotb.log.info("[TEST] Success")
            return
        assert cycles < ACTIVE + FRONT_PORCH + SYNC_PULSE + BACK_PORCH, "horizontal sync did not change in time"
        cycles += 1
        await ClockCycles(caravelEnv.clk, 1)
