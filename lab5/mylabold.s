# struct Room {
#    char *title;
#    char *description;
#    int exits[4]; // 0 – N, 1 – E, 2 – S, 3 - W
# };

.section .rodata
exit_string:    .asciz "%s\n%s\nExits: "
newline_string: .asciz "\n"
north_string:   .asciz "n "
east_string:    .asciz "e "
south_string:   .asciz "s "
west_string:    .asciz "w "

.section .text
.global look_at_room
look_at_room:
    mv      t0, a0          # Save the Room pointer in t0

    ld      a1, 0(t0)       # Load r->title into a1
    ld      a2, 8(t0)       # Load r->description into a2

    la      a0, exit_string # Load the address of exit_string into a0
    call    printf          # Call printf("%s\n%s\nExits: ", r->title, r->description)

    li      t3, -1          # Load -1 into t3 for comparison

    lw      t1, 16(t0)      # Load r->exits[0] (North) into t1
    beq     t1, t3, skip_north
    la      a0, north_string
    call    printf
skip_north:

    lw      t1, 20(t0)      # Load r->exits[1] (East) into t1
    beq     t1, t3, skip_east
    la      a0, east_string
    call    printf
skip_east:

    lw      t1, 24(t0)      # Load r->exits[2] (South) into t1
    beq     t1, t3, skip_south
    la      a0, south_string
    call    printf
skip_south:

    lw      t1, 28(t0)      # Load r->exits[3] (West) into t1
    beq     t1, t3, skip_west
    la      a0, west_string
    call    printf
skip_west:

    la      a0, newline_string # Load the address of newline_string into a0
    call    printf             # Call printf("\n")
    ret

.global look_at_all_rooms
look_at_all_rooms:
    addi    sp, sp, -8      # Allocate stack space
    sd      s0, 0(sp)       # Save s0
    mv      s0, zero        # Initialize loop counter i = 0

loop_start:
    bge     s0, a1, loop_end   # If i >= num_rooms, exit loop

    slli    t1, s0, 5          # t1 = i * 32 (size of Room)
    add     t2, a0, t1         # t2 = rooms + i * sizeof(Room)

    mv      a0, t2             # Move rooms[i] address to a0
    call    look_at_room       # Call look_at_room(rooms + i)

    la      a0, newline_string # Load newline_string
    call    printf             # Print newline

    addi    s0, s0, 1          # Increment loop counter i++
    j       loop_start         # Jump to start of loop

loop_end:
    ld      s0, 0(sp)          # Restore s0
    addi    sp, sp, 8          # Deallocate stack space
    ret

.global move_to
move_to:
    addi    t0, a1, 16         # t0 = current + 16 (address of exits[0])
    slli    t1, a2, 2          # t1 = direction * 4 (size of int)
    add     t2, t0, t1         # t2 = &current->exits[direction]

    lw      t3, 0(t2)          # Load current->exits[direction] into t3

    li      t4, -1             # Load -1 into t4 for comparison
    beq     t3, t4, invalid_exit # If exit is -1, jump to invalid_exit

    slli    t5, t3, 5          # t5 = exit_index * 32 (size of Room)
    add     a0, a0, t5         # a0 = rooms + t5
    ret

invalid_exit:
    mv      a0, zero           # Set return value to nullptr (0)
    ret
