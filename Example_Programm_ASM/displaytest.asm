        MOVI R0,  0x0048        ; char 'H' (0x48)
        STR  R0,  0xE000        ; -> output
        MOVI R0,  0x0065        ; char 'e' (0x65)
        STR  R0,  0xE000        ; -> output
        MOVI R0,  0x006C        ; char 'l' (0x6C)
        STR  R0,  0xE000        ; -> output
        MOVI R0,  0x006C        ; char 'l' (0x6C)
        STR  R0,  0xE000        ; -> output
        MOVI R0,  0x006F        ; char 'o' (0x6F)
        STR  R0,  0xE000        ; -> output
        MOVI R0,  0x0021        ; char '!' (0x21)
        STR  R0,  0xE000        ; -> output
        MOVI R0,  0x000A        ; char '.' (0x0A)
        STR  R0,  0xE000        ; -> output
        MOVI R0,  0x0000        ; null terminator
        STR  R0,  0xE000        ; -> end of string
        MOVI R0,  0x0000        ; clear R0
