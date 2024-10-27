# RightTriangle make_triangle(float side0, float side1)
#{
#    RightTriangle rt;
#
#    rt.s0 = side0;
#    rt.s1 = side1;
#    rt.hypotenuse = sqrtf((side0 * side0) + (side1 * side1));
#
#    rt.theta0 = asinf(side0 / rt.hypotenuse);
#    rt.theta1 = asinf(side1 / rt.hypotenuse);
#
#     return rt;
# }
    #float s0;         // side 0
    #float s1;         // side 1
    #float hypotenuse;
    #float theta0;     // angle 0
    #float theta1;     // angle 1


.section .text
.global make_triangle

make_triangle:

addi sp, sp, -8
sw ra, 4(sp) 

fsw fa0, 0(a0)        # s0 = side0
fsw fa1, 4(a0)        # s1 = side1

# Calculate hypotenuse
fmul.s ft0, fa0, fa0
fmul.s ft1, fa1, fa1
fadd.s ft2, ft1, ft0 

# Call math functions
# sqrt
fmv.s fa0, ft2 # fa0 => prepared for function call
call sqrtf     # returned in fa0
fsw fa0, 8(a0) # store

# theta0 = asinf(side0 / hypotenuse)
flw ft3, 0(a0)        
flw ft4, 8(a0) # hypotenuse

fdiv.s fa0, ft3, ft4 # (side0 / hypotenuse)
call asinf
fsw fa0, 12(a0) # store

# theta1 = asinf(side1 / hypotenuse)
flw ft3, 4(a0)        
fdiv.s ft5, ft3, ft4  # (side1 / hypotenuse)
fmv.s fa0, ft5        # prepared for function call
call asinf            
fsw fa0, 16(a0)       # store

lw ra, 4(sp)          # restore return address
addi sp, sp, 8        # deallocate stack space
ret

