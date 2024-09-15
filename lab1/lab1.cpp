#include <cstdint>

int32_t sum_prod(const int32_t values[], uint64_t num_values, int32_t &product) {
    uint64_t i;
    int32_t sum;

    sum = 0;
    product = 1;

    for (i = 0; i < num_values; i++) {
        sum += values[i];
        product *= values[i];
    }
    return sum;
}
