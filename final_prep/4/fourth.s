# RightTriangle make_triangle(float side0, float side1);
# => a0 func(a0, a1);

# Structure:
#Name	                Offset	Size
#float s0               0       4
#float s1               4       4
#float hypotenuse       8       4
#float theta0           12      4
#float theta1           16      4

.section .text

.global make_triangle

make_triangle:

addi sp, sp, -16

# save return addres on the stack bc after calling math functions its back
sw ra, 4(sp)

# When make_triangle is called, the pointer to a memory location
# where the RightTriangle structure is to be constructed is passed 
# via the register a0. This pointer represents the base address of the structure in memory.
# stack pointer 

# The structure is a complex data type that resides in memory.
# You need to explicitly store values (side0 and side1) into memory using the offsets of the fields within the structure 
fsw fa0, 0(a0) #side0
fsw fa1, 4(a0) #side1

# After this: The original value in a0 (pointer to rt) is no longer needed in a0.

#Additional computations (like calculating the hypotenuse and angles) will be 
#performed and stored in their respective offsets (8(a0), 12(a0), and 16(a0)).

# math functions

# hypotenuse = sqrt (s1*s1 + s0*s0)
fmul.s ft0, fa0, fa0
fmul.s ft1, fa1, fa1
fadd.s ft2, ft1, ft0 

# The function sqrtf expects its input argument (fa0) to be a single-precision float.
fmv.s fa0, ft2      # fa0 => prepared for function call
call sqrtf          # returned in fa0
fsw fa0, 8(a0)      # store to the structure pointer (nos table)

# load values for div function
flw ft3, 0(a0)        #s0
flw ft4, 8(a0)        #hyp

fdiv.s fa0, ft3, ft4  #prepared for function call
call asinf
fsw fa0, 12(a0)       # store to the structure pointer (nos table)

flw ft3, 4(a0)        #s1
flw ft4, 8(a0)        #hyp

fdiv.s fa0, ft3, ft4
call asinf
fsw fa0, 16(a0)

lw ra, 4(sp)          # restore return address
addi sp, sp, 16        # deallocate stack space


# Jumps to the address stored in the ra (return address) register.
# The x0 ensures that no value is written back to a register since x0 is always 0.
# The 0 offset means the jump goes directly to the address in ra.

ret                   # jalr x0, ra, 0
