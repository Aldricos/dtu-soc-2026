// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms.h"


VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_init_sub__TOP__0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_init_sub__TOP__0\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->pushPrefix("$rootio", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+5,0,"clk0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+6,0,"csb0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+7,0,"web0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+8,0,"wmask0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+9,0,"addr0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+10,0,"din0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+11,0,"dout0",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+12,0,"clk1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+13,0,"csb1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+14,0,"addr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+15,0,"dout1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("sky130_sram_1kbyte_1rw1r_32x256_8", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+18,0,"NUM_WMASKS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+19,0,"DATA_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+20,0,"ADDR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+21,0,"RAM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+22,0,"DELAY",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+23,0,"VERBOSE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+24,0,"T_HOLD",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+5,0,"clk0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+6,0,"csb0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+7,0,"web0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+8,0,"wmask0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+9,0,"addr0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+10,0,"din0",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+11,0,"dout0",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+12,0,"clk1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+13,0,"csb1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+14,0,"addr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+15,0,"dout1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+0,0,"csb0_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"web0_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+2,0,"wmask0_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+3,0,"addr0_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+4,0,"din0_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+16,0,"csb1_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+17,0,"addr1_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_init_top(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_init_top\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_register(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_register\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0_sub_0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0\n"); );
    // Body
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsky130_sram_1kbyte_1rw1r_32x256_8___024root*>(voidSelf);
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0_sub_0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_const_0_sub_0\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+18,(4U),32);
    bufp->fullIData(oldp+19,(0x00000020U),32);
    bufp->fullIData(oldp+20,(8U),32);
    bufp->fullIData(oldp+21,(0x00000100U),32);
    bufp->fullIData(oldp+22,(3U),32);
    bufp->fullIData(oldp+23,(0U),32);
    bufp->fullIData(oldp+24,(1U),32);
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0_sub_0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0\n"); );
    // Body
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsky130_sram_1kbyte_1rw1r_32x256_8___024root*>(voidSelf);
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0_sub_0(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_full_0_sub_0\n"); );
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullBit(oldp+0,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb0_reg));
    bufp->fullBit(oldp+1,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__web0_reg));
    bufp->fullCData(oldp+2,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__wmask0_reg),4);
    bufp->fullCData(oldp+3,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr0_reg),8);
    bufp->fullIData(oldp+4,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__din0_reg),32);
    bufp->fullBit(oldp+5,(vlSelfRef.clk0));
    bufp->fullBit(oldp+6,(vlSelfRef.csb0));
    bufp->fullBit(oldp+7,(vlSelfRef.web0));
    bufp->fullCData(oldp+8,(vlSelfRef.wmask0),4);
    bufp->fullCData(oldp+9,(vlSelfRef.addr0),8);
    bufp->fullIData(oldp+10,(vlSelfRef.din0),32);
    bufp->fullIData(oldp+11,(vlSelfRef.dout0),32);
    bufp->fullBit(oldp+12,(vlSelfRef.clk1));
    bufp->fullBit(oldp+13,(vlSelfRef.csb1));
    bufp->fullCData(oldp+14,(vlSelfRef.addr1),8);
    bufp->fullIData(oldp+15,(vlSelfRef.dout1),32);
    bufp->fullBit(oldp+16,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__csb1_reg));
    bufp->fullCData(oldp+17,(vlSelfRef.sky130_sram_1kbyte_1rw1r_32x256_8__DOT__addr1_reg),8);
}
