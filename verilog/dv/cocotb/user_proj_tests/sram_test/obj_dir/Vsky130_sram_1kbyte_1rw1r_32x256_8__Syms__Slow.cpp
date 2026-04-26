// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vsky130_sram_1kbyte_1rw1r_32x256_8__pch.h"

Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms::Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms(VerilatedContext* contextp, const char* namep, Vsky130_sram_1kbyte_1rw1r_32x256_8* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup top module instance
    , TOP{this, namep}
{
    // Check resources
    Verilated::stackCheck(158);
    // Setup sub module instances
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    // Setup scopes
}

Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms::~Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms() {
    // Tear down scopes
    // Tear down sub module instances
}
