# Computer Architecture
## MIPS-2 Group Designed MIPS Test Program

### MIPS-2 Overview
You will collaboarate in developing a test algorithm for MIPS. You will present your algorithm to the class.


### Grade Break Down
| Part                               |   | Points  |
|------------------------------------|---|---------|
| MIPS_2-4 a - Group Algorithm       |   | 30 pts  |   
| MIPS_2-4 b - Mini Presentation     |   | 20 pts  |    
| Total                              |   | 50 pts  |


# 2-4 a: Group Algorithm
Think about the types of applications that you hope your final processor will be able to execute. For this project you will write a test program that will help verify that the MIPS processor works correctly.  Think about the types of MIPS instructions you might want to use. What instructions does MIPS have that are similar to the ones that you will need to use for your final processor?

Negotiate in your group as to the type of MIPS test program you will want to develop.  Come up with an interesting algorithm on your own. Do NOT simply copy a MIPS program from the internet. While this may be tempting, doing so may result in an immediate 0 for this entire assignment. The idea here is for you to have fun and create something original that uses the MIPS assembly language and that is  able to run on QTSpim. 

In the future you might want to convert this algorithm to your own assembly language, so use this time wisely and write something fun and interesting.

After designing yuor algorithm, each of you individually must include your algorithm in this repository and push your code back to whitgit:

```mips
Authors: Kostia Makrasnov, Ezekiel Pierson and Shane Snediker  
Last updated: March 6th, 2021

# NOTE: this algorithm depends on changing set bits to 0, one by one
# starting from the lowest value bit to the highest. This happens until
# the number equals zero. Therefore, this is a constant time algorithm O(32).
# Since 32 is the size of the registers.

.data
# no memory needed
.text
main:
    # storing orignal OS values to restore later
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

```

# 2-4 b: Presentation

On the due date for this design, groups of two will take 5 minutes (max) and present their test algorithm design to the class. You will be graded on whether you present the following items.  Do not use more than 4 or 5 slides to summarize your algorithm. 

Minute 1:  What MIPS instructions did you choose for your algorithm and why you chose them.
Minute 2:  A neat assembly language listing of your program in the MIPS language. You must include comments. 
Minute 3:  A demonstration of your MIPS assembler language running on QTSpim. 
Minutes 4 - 5:  An analysis of your algorithm. 
* What did you like / dislike about the MIPS instructions you used? 
* How efficient was your algorithm?  
* Will you use a similar program to this in the future for testing your final microprocessor design?
