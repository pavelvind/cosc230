#int64_t get_rand(int64_t mn, int64_t mx) {
#    return mn + rand() % (mx - mn + 1);
#}

# a0 = mn 
# a1 = mx

.section .text
.global get_rand

get_rand:

# store on stack 
addi sp, sp, -32
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 16(sp)

# saved registers
mv      s0, a0           # minimum
mv      s1, a1           # maximum

call rand # overwrited ra
# a0 now holds the random value

# calculations
sub  t0, s1, s0
addi t0, t0, 1
rem  t1, a0, t0       # t1 = rand() % (mx - mn + 1)
add  a0, s0, t1       # a0 = mn + rand() % (mx - mn + 1)



# dealocate space
ld       ra, 0(sp)         # restore return address
ld       s0, 8(sp)         # restore original s0
ld       s1, 16(sp)        # restore original s1

addi sp, sp, 32

ret
