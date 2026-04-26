// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsky130_sram_1kbyte_1rw1r_32x256_8.h for the primary calling header

#include "Vsky130_sram_1kbyte_1rw1r_32x256_8__pch.h"

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___ctor_var_reset(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf);

Vsky130_sram_1kbyte_1rw1r_32x256_8___024root::Vsky130_sram_1kbyte_1rw1r_32x256_8___024root(Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* symsp, const char* namep)
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___ctor_var_reset(this);
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vsky130_sram_1kbyte_1rw1r_32x256_8___024root::~Vsky130_sram_1kbyte_1rw1r_32x256_8___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
