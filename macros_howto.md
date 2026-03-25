
# A short guide on how to use Macros

## Declare Vdd and Vss nets

In order to use macros, we need explicitly named Vdd and Vss nets, such that we can connect them to the macros power pins.

```json
"VDD_NETS": [
    "vccd1"
],
"GND_NETS": [
    "vssd1"
],
```

## Declare macros

Now you need to know your full hierarchical path to the macro instance(s) in your design starting from inside the `user_project_wrapper` module.

Next you need to decide on a location and orientation for each macro instance. The coordinate you pass is the location of the lower left corner of the macro. Use an orientation of "N" for no rotation.

Finally, you have to collect the GDS, LEF, a verilog file containing at least the IO definition of the macro, and a liberty file for the macro. 

All of this information is then added to the JSON config file. This example show how to use two instances of the `sky130_sram_1kbyte_1rw1r_32x256_8` macro.

```json

"MACROS": {
    "sky130_sram_1kbyte_1rw1r_32x256_8": {
        "instances": {
            "path.to.my.instance1": {
                "location": [
                    x1,
                    y1
                ],
                "orientation": "N"
            },
            "path.to.my.instance2": {
                "location": [
                    x2,
                    y2
                ],
                "orientation": "N"
            }
        },
        "gds": [
            "pdk_dir::libs.ref/sky130_sram_macros/gds/sky130_sram_1kbyte_1rw1r_32x256_8.gds"
        ],
        "lef": [
            "pdk_dir::libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_32x256_8.lef"
        ],
        "nl": [
            "pdk_dir::libs.ref/sky130_sram_macros/verilog/sky130_sram_1kbyte_1rw1r_32x256_8.v"
        ],
        "lib": {
            "*": "pdk_dir::libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib"
        }
    },
    "another_macro": {
        "instances": {
            "path.to.another.instance": {
                "location": [
                    x3,
                    y3
                ],
                "orientation": "N"
            }
        },
        "gds": [
            "dir::../../gds/another_macro.gds"
        ],
        "lef": [
            "dir::../../lef/another_macro.lef"
        ],
        "nl": [
            "dir::../../verilog/another_macro.v"
        ],
        "lib": {
            "*": "dir::../../lib/another_macro.lib"
        }
    }
},
```

Note that you can use the `pdk_dir::` prefix to refer to the PDK directory, and `dir::` to refer to the directory of the JSON config file.


### Connect the macros to power

Finally, you need to connect the power pins of the macro instances to the Vdd and Vss nets you declared earlier. You do this by adding the following to the JSON config file. The syntax is `instance_path vdd_net vss_net vdd_macro_pin vss_macro_pin`. 

```json
"PDN_MACRO_CONNECTIONS": [
    "path.to.my.instance1 vccd1 vssd1 vccd1 vssd1",
    "path.to.my.instance2 vccd1 vssd1 vccd1 vssd1",
    "path.to.another.instance vccd1 vssd1 vccd1 vssd1"
],
```