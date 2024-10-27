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

addi sp, sp, -8

fsw fa0, 0(a0)        # s0 = side0
fsw fa1, 4(a0)        # s1 = side1

# Calculate hypotenuse
fmul.s ft0, fa0, fa0
fmul.s ft1, fa1, fa1
fadd.s ft2, ft1, ft0 