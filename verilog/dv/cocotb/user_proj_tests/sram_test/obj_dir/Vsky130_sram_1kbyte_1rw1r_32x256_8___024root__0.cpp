// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsky130_sram_1kbyte_1rw1r_32x256_8.h for the primary calling header

#include "Vsky130_sram_1kbyte_1rw1r_32x256_8__pch.h"

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_triggers_vec__act(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_triggers_vec__act\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    (((((~ (IData)(vlSelfRef.clk1)) 
                                                        & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk1__0)) 
                                                       << 3U) 
                                                      | (((~ (IData)(vlSelfRef.clk0)) 
                                                          & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk0__0)) 
                                                         << 2U)) 
                                                     | ((((IData)(vlSelfRef.clk1) 
                                                          & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk1__0))) 
                                                         << 1U) 
                                                        | ((IData)(vlSelfRef.clk0) 
                                                           & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk0__0)))))));
    vlSelfRef.__Vtrigprevexpr___TOP__clk0__0 = vlSelfRef.clk0;
    vlSelfRef.__Vtrigprevexpr___TOP__clk1__0 = vlSelfRef.clk1;
}

bool Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__0\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY((((((~ (IData)(vlSelfRef.csb0)) 
                        & (~ (IData)(vlSelfRef.web0))) 
                       & (~ (IData)(vlSelfRef.csb1))) 
                      & ((IData)(vlSelfRef.addr0) == (IData)(vlSelfRef.addr1)))))) {
        VL_WRITEF_NX("%20# WARNING: Writing and reading addr0=%b and addr1=%b simultaneously!\n",0,
                     64,VL_TIME_UNITED_Q(1),8,(IData)(vlSelfRef.addr0),
                     8,vlSelfRef.addr1);
    }
    vlSelfRef.dout1 = 0U;
    vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb1_reg 
        = vlSelfRef.csb1;
    vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr1_reg 
        = vlSelfRef.addr1;
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__1(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__1\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.dout0 = 0U;
    vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg 
        = vlSelfRef.wmask0;
    vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg 
        = vlSelfRef.din0;
    vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb0_reg 
        = vlSelfRef.csb0;
    vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__web0_reg 
        = vlSelfRef.web0;
    vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg 
        = vlSelfRef.addr0;
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__2(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__2\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __Vdly__dout0;
    __Vdly__dout0 = 0;
    IData/*31:0*/ __VdlyMask__dout0;
    __VdlyMask__dout0 = 0;
    // Body
    if ((1U & ((~ (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb0_reg)) 
               & (~ (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__web0_reg))))) {
        if ((1U & (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg))) {
            vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem[vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg] 
                = ((0xffffff00U & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem
                    [vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg]) 
                   | (0x000000ffU & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg));
        }
        if ((2U & (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg))) {
            vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem[vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg] 
                = ((0xffff00ffU & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem
                    [vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg]) 
                   | (0x0000ff00U & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg));
        }
        if ((4U & (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg))) {
            vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem[vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg] 
                = ((0xff00ffffU & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem
                    [vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg]) 
                   | (0x00ff0000U & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg));
        }
        if ((8U & (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg))) {
            vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem[vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg] 
                = ((0x00ffffffU & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem
                    [vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg]) 
                   | (0xff000000U & vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg));
        }
    }
    if (((~ (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb0_reg)) 
         & (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__web0_reg))) {
        __Vdly__dout0 = vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem
            [vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg];
        __VdlyMask__dout0 = 0xffffffffU;
    }
    vlSelfRef.dout0 = ((__Vdly__dout0 & __VdlyMask__dout0) 
                       | (vlSelfRef.dout0 & (~ __VdlyMask__dout0)));
    __VdlyMask__dout0 = 0U;
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__3(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__3\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __Vdly__dout1;
    __Vdly__dout1 = 0;
    IData/*31:0*/ __VdlyMask__dout1;
    __VdlyMask__dout1 = 0;
    // Body
    if ((1U & (~ (IData)(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb1_reg)))) {
        __Vdly__dout1 = vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__mem
            [vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr1_reg];
        __VdlyMask__dout1 = 0xffffffffU;
    }
    vlSelfRef.dout1 = ((__Vdly__dout1 & __VdlyMask__dout1) 
                       | (vlSelfRef.dout1 & (~ __VdlyMask__dout1)));
    __VdlyMask__dout1 = 0U;
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_nba(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_nba\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((2ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__1(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__2(vlSelf);
    }
    if ((8ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___nba_sequent__TOP__3(vlSelf);
    }
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_phase__act(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_phase__act\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_triggers_vec__act(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    return (0U);
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_phase__nba(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_phase__nba\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_nba(vlSelf);
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("../../../../rtl/sky130_sram_1kbyte_1rw1r_32x256_8.v", 6, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 100 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00000064U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                VL_FATAL_MT("../../../../rtl/sky130_sram_1kbyte_1rw1r_32x256_8.v", 6, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 100 tries");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactPhaseResult = Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_phase__act(vlSelf);
        } while (vlSelfRef.__VactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_debug_assertions(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_debug_assertions\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk0 & 0xfeU)))) {
        Verilated::overWidthError("clk0");
    }
    if (VL_UNLIKELY(((vlSelfRef.csb0 & 0xfeU)))) {
        Verilated::overWidthError("csb0");
    }
    if (VL_UNLIKELY(((vlSelfRef.web0 & 0xfeU)))) {
        Verilated::overWidthError("web0");
    }
    if (VL_UNLIKELY(((vlSelfRef.wmask0 & 0xf0U)))) {
        Verilated::overWidthError("wmask0");
    }
    if (VL_UNLIKELY(((vlSelfRef.clk1 & 0xfeU)))) {
        Verilated::overWidthError("clk1");
    }
    if (VL_UNLIKELY(((vlSelfRef.csb1 & 0xfeU)))) {
        Verilated::overWidthError("csb1");
    }
}
#endif  // VL_DEBUG
