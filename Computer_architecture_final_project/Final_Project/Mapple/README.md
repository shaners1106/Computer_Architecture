# Mapple Em 1 Microprocessor

This directory contains the VHDL code for our Whitworth University CS401 Computer Architecture final project.  The code provides definition for a personalized microprocessor.  We chose to create a specialized hashing microprocessor that takes in keyboard pushes as input and converts the keyboard input to a hashed output that will be generated upon a VGA monitor screen.  

The core hashing function of the Mapple Em 1 microprocessor follows this pattern:

Initial constants and variable : variable h begins at 0 and hex constant 0xf8000000 are integral to the origination of the algorithm and variables ki, which is the keyboard input, and highorder, which begins at 0, are very important as well.

STEP 0 : highorder = h & 0xf8000000   -- bitwise AND\
STEP 1 : highorder = highorder >> 27  -- Shift highorder bits right 27\
STEP 2 : h = h << 5                   -- Shift h bits left 5\
STEP 3 : h = h ^ highorder            -- XOR h with highorder\
STEP 4 : h = h ^ ki                   -- XOR h with ki\

We found this CRC Varient Hashing Algorithm at: https://www.cs.hmc.edu/~geoff/classes/hmc.cs070.200101/homework10/hashfuncs.html

## VHDL files

The following is a brief explanation of what the files in this directory consist of:

 * mapple_alu.vhd: This file defines the Arithmetic Logic Unit of our microprocessor.  We implemented the hashing algorithm using a Moore Finite State Machine.  The FSM functionality is all implemented within this file.
 * mapple_control_unit.vhd: This file defines the microprocessor's CPU that communicates with the ALU and provokes the rhythm of the hashing algorithm
 * mapple_datapath.vhd: This files connects all of the parts of our microprocessor together
 * mapple_imem.vhd:
 * mapple_main_memory_testbench.vhd: This file provides a test simulation for our memory memory unit
 * mapple_main_memory.vhd: The microprocessor's main memory unit
 * mapple_mem_data.vhd: The data memory unit
 * mapple_testbench.vhd: A main test simulation file for our project
 * mapple_top.vhd: Top level file that connects our microprocessor to the Basys3 FPGA board
 * mapple.vhd: Primary architectural VHDL file for our microprocessor
 * memfile.dat:  This file is intended to be an external memory file containing instructions for the microprocessor, however, our microprocessor is unique in that its instruction set comes from the keyboard input so we will likely deprecate this file from use as we progress in implementing I/O into the microprocessor
 * mooreFSM.vhd: Our FSM entity definition
 * mux2.vhd: Entity definition file for a multiplexer
 * setup_project.tcl: A script file that interfaces with the Vivado Software Application that allows for analyzing the VHDL code in a graphical representation form
 * shift_test.vhd: A simulation test for the shift unit
 * shift.vhd: Entity definition for our ALU's shift logic


## Contributors

This was a group project completed by the following Whitworth CS401 students:

Levi Russell     russell4211@gmail.com\
Madi Binyon      madi.binyon@yahoo.com\
Rudy Keopuhiwa   rudyjayk@gmail.com\
Stephen Haugland haugland98@gmail.com\
Shane Snediker   shaners1106@gmail.com