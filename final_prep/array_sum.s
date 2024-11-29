.section .text
.global sum_array


sum_array:
# a0 = int values[] #int = 4 bytes
# a1 = int num_values (how many)
li t0, 0 # initioalie iterator
# t2 = address of value[i]
# t3 = value[i]
li t4, 0  # Initialize sum (t4) to 0

loop_start:
    bge t0, a1, loop_end  # If i >= num_values, exit the loop
   
    # Memory Address Calculation # base+offset×size 
    slli t1, t0, 2      # offset×size 
    add t2, a0, t1

    # Dereferncing the address
    lw t3, 0(t2) #accesses the value stored at a memory address

    # sum the numbers in array
    add t4, t4, t3

    addi t0, t0, 1

    j loop_start

loop_end:

  mv a0, t4  

  ret

