# void map(double *values, uint64_t num_values, double (*func)(double left, double right), double map_value);

# Argument functions
# a0 = double *values
# a1 = uint64_t num_values
# a2 = double (*mapping_func)(double left, double right)
# fa0 = double map_value

# Registers (they will be destroyed when diff function is called)
# ra offset: 0
# s0 *values offset: 8
# s1 num_values offset: 16
# s2 (*mapping_func)(double left, double right) offset: 24
# fs0 = double map_value offset: 32
# s3 = loop counter offset: 40
# size 48

.section .text

.global map
map:

    addi sp, sp, -48
    # allocate stack space
    sd      ra, 40(sp)
    sd      s0, 32(sp)  # values[]
    sd      s1, 24(sp)  # num_values
    sd      s2, 16(sp)  # map function
    sd      s3, 8(sp)   # loop counter i
    fsd     fs0, 0(sp)  # map_value

    # moev parameters to the registers
    mv      s0, a0
    mv      s1, a1
    mv      s2, a2
    fmv.d   fs0, fa0
    li      s3, 0
    
    #for loop 
    #uint64_t i;
    #for (i = 0;i < num_values;i++) {
    #values[i] = mapping_func(values[i], map_value);
    #

    loop_start:
    bge s3, s1, loop_end # Jump out if i >= num_values
    
    # Calculate address of values[i]
    slli t0, s3, 3
    add t1, s0, t0
     # Load values[i] into fa0
    fld fa0, 0(t1)
    
    fmv.d  fa1, fs0      # Set double right = map_value

    # Call map funcion
    jalr   s2            # mapping_func(fa0, fa1) # Calls the function at the address stored in s2 # jalr ra, 0(s2) 
    fsd    fa0, 0(t1)    # fa0 (the return value from mapping_func) # Stores it into memory at the address t1 + 0 

    
    addi s3, s3, 1          # Increment loop counter
    j loop_start
    loop_end:
    ld      ra, 40(sp)         # Restore return address
    ld      s0, 32(sp)         # Restore saved register s0
    ld      s1, 24(sp)         # Restore saved register s1
    ld      s2, 16(sp)         # Restore saved register s2
    ld      s3, 8(sp)          # Restore saved register s3
    fld     fs0, 0(sp)         # Restore saved floating-point register fs0
    addi    sp, sp, 48         # Deallocate stack space
    ret                        # Return to caller

.global map_add
map_add:
    fadd.d fa0, fa0, fa1 # fa0 = fa0 + fa1
    ret

.global map_sub
map_sub:
    fsub.d fa0, fa0, fa1 # fa0 = fa0 - fa1
    ret

.global map_min
map_min:
    fmin.d  fa0, fa0, fa1 # fa0 = min(fa0, fa1)
    ret
.global map_max
map_max:
    fmax.d  fa0, fa0, fa1 # fa0 = max(fa0, fa1)
    ret
