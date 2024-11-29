    .section .rodata
exit_string:     .asciz "%s\n%s\nExits: "
exit_n:          .asciz "n "
exit_e:          .asciz "e "
exit_s:          .asciz "s "
exit_w:          .asciz "w "
newline:         .asciz "\n"

    .section .text
    .global look_at_room
    .global look_at_all_rooms
    .global move_to

# Function: look_at_room
# Arguments: Room pointer r (in a0)
look_at_room:
    # Load title and description pointers
    ld      a1, 0(a0)                  # Load r->title into a1
    ld      a2, 8(a0)                  # Load r->description into a2
    la      a0, exit_string            # Load the address of the format string
    call    printf                     # printf("%s\n%s\nExits: ", r->title, r->description)

    # Check exits and print directions if they exist
    ld      t0, 16(a0)                 # Load r->exits[0] (North) into t0
    li      t1, -1                     # Set t1 to -1 for comparison
    beq     t0, t1, skip_north         # Skip if r->exits[0] == -1
    la      a0, exit_n                 # Load "n " string
    call    printf                     # printf("n ")
skip_north:

    ld      t0, 20(a0)                 # Load r->exits[1] (East) into t0
    beq     t0, t1, skip_east          # Skip if r->exits[1] == -1
    la      a0, exit_e                 # Load "e " string
    call    printf                     # printf("e ")
skip_east:

    ld      t0, 24(a0)                 # Load r->exits[2] (South) into t0
    beq     t0, t1, skip_south         # Skip if r->exits[2] == -1
    la      a0, exit_s                 # Load "s " string
    call    printf                     # printf("s ")
skip_south:

    ld      t0, 28(a0)                 # Load r->exits[3] (West) into t0
    beq     t0, t1, skip_west          # Skip if r->exits[3] == -1
    la      a0, exit_w                 # Load "w " string
    call    printf                     # printf("w ")
skip_west:

    la      a0, newline                # Load newline string
    call    printf                     # printf("\n")
    ret                                # Return from look_at_room


# Function: look_at_all_rooms
# Arguments: Room pointer rooms (in a0), integer num_rooms (in a1)
look_at_all_rooms:
    mv      t0, zero                   # Set counter i = 0

look_all_loop:
    bge     t0, a1, look_all_done      # If i >= num_rooms, break
    slli    t1, t0, 4                  # Calculate offset t1 = i * sizeof(Room) (assuming 32 bytes)
    add     t2, a0, t1                 # Calculate address of rooms + i
    mv      a0, t2                     # Set argument for look_at_room
    call    look_at_room               # Call look_at_room(rooms + i)

    la      a0, newline                # Load newline string
    call    printf                     # printf("\n")

    addi    t0, t0, 1                  # Increment i
    j       look_all_loop              # Repeat loop
look_all_done:
    ret                                # Return from look_at_all_rooms


# Function: move_to
# Arguments: Room pointer rooms (in a0), Room pointer current (in a1), integer direction (in a2)
move_to:
    slli    t0, a2, 2                  # Multiply direction by 4 to calculate offset for int array
    add     t1, a1, t0                 # Address of current->exits[direction]
    lw      t2, 16(t1)                 # Load current->exits[direction] into t2
    li      t3, -1                     # Set t3 to -1 for comparison
    beq     t2, t3, return_null        # If exits[direction] == -1, return nullptr

    slli    t2, t2, 4                  # Scale exits[direction] by sizeof(Room) (assuming 32 bytes)
    add     a0, a0, t2                 # Calculate and set the address of rooms + exits[direction]
    ret                                # Return rooms + exits[direction]

return_null:
    mv      a0, zero                   # Return nullptr (0)
    ret                                # Return from move_to
