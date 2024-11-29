# Pavel Vinduska - lab 5

# struct Room {
#    char *title;
#    char *description;
#    int exits[4]; // 0 – N, 1 – E, 2 – S, 3 - W
# };

# Size of room == 32

.section .rodata
exit_string:     .asciz "%s\n%s\nExits: "
newline:         .asciz "\n"
exit_n:          .asciz "n "
exit_e:          .asciz "e "
exit_s:          .asciz "s "
exit_w:          .asciz "w "



#void look_at_room(const Room *r)
#{
#	printf("%s\n%s\nExits: ", r->title, r->description);\
#    if (r->exits[0] != -1)
#		printf("n ");
#    if (r->exits[1] != -1)
#        printf("e ");
#    if (r->exits[2] != -1)
#        printf("s ");
#    if (r->exits[3] != -1)
#        printf("w ");
#    printf("\n");}

.section .text
.global look_at_room

look_at_room:
    addi    sp, sp, -32              # Allocate sp
    sd      ra, 24(sp)              # Save ra
    sd      s0, 16(sp)              # Save s0
    sd      s1, 8(sp)               # Save s1
    sd      s2, 0(sp)               # Save s2 

    mv      s0, a0                  # s0 = r (Room pointer)
    
    la      a0, exit_string         # Load the address of exit_string into a0
    ld      a1, 0(s0)               # a1 = r->title
    ld      a2, 8(s0)               # a2 = r->description

    call    printf                  

    li      s1, -1                  # s1 = -1 

    lw      t0, 16(s0)              # t0 = r->exits[0] (North)
    beq     t0, s1, skip_north
    la      a0, exit_n              # a0 = "n "
    call    printf                  
skip_north:

    lw      t0, 20(s0)             # t0 = r->exits[1] (East)
    beq     t0, s1, skip_east
    la      a0, exit_e             # a0 = "e "
    call    printf                  
skip_east:

    lw      t0, 24(s0)             # t0 = r->exits[2] (South)
    beq     t0, s1, skip_south
    la      a0, exit_s             # a0 = "s "
    call    printf                  
skip_south:

    lw      t0, 28(s0)             # t0 = r->exits[3] (West)
    beq     t0, s1, skip_west
    la      a0, exit_w             # a0 = "w "
    call    printf                  
skip_west:

    la      a0, newline            # a0 = "\n"
    call    printf                  

# Deallocate stack space and restore all registers
    ld      s2, 0(sp)               
    ld      s1, 8(sp)               
    ld      s0, 16(sp)              
    ld      ra, 24(sp)              
    addi    sp, sp, 32              
    ret                             


#void look_at_all_rooms(const Room *rooms, int num_rooms)
#{
#    int i;
#    for (i = 0;i < num_rooms;i++) {
#        look_at_room(rooms + i);
#        printf("\n")}}
.global look_at_all_rooms

look_at_all_rooms:
    addi    sp, sp, -16             # Allocate sp
    sd      ra, 8(sp)               # Save ra
    sd      s0, 0(sp)               # Save s0

    mv      s0, zero                # s0 = i = 0

loop_start:
    bge     s0, a1, loop_end        # if i >= num_rooms exit loop

    slli    t0, s0, 5             # t0 = i * 32
    add     t1, a0, t0            # t1 = rooms + i * 32

    mv      a0, t1                # a0 = &rooms[i]
    call    look_at_room          # Call look_at_room(rooms + i)

    la      a0, newline           # a0 = "\n"
    call    printf                 # printf("\n")

    addi    s0, s0, 1             # i++
    j       loop_start            # Jump back to loop_start

# Deallocate stack space and restore all registers
loop_end:
    ld      s0, 0(sp)               
    ld      ra, 8(sp)               
    addi    sp, sp, 16              
    ret                             


#Room *move_to(Room *rooms, const Room *current, int direction)
#{
#    if (current->exits[direction] != -1)
#        return rooms + current->exits[direction];
#
#    return nullptr; }

.global move_to

move_to:
    slli    t0, a2, 2             # t0 = direction * 4
    addi    t1, a1, 16            # t1 = current + 16 (addres of exits)
    add     t1, t1, t0            # t1 = &current->exits[direction]

    lw      t2, 0(t1)             # t2 = current->exits[direction]

    li      t3, -1                # t3 = -1
    beq     t2, t3, return_null     # if exits[direction] == -1 return nullptr

    slli    t2, t2, 5             # t2 = exit_index * 32
    add     a0, a0, t2            # a0 = rooms + t2
    ret                           # Return new Room pointer

return_null:
    mv      a0, zero                # return nullptr
    ret                            

