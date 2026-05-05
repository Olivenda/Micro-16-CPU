; =============================================================================
; Micro-16 BIOS - Minimal boot
;
; Memory layout:
;   0x0000 - 0x01FF  ROM (this BIOS)
;   0x0200 - 0x02FF  Stack  (SP = 0x02FF)
;   0x0300 - 0x3FFF  RAM CODE
;   0x4000 - 0xFFFF  RAM DATA
;
; Boot flow:
;   1. Init SP
;   2. RAM test (0xA5A5 to 0x0300, read back)
;      fail -> store 0xDEAD @ 0x4000, HLT
;      pass -> clear regs, JMP 0x0300
; =============================================================================

        MOVI R13, 0x02FF        ; init stack pointer

        ; --- RAM test ---
        MOVI R1,  0xA5A5
        STR  R1,  0x0300
        LOAD R2,  0x0300
        CMP  R2,  R1
        JNE  BOOT_FAIL

        ; --- clear test location + regs ---
        MOVI R0,  0x0000
        STR  R0,  0x0300
        MOVI R1,  0x0000
        MOVI R2,  0x0000
        MOVI R3,  0x0000
        JMP  0x0300             ; hand off

BOOT_FAIL:
        MOVI R2,  0xDEAD
        STR  R2,  0x4000
        HLT
