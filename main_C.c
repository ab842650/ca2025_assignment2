#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include "rsqrt_data.h"

#define printstr(ptr, length)                   \
    do {                                        \
        asm volatile(                           \
            "add a7, x0, 0x40;"                 \
            "add a0, x0, 0x1;" /* stdout */     \
            "add a1, x0, %0;"                   \
            "mv a2, %1;" /* length character */ \
            "ecall;"                            \
            :                                   \
            : "r"(ptr), "r"(length)             \
            : "a0", "a1", "a2", "a7" , "memory");          \
    } while (0)

#define TEST_OUTPUT(msg, length) printstr(msg, length)

#define TEST_LOGGER(msg)                     \
    {                                        \
        char _msg[] = msg;                   \
        TEST_OUTPUT(_msg, sizeof(_msg) - 1); \
    }

extern uint64_t get_cycles(void);
extern uint64_t get_instret(void);

/* Bare metal memcpy implementation */
void *memcpy(void *dest, const void *src, size_t n)
{
    uint8_t *d = (uint8_t *) dest;
    const uint8_t *s = (const uint8_t *) src;
    while (n--)
        *d++ = *s++;
    return dest;
}


uint32_t clz(uint32_t x)
{
    int r = 0, c;
    c = (x < 0x00010000) << 4;
    r += c;
    x <<= c;  // off 16
    c = (x < 0x01000000) << 3;
    r += c;
    x <<= c;  // off 8
    c = (x < 0x10000000) << 2;
    r += c;
    x <<= c;  // off 4
    c = (x < 0x40000000) << 1;
    r += c;
    x <<= c;  // off 2
    c = x < 0x80000000;
    r += c;
    x <<= c;  // off 1
    r += x == 0;
    return r;
}

/* Software division for RV32I (no M extension) */
static unsigned long udiv(unsigned long dividend, unsigned long divisor)
{
    if (divisor == 0)
        return 0;

    unsigned long quotient = 0;
    unsigned long remainder = 0;

    for (int i = 31; i >= 0; i--) {
        remainder <<= 1;
        remainder |= (dividend >> i) & 1;

        if (remainder >= divisor) {
            remainder -= divisor;
            quotient |= (1UL << i);
        }
    }

    return quotient;
}

static unsigned long umod(unsigned long dividend, unsigned long divisor)
{
    if (divisor == 0)
        return 0;

    unsigned long remainder = 0;

    for (int i = 31; i >= 0; i--) {
        remainder <<= 1;
        remainder |= (dividend >> i) & 1;

        if (remainder >= divisor) {
            remainder -= divisor;
        }
    }

    return remainder;
}

/* Software multiplication for RV32I (no M extension) */
static uint32_t umul(uint32_t a, uint32_t b)
{
    uint32_t result = 0;
    while (b) {
        if (b & 1)
            result += a;
        a <<= 1;
        b >>= 1;
    }
    return result;
}

/* Provide __mulsi3 for GCC */
uint32_t __mulsi3(uint32_t a, uint32_t b)
{
    return umul(a, b);
}

/* Simple integer to hex string conversion */
static void print_hex(unsigned long val)
{
    char buf[20];
    char *p = buf + sizeof(buf) - 1;
    *p = '\n';
    p--;

    if (val == 0) {
        *p = '0';
        p--;
    } else {
        while (val > 0) {
            int digit = val & 0xf;
            *p = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
            p--;
            val >>= 4;
        }
    }

    p++;
    printstr(p, (buf + sizeof(buf) - p));
}

/* Simple integer to decimal string conversion */
static void print_dec(unsigned long val)
{
    char buf[20];
    char *p = buf + sizeof(buf) - 1;
    *p = '\n';
    p--;

    if (val == 0) {
        *p = '0';
        p--;
    } else {
        while (val > 0) {
            *p = '0' + umod(val, 10);
            p--;
            val = udiv(val, 10);
        }
    }

    p++;
    printstr(p, (buf + sizeof(buf) - p));
}
static void print_char(char c)
{
    printstr(&c, 1);
}

/*
 * Newton iteration: new_y = y * (3/2 - x * y^2 / 2)
 * Here, y is a Q0.32 fixed-point number (< 1.0)
 */
static const uint32_t rsqrt_table[32] = {
    65536, 46341, 32768, 23170, 16384, 11585, 8192, 5793, 4096, 2896, 2048,
    1448,  1024,  724,   512,   362,   256,   181,  128,  90,   64,   45,
    32,    23,    16,    11,    8,     6,     4,    3,    2,    1};



static inline void mul32x32(uint32_t a, uint32_t b, uint32_t *hi, uint32_t *lo)
{
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;

    uint32_t p0 = a_lo * b_lo;
    uint32_t p1 = a_lo * b_hi;
    uint32_t p2 = a_hi * b_lo;
    uint32_t p3 = a_hi * b_hi;


    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);

    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);

    *hi = hi_res;
    *lo = lo_res;
}

static inline uint32_t newton_step_q16_inline(uint32_t y, uint32_t x)
{
    // y2 = y*y
    uint32_t y2_hi, y2_lo;
    mul32x32(y, y, &y2_hi, &y2_lo);


    
    // (x * y2_hi) << 16 → termA
    uint32_t hi1, lo1;
    mul32x32(x, y2_hi, &hi1, &lo1);
    uint32_t termA = (lo1 << 16);

    

    // (x * y2_lo) >> 16 → termB
    uint32_t hi2, lo2;
    mul32x32(x, y2_lo, &hi2, &lo2);


    uint32_t termB = (hi2 << 16) | (lo2 >> 16);

    uint32_t xy2 = termA + termB;  // mod 2^32



    uint32_t term = (3u << 16) - xy2;

    // y * term → >>17
    uint32_t hi, lo;
    mul32x32(y, term, &hi, &lo);
    uint32_t lo_plus = lo + (1u << 16);
    uint32_t hi_plus = hi + (lo_plus < lo);
    return (hi_plus << 15) | (lo_plus >> 17);
}

static uint32_t rsqrt(uint32_t x)
{
    if (x == 0)
        return 0xFFFFFFFF;
    if (x == UINT32_MAX)
        return 1;
    uint32_t exp = 31u - clz(x);


    uint32_t y_base = rsqrt_table[exp]; /* Value at 2^exp */
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;

    uint32_t fraction = (exp >= 16) ? (x - (1u << exp)) >> (exp - 16)
                                    : (x - (1u << exp)) << (16 - exp);

    /* Linear interpolation */
    uint32_t y = y_base - (umul((y_base - y_next), fraction) >> 16);

    

    y = newton_step_q16_inline(y, x);

    return y;
}

extern uint32_t rsqrt_fast(uint32_t x);

int main(void)
{
    uint64_t start_cycles = get_cycles();
    uint64_t start_instret = get_instret();
    for (int i = 0; i < 50; i++) {
        uint32_t y = rsqrt_fast(RSQRT_INPUTS[i]);
        print_hex(y);
    }
    uint64_t end_cycles = get_cycles();
    uint64_t end_instret = get_instret();

    uint64_t cycles_elapsed = end_cycles - start_cycles;
    uint64_t instret_elapsed = end_instret - start_instret;
    TEST_LOGGER("  Cycles: ");
    print_dec((unsigned long) cycles_elapsed);
    TEST_LOGGER("  Instructions: ");
    print_dec((unsigned long) instret_elapsed);
    TEST_LOGGER("\n");
    return 0;
}