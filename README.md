# Micro-16-CPU

A 16-bit CPU architecture with assembler, C compiler.

## Quick Start

```bash
# Assemble an ASM program
./masm program.asm

# Compile C program
./microcc program.c


```

## Architecture Overview

- **Word Size**: 16-bit
- **Instruction Size**: 32-bit (fixed width)
- **Address Space**: 64KB
- **Registers**: 16 (R0-R15, where R13=SP, R14=LR, R15=PC)

### Register Map

| Register | Name | Description |
|----------|------|-------------|
| R0 | ACC | Accumulator (result register for ALU ops) |
| R1-R12 | GP | General purpose |
| R13 | SP | Stack Pointer |
| R14 | LR | Link Register (return address) |
| R15 | PC | Program Counter |

### Instruction Set

| Opcode | Mnemonic | Type | Description |
|--------|----------|------|-------------|
| 0x01 | MOVI | I | Load immediate |
| 0x02 | MOV | R | Register copy |
| 0x03 | ADD | R | Add (result in R0) |
| 0x04 | SUB | R | Subtract (result in R0) |
| 0x05 | MUL | R | Multiply (result in R0) |
| 0x06 | DIV | R | Divide (result in R0) |
| 0x07 | ADDI | I | Add immediate |
| 0x08 | STR | I | Store to memory |
| 0x09 | LOAD | I | Load from memory |
| 0x0A | JMP | J | Jump |
| 0x0B | JEQ | J | Jump if equal |
| 0x0C | JNE | J | Jump if not equal |
| 0x0D | JLT | J | Jump if less than |
| 0x0E | JGT | J | Jump if greater than |
| 0x0F | AND | R | Bitwise AND |
| 0x10 | OR | R | Bitwise OR |
| 0x11 | XOR | R | Bitwise XOR |
| 0x12 | NOT | R | Bitwise NOT |
| 0x13 | CMP | R | Compare (sets flags) |
| 0x14 | SHL | I | Shift left |
| 0x15 | SHR | I | Shift right |
| 0x16 | PUSH | R | Push to stack |
| 0x17 | POP | R | Pop from stack |
| 0x18 | CALL | J | Call subroutine |
| 0x19 | RET | J | Return |
| 0x1A | HLT | J | Halt CPU |
| 0x1B | NOP | J | No operation |

### Memory Map

| Address | Size | Description |
|---------|------|-------------|
| 0x0000-0x001F | 32B | Reset vector |
| 0x0020-0x01FF | 480B | Boot ROM |
| 0x0200-0x02FF | 256B | Stack |
| 0x0300-0x3FFF | 15.75KB | Program RAM |
| 0x4000-0xDFFF | 48KB | Data RAM |
| 0xE000 | - | Serial port |
| 0xE001 | - | Keyboard input |
| 0xE003-0xE009 | - | VGA I/O |

## Tools

### MASM Assembler

Assembles Micro-16 assembly language into hex format.

```asm
; Example
        MOVI R1, 42
        MOVI R2, 100
        ADD R1, R2      ; R0 = R1 + R2
        STR R0, 0x4000  ; Store to data RAM
        HLT
```

Output is one 8-digit hex word per line (32-bit instruction).

### Micro-16 C Compiler

Compiles a subset of C to Micro-16 assembly.


## Files

```
.
├── masm              # Assembler
├── microcc           # C compiler
├── ISA/              # ISA documentation
│   └── Micro-16.csv
├── Example_Programm_ASM/
│   └── displaytest.asm
├── EXAMPLE_C/
│   └── *.c
```


## License

See LICENSE file.
