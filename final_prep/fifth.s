# string literals are stored in the .rodata section.
.section .rodata
exit_string:     .asciz "%s\n%s\nExits: "
newline:         .asciz "\n"
exit_n:          .asciz "n "
exit_e:          .asciz "e "
exit_s:          .asciz "s "
exit_w:          .asciz "w "

# printf = std library function

# Struct Room
# Pointers require 8 bytes
#   Offset    Size
# *title          0       8
# *description    8       8
#  exits         16      4 x 4 bytes (int exits[4])

.section .text

.global look_at_room
# void look_at_room(const Room *r)
# {
#     printf("%s\n%s\nExits: ", r->title, r->description);
#     if (r->exits[0] != -1)
#         printf("n ");
#     if (r->exits[1] != -1)
#         printf("e ");
#     if (r->exits[2] != -1)
#         printf("s ");
#     if (r->exits[3] != -1)
#         printf("w ");
#     printf("\n");
# }

look_at_room:
    # Save return address and saved registers
    addi    sp, sp, -16       # Allocate stack space
    sd      ra, 8(sp)         # Save ra
    sd      s0, 0(sp)         # Save s0

    # Move the Room pointer from a0 to s0
    mv      s0, a0            # s0 = r (Room pointer)

    # Load Room fields
    ld      a1, 0(s0)         # Load r->title into a1
    ld      a2, 8(s0)         # Load r->description into a2

    # Prepare arguments for printf
    la      a0, exit_string   # Load address of the format string into a0
    call    printf            # Call printf("%s\n%s\nExits: ", r->title, r->description)

    # Load exits into temporary registers
    lw      t0, 16(s0)        # Load exits[0] (North) into t0
    lw      t1, 20(s0)        # Load exits[1] (East) into t1
    lw      t2, 24(s0)        # Load exits[2] (South) into t2
    lw      t3, 28(s0)        # Load exits[3] (West) into t3

    # Immediate for comparison
    li      t4, -1

    # Check and print North exit
    beq     t0, t4, skip_north
    la      a0, exit_n        # Load "n "
    call    printf
skip_north:

    # Check and print East exit
    beq     t1, t4, skip_east
    la      a0, exit_e        # Load "e "
    call    printf
skip_east:

    # Check and print South exit
    beq     t2, t4, skip_south
    la      a0, exit_s        # Load "s "
    call    printf
skip_south:

    # Check and print West exit
    beq     t3, t4, skip_west
    la      a0, exit_w        # Load "w "
    call    printf
skip_west:

    # Print newline at the end
    la      a0, newline       # Load newline string
    call    printf

    # Restore saved registers and deallocate stack
    ld      s0, 0(sp)         # Restore s0
    ld      ra, 8(sp)         # Restore ra
    addi    sp, sp, 16        # Deallocate stack space
    ret

# void look_at_all_rooms(const Room *rooms, int num_rooms)
# {
#     int i;
#     for (i = 0; i < num_rooms; i++) {
#         look_at_room(rooms + i);
#         printf("\n");
#     }
# }

.global look_at_all_rooms

look_at_all_rooms:
    # Save return address and saved registers
    addi    sp, sp, -32       # Allocate stack space
    sd      ra, 24(sp)        # Save ra
    sd      s0, 16(sp)        # Save s0
    sd      s1, 8(sp)         # Save s1
    sd      s2, 0(sp)         # Save s2

    # Initialize loop variables
    mv      s0, zero          # s0 = i = 0
    mv      s1, a0            # s1 = base address of rooms
    mv      s2, a1            # s2 = num_rooms

loop_start:
    bge     s0, s2, loop_end  # Exit loop if i >= num_rooms

    # Calculate address of rooms + i * sizeof(Room) (i.e., i * 32 bytes)
    slli    t0, s0, 5         # t0 = i * 32 (Room size is 32 bytes)
    add     a0, s1, t0        # a0 = rooms + i * 32 (pointer to rooms[i])
    call    look_at_room      # Call look_at_room(rooms + i)

    # Print a newline after each room
    la      a0, newline       # Load newline string
    call    printf            # Print newline

    addi    s0, s0, 1         # i++
    j       loop_start        # Jump back to loop_start

loop_end:
    # Restore saved registers and deallocate stack
    ld      s2, 0(sp)         # Restore s2
    ld      s1, 8(sp)         # Restore s1
    ld      s0, 16(sp)        # Restore s0
    ld      ra, 24(sp)        # Restore ra
    addi    sp, sp, 32        # Deallocate stack space
    ret

# Room *move_to(Room *rooms, const Room *current, int direction)
# {
#     if (current->exits[direction] != -1)
#         return rooms + current->exits[direction];
#     return nullptr;
# }

# a0: Base address of the rooms array (pointer to the first Room struct)
# a1: Address of the current Room struct (pointer to current)
# a2: Direction (integer index into the exits[] array)

.global move_to

move_to:
    # Load address of current->exits into t0
    # The exits[] array starts at offset 16 within the Room struct.
    addi    t0, a1, 16        # t0 = address of current->exits

    # Calculate offset for exits[direction]
    slli    t1, a2, 2         # t1 = direction * 4 (size of int)
    add     t2, t0, t1        # t2 = address of current->exits[direction]

    lw      t3, 0(t2)         # Load value of current->exits[direction] into t3

    # Compare the value with -1
    li      t4, -1            # t4 = -1
    beq     t3, t4, return_null # If exits[direction] == -1, return nullptr

    # Calculate the target room address
    slli    t5, t3, 5         # t5 = exits[direction] * 32 (size of Room)
    add     a0, a0, t5        # a0 = rooms + (exits[direction] * 32)

    ret                        # Return the target room address

return_null:
    li      a0, 0              # a0 = nullptr
    ret                        # Return nullptr
    