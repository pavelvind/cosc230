# section and function declaration

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

li    t0, 0   # Use t0 for the sum
li    t1, 1   # Use t1 for the product
li    t2, 0   # Iterator i
li    t3, 0   # Iterator i added to values
li    t4, 0   # Dereferenced value of values[i]

# numeric label
1: # backwards


# loop condition
bge     t2, a1, 1f  # if the iterator i (t2) is >= the size of the array num_values (a1), then we want to quit the for loop (1f jumps forward)

# calclulate address of values
slli    t3, t2, 2    # t3 = t2 * 4
add     t3, t3, a0   # t3 = &values[i]

# load values into t4
lw    t4, 0(t3)      # t4 = values[i]

# update sum and product
add    t0, t0, t4    # t0 (sum)     += t4 (values[i])
mul    t1, t1, t4    # t1 (product) *= t4 (values[i])

# increment i
addi    t2, t2, 1    

# 1b jumps backwards
j       1b           

1: # forwards

mv      a0, t0       # return register a0 = t0 (accumulating sum)
sw      t1, 0(a2)    # *product = t1 (accumulating product)

ret
