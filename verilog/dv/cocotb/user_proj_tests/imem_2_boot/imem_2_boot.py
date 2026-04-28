# SPDX-FileCopyrightText: 2023 Efabless Corporation

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SPDX-License-Identifier: Apache-2.0


from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from cocotb.triggers import ClockCycles

@cocotb.test()
@report_test
async def imem_2_boot(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=100000)

    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("[TEST] GPIO configured, watching for blink on pin 24")



    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("GPIO went High")
    led = False
    blinkCounter = 0

    for _ in range(100000):
        val = caravelEnv.monitor_gpio(24, 24)
        if val == 1:
            if led == False:
                led = True
                blinkCounter = blinkCounter + 1
                cocotb.log.info("[TEST] Blink Counter: " + str(blinkCounter))
        elif val == 0:
            if led == True:
                led = False
        if blinkCounter >= 5:
            cocotb.log.info("[TEST] Success")
            return
        await ClockCycles(caravelEnv.clk, 1)

    assert False, "LED never went high - Wildcat is not running"