// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsky130_sram_1kbyte_1rw1r_32x256_8.h for the primary calling header

#include "Vsky130_sram_1kbyte_1rw1r_32x256_8__pch.h"

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_static(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_static\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk0__0 = vlSelfRef.clk0;
    vlSelfRef.__Vtrigprevexpr___TOP__clk1__0 = vlSelfRef.clk1;
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_initial(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_initial\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_final(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_final\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_settle(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_settle\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

bool Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk0)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @(posedge clk1)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 2U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 2 is active: @(negedge clk0)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 3U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 3 is active: @(negedge clk1)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___ctor_var_reset(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___ctor_var_reset\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17739559317957316560ull);
    vlSelf->csb0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14573171700645871304ull);
    vlSelf->web0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10210460175209563791ull);
    vlSelf->wmask0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 17665742468796096796ull);
    vlSelf->addr0 = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 7068610893040530294ull);
    vlSelf->din0 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15142701478333046853ull);
    vlSelf->dout0 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4013814753626335657ull);
    vlSelf->clk1 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9289893111844944303ull);
    vlSelf->csb1 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17020911431705273539ull);
    vlSelf->addr1 = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 15968487972278380365ull);
    vlSelf->dout1 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7302586033294002808ull);
    vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb0_reg = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16627459221208482941ull);
    vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__web0_reg = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16035921134005256504ull);
    vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 16216907818592490088ull);
    vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 11469148927978853406ull);
    vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7669654126722581038ull);
    vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb1_reg = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12002270616453159727ull);
    vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr1_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 8730157404552765613ull);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 141867057474965492ull);
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk0__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__clk1__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
