#ifndef CPU16_STDLIB_H
#define CPU16_STDLIB_H

/*
 * Micro-16 Standard Library Header
 * Note: These functions are implemented as compiler intrinsics.
 */

/* --- Console I/O --- */
/* Prints a string to the serial console (0xE000) */
void puts(char* s);

/* Prints a single character to the serial console */
void putc(char c);

/* Basic print formatted - currently supports strings and integers */
void printf(char* format, ...);

/* Reads a single character from keyboard (0xE001) */
int getchar();

/* Reads formatted input from keyboard */
int scanf(char* format, ...);

/* --- VGA I/O --- */
/* Draws a pixel at (x, y) with color */
void vga_putpixel(int x, int y, int color);

/* Clears the VGA screen */
void vga_clear();

#endif
