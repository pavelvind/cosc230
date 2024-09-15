.section .text
.global sum_prod
sum_prod:
    # int32_t (a0)
    #     sum_prod
    #        const int32_t values[] (a0)
    #        uint64_t num_values    (a1)
    #        int32_t &product       (a2)
    # Rewritten:
    # a0      sum_prod (a0, a1, a2)

ret