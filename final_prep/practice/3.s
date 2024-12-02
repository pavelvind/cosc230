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

# allocate stack space
    sd      ra, 40(sp)
    sd      s0, 32(sp)  # values[]
    sd      s1, 24(sp)  # num_values
    sd      s2, 16(sp)  # map function
    sd      s3, 8(sp)   # loop counter i
    fsd     fs0, 0(sp)  # map_value

# move parameters to the registers



