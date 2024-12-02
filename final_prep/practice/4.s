.section .text
.global make_triangle

make_triangle:
    # Allocate stack space (16 bytes for ra and s0)
    addi sp, sp, -16

    # Save the return address and s0 register onto the stack using 64-bit instructions
    sd ra, 0(sp)    # Save ra at 0(sp)
    sd s0, 8(sp)    # Save s0 at 8(sp)

    # Move the pointer to the structure from a0 to s0 for safe access
    mv s0, a0

    # Store side0 and side1 into the structure
    fsw fa0, 0(s0)   # struct->s0 = side0
    fsw fa1, 4(s0)   # struct->s1 = side1

    # Calculate hypotenuse = sqrt(s0^2 + s1^2)
    fmul.s ft0, fa0, fa0    # ft0 = s0 * s0
    fmul.s ft1, fa1, fa1    # ft1 = s1 * s1
    fadd.s ft2, ft0, ft1    # ft2 = s0^2 + s1^2

    # Prepare for calling sqrtf
    fmv.s fa0, ft2          # Move ft2 into fa0 (argument for sqrtf)
    call sqrtf               # Call sqrtf, result in fa0

    # Store hypotenuse in the structure
    fsw fa0, 8(s0)          # struct->hypotenuse = sqrt(s0^2 + s1^2)

    # Calculate theta0 = asinf(s0 / hypotenuse)
    flw ft3, 0(s0)           # Load s0 from struct
    flw ft4, 8(s0)           # Load hypotenuse from struct
    fdiv.s fa0, ft3, ft4     # fa0 = s0 / hypotenuse
    call asinf               # Call asinf, result in fa0
    fsw fa0, 12(s0)          # struct->theta0 = asinf(s0 / hypotenuse)

    # Calculate theta1 = asinf(s1 / hypotenuse)
    flw ft3, 4(s0)           # Load s1 from struct
    flw ft4, 8(s0)           # Load hypotenuse from struct
    fdiv.s fa0, ft3, ft4     # fa0 = s1 / hypotenuse
    call asinf               # Call asinf, result in fa0
    fsw fa0, 16(s0)          # struct->theta1 = asinf(s1 / hypotenuse)

    # Restore s0 and ra from the stack using 64-bit instructions
    ld s0, 8(sp)             # Restore s0 from 8(sp)
    ld ra, 0(sp)             # Restore ra from 0(sp)

    # Deallocate stack space
    addi sp, sp, 16           # Restore stack pointer

    # Return to caller
    ret
    