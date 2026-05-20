# Micro-16 on FPGA, with external EEPROM as instruction store

A synthesisable Verilog implementation of your **Micro-16 (M-16)** ISA,
targeting Cyclone 10 LP, that fetches instructions byte-by-byte from a
parallel async **EEPROM** (AT28C256, SST39SF010, anything with that
interface) over real pins.

```
                +-------------+      ee_a[14:0]
                |             | -------------------->  +-----------+
                |   cpu16_    |      ee_d[7:0]        |   parall.  |
                |   core      | <--------------------  |   EEPROM   |
   16 regs --+  |  (FSM)      |      ee_ce_n/oe_n     |  (AT28C256 |
   ALU/flags |  |             | -------------------->  |   or sim.) |
             |  +------+------+                       +-----------+
             |         | dmem bus (16-bit word)
             |   +-----+-----+-----------+
             |   |           |           |
             |   v           v           v
             | +-----+   +--------+  +--------+
             | |dmem |   |  I/O   |  |  ...   |
             | |BRAM |   | LEDs   |  |  free  |
             | +-----+   | SW     |  +--------+
             |           | UART   |
             |           +--------+
```

## Layout

```
cpu16_fpga/
âââ rtl/                    synthesisable RTL
â   âââ cpu16_core.v        ISA implementation (FSM, regfile, ALU, decoder)
â   âââ eeprom_fetch.v      parallel-EEPROM read controller
â   âââ dmem.v              on-chip BRAM data memory
â   âââ io_block.v          memory-mapped LEDs / switches / UART TX
â   âââ cpu16_top.v         top wrapper, address decoder, reset sync
âââ sim/                    simulation
â   âââ eeprom_model.v      behavioural EEPROM (loads from prog.hex)
â   âââ cpu16_tb.v          smoke-test testbench
â   âââ prog.hex            tiny hand-written program (LEDs blink AA/55)
âââ tools/
â   âââ asm2eeprom.py       converts `masm` output -> byte image + raw .bin
âââ examples/
â   âââ led_blink.asm       slightly bigger demo using ALU, CMP, JLT, OR
âââ constraints/
    âââ cpu16.sdc           Quartus timing constraints
    âââ cpu16_pins.qsf      Cyclone 10 LP pin template (rename pins!)
```

## Memory map (CPU view)

| Range            | Where it physically lives             | Access |
|------------------|----------------------------------------|--------|
| `0x0000..0x3FFF` | external EEPROM (via `ee_*` pins)      | R (instr fetch only) |
| `0x0200..0x02FF` | on-chip BRAM aliased here for stack    | R/W    |
| `0x4000..0xDFFF` | on-chip BRAM                           | R/W    |
| `0xE000..0xE0FF` | memory-mapped I/O                      | R/W    |

I/O ports:

| Addr      | W                    | R                          |
|-----------|----------------------|----------------------------|
| `0xE000`  | UART TX byte         | `{15'h0, uart_busy}`       |
| `0xE020`  | 8 LEDs               | last-written LED value     |
| `0xE021`  | â                    | 8 switches/buttons         |
| `0xE022`  | â                    | free-running cycle counter |

The CPU is parameterised; see the `RESET_PC` / `RESET_SP` defaults
(`0x0300`) at the top of `cpu16_top.v`.

## Simulating

```bash
cd sim
iverilog -g2012 -o tb \
    ../rtl/cpu16_core.v ../rtl/eeprom_fetch.v ../rtl/dmem.v \
    ../rtl/io_block.v   ../rtl/cpu16_top.v \
    eeprom_model.v cpu16_tb.v
vvp tb
gtkwave cpu16.vcd                       # optional
```

Expected output for the bundled `prog.hex`:

```
[3050000]  PC=0304  LEDs=10101010 (0xaa)
[5850000]  PC=030c  LEDs=01010101 (0x55)
[10030000] PC=0304  LEDs=10101010 (0xaa)
...
```

## Running your own program

1. Assemble your ASM with `masm`:
   ```bash
   ./masm myprog.asm                       # produces myprog.hex (32-bit/line)
   ```
