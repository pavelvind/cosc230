# Pavel Vinduska
# This program implements map function using riscv assembly

# void map(double values[],
#          uint64_t num_values,
#          double (*mapping_func)(double left, double right),
#          double map_value)

# void map(a0,
#          a1,
#          a2,
#          fa0)

    .section .text
    .global map
map:
    # Set up stack space 
    addi    sp, sp, -48

    # Save the registers
    sd      ra, 40(sp)
    sd      s0, 32(sp)  # values[]
    sd      s1, 24(sp)  # num_values
    sd      s2, 16(sp)  # map function
    sd      s3, 8(sp)   # loop counter i
    fsd     fs0, 0(sp)  # map_value

    # Move the parameters into the registers
    mv      s0, a0
    mv      s1, a1
    mv      s2, a2
    fmv.d   fs0, fa0
    li      s3, 0

# For loop
1:
    bge     s3, s1, 1f # Jump out if i >= num_values
    # Calculate address of values[i]
    slli    t0, s3, 3
    add     t1, s0, t0
    # Load values[i] into fa0
    fld     fa0, 0(t1)   #  Setup fa0 (values[i])
    fmv.d  fa1, fs0      # Set double right = map_value
    # Call map funcion
    jalr   s2            # mapping_func(fa0, fa1)
    fsd     fa0, 0(t1)
    addi    s3, s3, 1 # i++
    j       1b         # Loop again

1:
    # Restore all registers and stack pointer
    fld     fs0, 0(sp)
    ld      s3, 8(sp)
    ld      s2, 16(sp)
    ld      s1, 24(sp)
    ld      s0, 32(sp)
    ld      ra, 40(sp)
    addi    sp, sp, 48
    ret

# Functions:
    .global map_add
map_add:
    fadd.d  fa0, fa0, fa1 # fa0 = fa0 + fa1
    ret

    .global map_sub
map_sub:
    fsub.d  fa0, fa0, fa1 # fa0 = fa0 - fa1
    ret

    .global map_min
map_min:
    fmin.d  fa0, fa0, fa1 # fa0 = min(fa0, fa1)
    ret

    .global map_max
map_max:
    fmax.d  fa0, fa0, fa1 # fa0 = max(fa0, fa1)
    ret
