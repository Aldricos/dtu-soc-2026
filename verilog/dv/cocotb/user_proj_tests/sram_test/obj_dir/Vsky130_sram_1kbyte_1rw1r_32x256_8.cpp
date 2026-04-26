// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vsky130_sram_1kbyte_1rw1r_32x256_8__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vsky130_sram_1kbyte_1rw1r_32x256_8::Vsky130_sram_1kbyte_1rw1r_32x256_8(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms(contextp(), _vcname__, this)}
    , clk0{vlSymsp->TOP.clk0}
    , clk1{vlSymsp->TOP.clk1}
    , csb0{vlSymsp->TOP.csb0}
    , web0{vlSymsp->TOP.web0}
    , wmask0{vlSymsp->TOP.wmask0}
    , addr0{vlSymsp->TOP.addr0}
    , csb1{vlSymsp->TOP.csb1}
    , addr1{vlSymsp->TOP.addr1}
    , din0{vlSymsp->TOP.din0}
    , dout0{vlSymsp->TOP.dout0}
    , dout1{vlSymsp->TOP.dout1}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vsky130_sram_1kbyte_1rw1r_32x256_8::Vsky130_sram_1kbyte_1rw1r_32x256_8(const char* _vcname__)
    : Vsky130_sram_1kbyte_1rw1r_32x256_8(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vsky130_sram_1kbyte_1rw1r_32x256_8::~Vsky130_sram_1kbyte_1rw1r_32x256_8() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_debug_assertions(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf);
#endif  // VL_DEBUG
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_static(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf);
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_initial(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf);
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_settle(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf);
void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf);

void Vsky130_sram_1kbyte_1rw1r_32x256_8::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vsky130_sram_1kbyte_1rw1r_32x256_8::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_static(&(vlSymsp->TOP));
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_initial(&(vlSymsp->TOP));
        Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vsky130_sram_1kbyte_1rw1r_32x256_8::eventsPending() { return false; }

uint64_t Vsky130_sram_1kbyte_1rw1r_32x256_8::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vsky130_sram_1kbyte_1rw1r_32x256_8::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_final(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf);

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8::final() {
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vsky130_sram_1kbyte_1rw1r_32x256_8::hierName() const { return vlSymsp->name(); }
const char* Vsky130_sram_1kbyte_1rw1r_32x256_8::modelName() const { return "Vsky130_sram_1kbyte_1rw1r_32x256_8"; }
unsigned Vsky130_sram_1kbyte_1rw1r_32x256_8::threads() const { return 1; }
void Vsky130_sram_1kbyte_1rw1r_32x256_8::prepareClone() const { contextp()->prepareClone(); }
void Vsky130_sram_1kbyte_1rw1r_32x256_8::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vsky130_sram_1kbyte_1rw1r_32x256_8::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_decl_types(VerilatedVcd* tracep);

void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_init_top(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsky130_sram_1kbyte_1rw1r_32x256_8___024root*>(voidSelf);
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(vlSymsp->name(), VerilatedTracePrefixType::SCOPE_MODULE);
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_decl_types(tracep);
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_register(Vsky130_sram_1kbyte_1rw1r_32x256_8___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vsky130_sram_1kbyte_1rw1r_32x256_8::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vsky130_sram_1kbyte_1rw1r_32x256_8::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP), name(), false, 25);
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
