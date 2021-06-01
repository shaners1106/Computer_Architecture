# Put your mips assembly code algorithm here
# Make sure that it is commented well
# Authors:  Kostia, Ezekiel, Shane
# Date: 03/06/2021

# NOTE: this algorithm depends on changing set bits to 0, one by one
# starting from the lowest value bit to the highest. This happens until
# the number equals zero. Therefore, this is a constant time algorithm O(32).
# Since 32 is the size of the registers.

.data
# no memory needed
.text
main:
    # storing original OS values to restore later
    addi $sp, $sp, -4   # stack frame
    sw $ra, 0($sp)      # store $ra


    # store the number of which to find set bits
    addiu $s0, $0, 31000
    # store the original bit count (starts at 0)
    addiu $s1, $0, 0


    # loop until original value is 0
    loop:

    # perform bitwise n between original number (n) and (n-1)
    addiu $s2, $s0, -1
    and $s0, $s0, $s2

    # add one to bit count
    addiu $s1, $s1, 1

    bne  $s0, $0, loop


    # restoring original OS values 
    lw $ra, 0($sp)      # restore $ra
    addi $sp, $sp, 4    # restore $sp
    jr $ra              # return to OS
