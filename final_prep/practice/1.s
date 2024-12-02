#int32_t sum_prod (const int32_t values[],
#                  uint64_t num_values,
#                  int32_t &product)
#{
#   uint64_t i;
#   int32_t sum;

#   for (i = 0;i < num_values;i++) {
#       sum += values[i];
#       product *= values[i];
#   }
#   return sum;
#}

.section .text

.global sum_prod

sum_prod:

# a0 = values
# a1 = num_values
# a2 = &product

li t0, 0 # i
# t1 = offset
li t2, 0 # t2 = sum
li t3, 1 # t3 = product
# t4 = value[i] address


loop_start:



slli t1, t0, 2 # multiply i by size to jump to other value 
add t4, a0, t1 # base value[i] + offset

lw t5, 0(t4) # dereferenced value

add t2, t2, t5 # current sum
mul t3, t3, t5 # current product


addi t0, t0, 1 # i++
blt t0, a1, loop_start # branch if: i < num_values 

loop_end:

mv a0, t2    
sw t3, 0(a2) # cannot use mv because &product is passed by reference # you must write the value of t3 to the memory location pointed to by a2.

ret
