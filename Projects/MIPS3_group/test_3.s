main:
    addi $2, $0, 5          # initialize $2 = 5
    addi $3, $0, -1         # initialize $3 = -1
    addi $4, $0, 0          # initialize $4 = 0
    addi $5, $0, 1          # initialize $5 = 1
    xori $2, $0, 5          # use xori  ??
    blez $5, blezBranch     # shouldn't work (1 !<= 0)
    blez $4, blezBranch     # should work (0 <= 0)

blezBranch:
    bgtz $3, bgtzBranch     # shouldn't work (-1 !> 0)
    bgtz $4, bgtzBranch     # shouldn't work (0 !> 0)
    bgtz $5, bgtzBranch     # should work (1 > 0)

bgtzBranch:
    blez $3, end            # should work (-1 <= 0)

end:
    sw $2, 84($0)           # write adr 84 = 7  ??
    j main                  # restart