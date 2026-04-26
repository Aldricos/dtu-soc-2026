// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vsky130_sram_1kbyte_1rw1r_32x256_8.h for the primary calling header

#ifndef VERILATED_VSKY130_SRAM_1KBYTE_1RW1R_32X256_8___024ROOT_H_
#define VERILATED_VSKY130_SRAM_1KBYTE_1RW1R_32X256_8___024ROOT_H_  // guard

#include "verilated.h"


class Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vsky130_sram_1kbyte_1rw1r_32x256_8___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk0,0,0);
    VL_IN8(clk1,0,0);
    VL_IN8(csb0,0,0);
    VL_IN8(web0,0,0);
    VL_IN8(wmask0,3,0);
    VL_IN8(addr0,7,0);
    VL_IN8(csb1,0,0);
    VL_IN8(addr1,7,0);
    CData/*0:0*/ sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb0_reg;
    CData/*0:0*/ sky130_sram_1kbyte_1rw1r_32x256_8__DOT__web0_reg;
    CData/*3:0*/ sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg;
    CData/*7:0*/ sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg;
    CData/*0:0*/ sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb1_reg;
    CData/*7:0*/ sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr1_reg;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk0__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk1__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    VL_IN(din0,31,0);
    VL_OUT(dout0,31,0);
    VL_OUT(dout1,31,0);
    IData/*31:0*/ sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 256> sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;

    // INTERNAL VARIABLES
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root(Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* symsp, const char* namep);
    ~Vsky130_sram_1kbyte_1rw1r_32x256_8___024root();
    VL_UNCOPYABLE(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
