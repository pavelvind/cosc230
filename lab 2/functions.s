# Pavel Vinduska
# student id 000697226
# netid pvindusk
# Description: RISC-V assembly implementation of random function.
# Learning how to use stack memory


# int64_t get_rand(int64_t mn, int64_t mx) {
#    return mn + rand() % (mx - mn + 1);
# }

# Registers:
# a0 get_rand(a0 mn, a1 mx) {
#    return mn + rand() % (mx - mn + 1);
# }

    .section .text
    .global get_rand

get_rand:
# Alocate space on the stack
addi    sp, sp, -32      # ra + s0 + s1 = 24 bytes aligned to 32

# Save registers on the stack
sd      ra, 0(sp)        # Save return address
sd      s0, 8(sp)        # Save old s0
sd      s1, 16(sp)       # Save old s1

# Move argument registers to saved registers
mv      s0, a0           # minimum
mv      s1, a1           # maximum

# Calling rand function 
call     rand             # rand()

# a0 Large random value
# s0 Minimum value
# s1 Maximum value

sub      t0, s1, s0      # t0 = mx - mn
addi     t0, t0, 1       # t0 = mx - mn + 1

rem      t1, a0, t0       # t1 = rand() % (mx - mn + 1)

add      a0, s0, t1       # a0 = mn + rand() % (mx - mn + 1)

# Cleanup
ld       ra, 0(sp)         # restore return address
ld       s0, 8(sp)         # restore original s0
ld       s1, 16(sp)        # restore original s1

addi      sp, sp, 32       # Move stack back (deallocate)

ret