/*
 * Micro16.h - Compatibility header for cpu16cc v3
 *
 * printf(str)     -> printasm(str)   [string literals only]
 * puts(str)       -> printasm(str)
 * putchar(c)      -> printchar(c)
 * print(str)      -> printasm(str)
 * print_char(c)   -> printchar(c)
 * nl()            -> printchar(10)
 * sp()            -> printchar(32)
 *
 * NOTE: getchar/putchar/puts/printf are real wrapper functions,
 *       not macros, because the preprocessor does not support
 *       function-style macros.
 *
 * Functions: getchar, putchar, puts, printf,
 *            print_int, print_hex, print_str,
 *            println_int, println_str, read_int,
 *            wait_enter, abs_val, max_val, min_val,
 *            clamp, str_len, int_to_bool
 */

#ifndef MICRO16_H
#define MICRO16_H

#define NULL 0
#define true 1
#define false 0
#define bool int
#define uint int
#define size_t int

#define nl()            printchar(10)
#define sp()            printchar(32)
#define println()       printchar(10)
#define print_newline() printchar(10)

int getchar() {
    return scanasm();
}

int putchar(int c) {
    printchar(c);
    return c;
}

int print_char(int c) {
    printchar(c);
    return c;
}

int print_int(int n) {
    int digits[8];
    int count;
    count = 0;
    if (n == 0) {
        printchar(48);
        return 0;
    }
    if (n < 0) {
        printchar(45);
        n = 0 - n;
    }
    while (n > 0) {
        digits[count] = n % 10;
        n = n / 10;
        count = count + 1;
    }
    while (count > 0) {
        count = count - 1;
        printchar(digits[count] + 48);
    }
    return 0;
}

int print_hex(int n) {
    int nibble;
    printchar(48);
    printchar(120);
    nibble = (n >> 12) & 15;
    if (nibble < 10) { printchar(nibble + 48); } else { printchar(nibble - 10 + 65); }
    nibble = (n >> 8) & 15;
    if (nibble < 10) { printchar(nibble + 48); } else { printchar(nibble - 10 + 65); }
    nibble = (n >> 4) & 15;
    if (nibble < 10) { printchar(nibble + 48); } else { printchar(nibble - 10 + 65); }
    nibble = n & 15;
    if (nibble < 10) { printchar(nibble + 48); } else { printchar(nibble - 10 + 65); }
    return 0;
}

int print_str(int ptr) {
    int i;
    int ch;
    i = 0;
    ch = ptr[i];
    while (ch != 0) {
        printchar(ch);
        i = i + 1;
        ch = ptr[i];
    }
    return 0;
}

int println_int(int n) {
    print_int(n);
    printchar(10);
    return 0;
}

int println_str(int ptr) {
    print_str(ptr);
    printchar(10);
    return 0;
}

int abs_val(int n) {
    if (n < 0) {
        return 0 - n;
    }
    return n;
}

int max_val(int a, int b) {
    if (a > b) {
        return a;
    }
    return b;
}

int min_val(int a, int b) {
    if (a < b) {
        return a;
    }
    return b;
}

int clamp(int val, int lo, int hi) {
    if (val < lo) {
        return lo;
    }
    if (val > hi) {
        return hi;
    }
    return val;
}

int str_len(int ptr) {
    int i;
    i = 0;
    while (ptr[i] != 0) {
        i = i + 1;
    }
    return i;
}

int int_to_bool(int n) {
    if (n != 0) {
        return 1;
    }
    return 0;
}

int read_int() {
    int result;
    int ch;
    int neg;
    result = 0;
    neg = 0;
    ch = scanasm();
    if (ch == 45) {
        neg = 1;
        ch = scanasm();
    }
    while (ch >= 48 && ch <= 57) {
        result = result * 10 + (ch - 48);
        ch = scanasm();
    }
    if (neg == 1) {
        return 0 - result;
    }
    return result;
}

int wait_enter() {
    int ch;
    ch = 0;
    while (ch != 13 && ch != 10) {
        ch = scanasm();
    }
    return 0;
}

#endif