2. Convert to a byte image:
   ```bash
   python3 tools/asm2eeprom.py myprog.hex --base 0x0300 --size 0x8000 \
       -o sim/prog.hex --bin myprog.bin
   ```
   - `sim/prog.hex` is what the testbench reads via `$readmemh`.
   - `myprog.bin` is what you flash onto a real EEPROM with a TL866 / minipro
     / homemade programmer.

   Add `--reset-stub` to also place a tiny stub at `0x0000` that sets the
   stack pointer and jumps to your base â useful if you want to use the
   ISA's real reset vector instead of the parameterised `RESET_PC`.

## Building for the FPGA

1. Create a Quartus project for your Cyclone 10 LP variant.
2. Add every file under `rtl/`.
3. Add `constraints/cpu16.sdc` to the project.
4. Open `constraints/cpu16_pins.qsf` and **replace every `PIN_xx` with the
   real pins from your board's pinout document.** The current values are
   placeholders. Especially:
   - 15 address pins -> EEPROM `A0..A14`
   - 8 data pins -> EEPROM `D0..D7`
   - `ee_ce_n` -> EEPROM `CE#`
   - `ee_oe_n` -> EEPROM `OE#`
   - `ee_we_n` -> EEPROM `WE#` (held high, so this is just a sanity wire)
5. Verify the `T_ACCESS_CYCLES` parameter on `cpu16_top`:
   - AT28C256-15 (150 ns) @ 50 MHz -> 16 is comfortable
   - AT28C256-25 (250 ns) @ 50 MHz -> bump to 24
   - SST39SF010-70 (70 ns) @ 50 MHz -> 8 is enough
6. Compile, program the FPGA, burn `myprog.bin` to the EEPROM, plug them
   together, hit reset, watch LEDs.

## Wiring an AT28C256 to your dev board

```
EEPROM pin   signal            FPGA pin (top wrapper)
---------------------------------------------------------
1   A14      ee_a[14]
2   A12      ee_a[12]
3   A7       ee_a[7]
4   A6       ee_a[6]
5   A5       ee_a[5]
6   A4       ee_a[4]
7   A3       ee_a[3]
8   A2       ee_a[2]
9   A1       ee_a[1]
10  A0       ee_a[0]
11  D0       ee_d[0]
12  D1       ee_d[1]
13  D2       ee_d[2]
14  GND      GND
15  D3       ee_d[3]
16  D4       ee_d[4]
17  D5       ee_d[5]
18  D6       ee_d[6]
19  D7       ee_d[7]
20  CE#      ee_ce_n
21  A10      ee_a[10]
22  OE#      ee_oe_n
23  A11      ee_a[11]
24  A9       ee_a[9]
25  A8       ee_a[8]
26  A13      ee_a[13]
27  WE#      ee_we_n
28  VCC      +5V (or +3.3V if your part is dual-voltage; check datasheet!)
```

A 100 nF decoupling cap right at pin 28 of the EEPROM, and a 10 kÎ© pullup
on `WE#` to its own VCC are good ideas. If the EEPROM runs at 5 V and the
FPGA bank is 3.3 V, put a level-shifter (or at minimum a series resistor +
clamp diodes) on `ee_d[7:0]` â 5 V into a 3.3 V bank will damage the FPGA
over time.

## Known limitations / future work

- **R32 not implemented**: the CSV mentions an `R8:R7` 32-bit alias used
  by a `STR32` instruction. There's no `STR32` opcode in the table, so
  this build ignores it. Add an opcode and a 32-bit data path through
  `dmem` if you need it.
- **Boot ROM region (0x0020..0x01FF)**: aliased to BRAM here. If you want
  real boot ROM behaviour, route data reads in that range through the
  EEPROM controller too (extra port, or share the one I-fetch port with
  arbitration).
- **VGA / keyboard / etc.**: the I/O block only has LEDs / switches /
  UART. Plug your existing `vga_text.v` and friends into `cpu16_top`
  alongside `io_block` and extend the address decoder.
- **Instruction cache**: there isn't one. Every fetch goes to the EEPROM
  and takes ~4 Ã T\_ACCESS\_CYCLES cycles. A 1-entry latch in front of
  `eeprom_fetch` would already double effective throughput on tight loops.
