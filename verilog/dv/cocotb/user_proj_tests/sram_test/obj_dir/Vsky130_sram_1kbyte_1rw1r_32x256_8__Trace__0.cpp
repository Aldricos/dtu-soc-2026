// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms.h"


void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0_sub_0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0\n"); );
    // Body
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsky130_sram_1kbyte_1rw1r_32x256_8___024root*>(voidSelf);
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0_sub_0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0_sub_0\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgBit(oldp+0,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb0_reg));
        bufp->chgBit(oldp+1,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__web0_reg));
        bufp->chgCData(oldp+2,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg),4);
        bufp->chgCData(oldp+3,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg),8);
        bufp->chgIData(oldp+4,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg),32);
    }
    bufp->chgBit(oldp+5,(vlSelfRef.clk0));
    bufp->chgBit(oldp+6,(vlSelfRef.csb0));
    bufp->chgBit(oldp+7,(vlSelfRef.web0));
    bufp->chgCData(oldp+8,(vlSelfRef.wmask0),4);
    bufp->chgCData(oldp+9,(vlSelfRef.addr0),8);
    bufp->chgIData(oldp+10,(vlSelfRef.din0),32);
    bufp->chgIData(oldp+11,(vlSelfRef.dout0),32);
    bufp->chgBit(oldp+12,(vlSelfRef.clk1));
    bufp->chgBit(oldp+13,(vlSelfRef.csb1));
    bufp->chgCData(oldp+14,(vlSelfRef.addr1),8);
    bufp->chgIData(oldp+15,(vlSelfRef.dout1),32);
    bufp->chgBit(oldp+16,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb1_reg));
    bufp->chgCData(oldp+17,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr1_reg),8);
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_cleanup\n"); );
    // Body
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsky130_sram_1kbyte_1rw1r_32x256_8___024root*>(voidSelf);
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
