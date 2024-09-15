#include <cstdint>
#include <iostream>

int32_t sum_prod(const int32_t values[], uint64_t num_values, int32_t &product) { // a0, a1, a2
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


int main() {
    int32_t values[] = {1, 2, 3, 4, 5};
    uint64_t num_values = 5;
    int32_t product;

    int32_t sum = sum_prod(values, num_values, product);

    std::cout << "Sum: " << sum << ", Product: " << product << std::endl;

    return 0;
}
