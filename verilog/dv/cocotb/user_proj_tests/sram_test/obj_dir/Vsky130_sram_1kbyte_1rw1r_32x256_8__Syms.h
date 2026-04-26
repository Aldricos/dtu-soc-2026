// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VSKY130_SRAM_1KBYTE_1RW1R_32X256_8__SYMS_H_
#define VERILATED_VSKY130_SRAM_1KBYTE_1RW1R_32X256_8__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vsky130_sram_1kbyte_1rw1r_32x256_8.h"

// INCLUDE MODULE CLASSES
#include "Vsky130_sram_1kbyte_1rw1r_32x256_8___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vsky130_sram_1kbyte_1rw1r_32x256_8* const __Vm_modelp;
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vsky130_sram_1kbyte_1rw1r_32x256_8___024root TOP;

    // CONSTRUCTORS
    Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms(VerilatedContext* contextp, const char* namep, Vsky130_sram_1kbyte_1rw1r_32x256_8* modelp);
    ~Vsky130_sram_1kbyte_1rw1r_32x256_8__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
