
#int32_t sum_prod (const int32_t values[], uint64_t num_values, int32_t &product);
#sum_prod (a0, a1, a2)

.section .text
.global sum_prod

# Function Arguments:
# a0 = const int32_t values[]
# a1 = uint64_t num_values
# a2 = int32_t &product

sum_prod:
# Registers
li t0, 0 #sum
li t1, 1 #product
li t2, 0 # loop counter
li t3, 0 # int32_t *p
li t4, 0 # int32_t v (dereferenced)


# for loop
#for (i = 0;i < a1; i++) {
#       sum += values[i];
#       product *= values[i]; }

loop_start:

bge t2, a1,loop_end


slli t3, t2, 2    # t3 = t2 * 4 since a0 = values[0] we use base+offset×size to access the other one
add  t3, t3, a0   # t3 = &values[i] -> now t3 MEMORY ADDRESS of values[i]
# to dereference that address we need to use load instruction 

lw    t4, 0(t3)   # t4 = values[i], Now, the t4 register contains the value at index i.

add    t0, t0, t4    # t0 (sum)     += t4 (values[i])
mul    t1, t1, t4    # t1 (product) *= t4 (values[i])

addi t2, t2, 1
j loop_start

loop_end:

#Before return, need to put the sum in the return register, which is a0. Currently the sum is in the t0 register, but we can move it into a0 by using the mv pseudo-instruction.

mv      a0, t0       # return register a0 = t0 (accumulating sum)
sw      t1, 0(a2)    # cannot use mv because &product is passed by reference # you must write the value of t3 to the memory location pointed to by a2.

ret #  alias for jalr zero, ra
