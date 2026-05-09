; ============================================================
; Micro-16 Assembler — made by Oliver Petz
; Quelldatei: /mnt/user-data/uploads/test_lib.c
; ============================================================

; Einstiegspunkt
        JMP  main_entry

func_main:
        PUSH R14             ; LR sichern
        ; vga_clear() - unrolled (VGA: 0xE003..0xE009)
        MOVI R0,  0x0000
        STR  R0,  0xE003
        STR  R0,  0xE004
        STR  R0,  0xE005
        STR  R0,  0xE006
        STR  R0,  0xE007
        STR  R0,  0xE008
        STR  R0,  0xE009
        MOVI R0,  0x000A        ; Konstante 10
        MOV  R1,  R0        ; x
        MOVI R0,  0x000A        ; Konstante 10
        MOVI R0,  0x1023        ; Konstante 4131
        MOV  R3,  R0        ; color
        ; vga_putpixel: index = x % 7 -> slot 0xE003..0xE009
        MOV  R4,  R1        ; R4 = x
vga_mod7_0:
        MOVI R5,  0x0007
        CMP  R4,  R5
        JLT  vga_mod7_done_0
        SUB  R4,  R5        ; R0 = R4 - 7
        MOV  R4,  R0
        JMP  vga_mod7_0
vga_mod7_done_0:
        ; dispatch on index
        MOVI R5,  0x0000
        CMP  R4,  R5
        JEQ  vga_pp_0_0
        MOVI R5,  0x0001
        CMP  R4,  R5
        JEQ  vga_pp_0_1
        MOVI R5,  0x0002
        CMP  R4,  R5
        JEQ  vga_pp_0_2
        MOVI R5,  0x0003
        CMP  R4,  R5
        JEQ  vga_pp_0_3
        MOVI R5,  0x0004
        CMP  R4,  R5
        JEQ  vga_pp_0_4
        MOVI R5,  0x0005
        CMP  R4,  R5
        JEQ  vga_pp_0_5
        JMP  vga_pp_0_6
vga_pp_0_0:
        STR  R3,  0xE003
        JMP  vga_pp_0_done
vga_pp_0_1:
        STR  R3,  0xE004
        JMP  vga_pp_0_done
vga_pp_0_2:
        STR  R3,  0xE005
        JMP  vga_pp_0_done
vga_pp_0_3:
        STR  R3,  0xE006
        JMP  vga_pp_0_done
vga_pp_0_4:
        STR  R3,  0xE007
        JMP  vga_pp_0_done
vga_pp_0_5:
        STR  R3,  0xE008
        JMP  vga_pp_0_done
vga_pp_0_6:
        STR  R3,  0xE009
vga_pp_0_done:
        ; puts("VGA Test")
        MOVI R0,  0x0056
        STR  R0,  0xE000
        MOVI R0,  0x0047
        STR  R0,  0xE000
        MOVI R0,  0x0041
        STR  R0,  0xE000
        MOVI R0,  0x0020
        STR  R0,  0xE000
        MOVI R0,  0x0054
        STR  R0,  0xE000
        MOVI R0,  0x0065
        STR  R0,  0xE000
        MOVI R0,  0x0073
        STR  R0,  0xE000
        MOVI R0,  0x0074
        STR  R0,  0xE000
        MOVI R0,  0x000A     ; newline (LF)
        STR  R0,  0xE000
        ; getchar() - read from keyboard MMIO
        LOAD R0,  0xE001    ; keyboard data register
        STR  R0,  0x02FD        ; lokal 'c' speichern
        MOVI R0,  0x0000        ; Konstante 0
        JMP  ret_main  ; return
ret_main:
        POP  R14             ; LR wiederherstellen
        RET


main_entry:
        MOVI R13, 0x02FF     ; Stack Pointer initialisieren
        CALL func_main       ; main() aufrufen
        HLT                  ; Programm Ende

; ============================================================
; Ende des erzeugten Codes
; ============================================================
