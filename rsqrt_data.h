#ifndef RSQRT_TEST_DATA_H
#define RSQRT_TEST_DATA_H

#include <stdint.h>

/* === Test input values (x) === */
static const uint32_t RSQRT_INPUTS[50] = {
    // small range (0 ~ 256)
    0u, 1u, 2u, 3u, 4u, 5u, 6u, 8u, 9u, 10u,
    12u, 15u, 16u, 20u, 25u, 50u, 100u, 128u, 200u, 256u,

    // mid range (300 ~ 16384)
    300u, 400u, 500u, 768u, 1000u, 1500u, 2000u, 3000u, 4096u, 5000u,
    8192u, 10000u, 12000u, 14000u, 15000u, 16000u, 16383u, 16384u, 10000u, 12000u,

    // high range + boundary (≥ 32768)
    32768u, 65536u, 131072u, 262144u, 524288u,
    1048576u, 2097152u, 4194304u, 2147483647u, 4294967295u
};

#endif /* RSQRT_TEST_DATA_H */