# int64_t get_rand(int64_t mn, int64_t mx) {
#    return mn + rand() % (mx - mn + 1);
# }

# Function Arguments:
# a0 = int64_t mn
# a1 = int64_t mx

# Registers (they will be destroyed when diff function is called)
# ra                offset: 0
# s0 (int64_t mn )  offset: 8
# s1 (int64_t mx )  offset: 16
#size: 24

.section .text
.global get_rand

get_rand:

# Alocate space for stack pointer (multiples of 16)
addi sp, sp, -32

# Store on the stack
sd      ra, 0(sp)        # Save return address
sd      s0, 8(sp)        # Save old s0
sd      s1, 16(sp)       # Save old s1

# Move arguments into saved registers
mv      s0, a0           # minimum
mv      s1, a1           # maximum

# call rand() and save its value
call     rand            # rand() in a0 # overwrited ra

# calculations 
# s0 + a0 % (s1 - s0 + 1)

sub  t0, s1, s0
addi t0, t0, 1
rem  t1, a0, t0       # t1 = rand() % (mx - mn + 1)
add      a0, s0, t1       # a0 = mn + rand() % (mx - mn + 1)

#cleanup 
ld ra, 0(sp)
ld s0, 8(sp)       
ld s1, 16(sp)        

addi      sp, sp, 32       # Move stack back (deallocate)

ret # jr ra  # Return to caller
