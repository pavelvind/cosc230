# void map(double values[], uint64_t num_values, double (*mapping_func)(double left, double right), double map_value)
#{
#    uint64_t i;
#    for (i = 0;i < num_values;i++) {
#         values[i] = mapping_func(values[i], map_value);
#    }
#}

# Argument functions
# a0 = double *values
# a1 = uint64_t num_values
# a2 = double (*mapping_func)(double left, double right)
# fa0 = double map_value

.section .text
.global map

map:
# we will call *mapping_func so need to allocate sp (used size is 36)

addi sp, sp, -48
# allocate stack space
sd      ra, 40(sp)
sd      s0, 32(sp)  # values[] base => s0
sd      s1, 24(sp)  # num_values
sd      s2, 16(sp)  # map function
sd      s3, 8(sp)   # loop counter i
fsd     fs0, 0(sp)  # map_value

# move parameters to the registers

mv s0, a0
mv s1, a1
mv s2, a2
mv s3, a3
fmv.d fs0, fa0

li t0, 0 # iterator

loop_start:
bge t0, s1, loop_end

slli t1, t0, 3 # multiply by 8 index * size
add t2, t1, s0 # value = base + index * size

# Load values[i] into fa0 (left)
fld fa0, 0(t2)

# Set double right = map_value
fmv.d  fa1, fs0      

jalr s2 # rsult in a0 now

fsd    fa0, 0(t1)    # fa0 (the return value from mapping_func) # Stores it into memory at the address t1 + 0 

addi t0, t0, 1
loop_end:

# dealocate
ld      ra, 40(sp)
ld      s0, 32(sp)  # values[]
ld      s1, 24(sp)  # num_values
ld      s2, 16(sp)  # map function
ld      s3, 8(sp)   # loop counter i
fld     fs0, 0(sp)  # map_value
addi sp, sp, 48
ret

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