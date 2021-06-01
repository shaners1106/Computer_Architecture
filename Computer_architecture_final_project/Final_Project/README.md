# CS 401 Digital Design and Computer Architecture

## FP_4: Final Processor Design Plus I/O Introduction
   
The primary goal of this project is to have a working microprocessor with a program that can interact with the external world. For this project you will complete your Microprocessor and as a part of the requirements, and integrate a simple form of __output__ and simple form of __input__ to your FPGA board and processor. For an A on this project your group will also need to implement a more advanced form of I/O beyond the simple I/O from exercise 1. 

The advanced external output could be any one of the following: 
* VGA output,  
* HEX output, 
* SPI port output, 
* Serial terminal output etc. 

While the advanced input could come from the:
* Keyboard input, 
* SPI (joystick) input, 
* Serial terminal input, etc. 

Only certain keyboards will work well for keyboard input (there are 4 simple keyboards in the cardboard box in 308/304 that you can use for keyboard, please leave these in the lab for others to use and put them back in the cardboard box when you are finished).

In the past groups have made games, interactive programs, etc. Other groups have made video generators that allow the program to output text (most challenging).

In general, you want to make a project that can show off the capabilities of your processor. 

## 25 pts. Exercise 1: Working Processors, Simple I/O, Simple I/O Test Program

### Overview of Exercise 1
This first exercise will allow your group to make sure your processor works and learn how to integrate the processor with the most basic and the easiest form of I/O:
* 16 switches (or pushbuttons) and the 
* 16 LEDs on board the FPGA.  

### 16 Bit Switches Inputs for Exercise 1
To read the value of the switches, your hardware could use memory mapped I/O, a special "read port" instruction or a treat a couple of registers as dedidcated i/o registers. 

For the memory mapped I/O approach your program will read from a specific memory address to read the switches.

You could instead opt for read port / write port instructions and associated dedicated input/ouput registers. These would require control from the control unit and the addition of two specialized input/output instructions. 

If you did not add a lw type instruction, you could also treat one of your register addresses as the address for the input switch port. This means that your "I/O" memory mapped hardware will need work with the registers rather than with the main memory. It also means that you will need to add a MUX with a control signal activated by a specific memory address.  For example, if you assign memory address 63 to the switches, whenever you read from address 63, the mux will sense this, and rather than routing data from memory location 63 in your memory, it will route the switch settings bits and send their value to the destination register of your choice. 

### 16 Bit LED Outputs for Exercise 1
To write a value out to the LED's, your hardware can again use memory mapped I/O or a special "write port" instruction. For example, you could assign a specific memory address (let's say 62) to an output register that will store an output value, and this register could also be connected to the 16 LEDs on the board. Now, whenever you write a value to memory address 62, the mux will sense this, and rather than writing data to actual memory location 62 in your memory, it will route the value of the source register to the special externally connected 16 bit "output register" (separate from your main register file) which will hold the value steady. The LEDS which are portmapped and connected to this register will then display the last value written. 

Draw up the hardware design, label the signals, etc. *before* writing VHDL. After writing VHDL and getting the hardware working, then update the drawings as needed to match the actual hardware. Keep both versions so you know what you learned.

### Exercise 1 Notes

The connections to the LED's and Switches must happen at the top level of your FPGA project (as illustrated previously). Thus, you need to :
1. Add an output port at the top level of your processor that carries out the 16 bit signal from the memory mapped output to the external world LEDs or advanced ouput device.
2. Add an input port at the top level of your processor that brings in the 16 bit switch signal from the external board into the processor and connects this signal to the special memory mapped input processing hardware. 

## 10 pts. Exercise 2: Advanced Input / Output

Exercise 2 is for the Advanced Input / Output required for an "A" grade on this project (the "Above and Beyond" I/O Implementation.) Basically to earn this your group must implement and demonstrate that a more advanced form of I/O (e.g. keyboard, VGA, SPI port, etc.) works with your processor.  You can interface with this more advanced I/O in many different ways, however, using the same approach as Exercise 1 is acceptable.

### Exercise 2 Notes
Again, draw up detailed hardware connections for the advanced I/O. Label the signals, etc.

Here are some ideas in order of relative complexity:
1. Keyboard driver - This is not too bad but requires a keyboard that is compatible with PS2 keyboard signals.  
2. VGA driver - Harder because you need a VGA display but not too hard to implement in VHDL. The difficult part is a VGA display memory that the VGA driver displays.
3. External RAM interface to the ram generated by Vivado's memory generator - follow the lab given previously and then integrate your processor to read / write to the RAM.
4. SPI input/output ports that are implemented on the FPGA board.  These could connect to the SPI joystick, etc.
5. Some other I/O device that you clear with me and is compatible with our boards.

## 35 pts. Exercise 3: Demonstration Program
Design a "Demonstration Program" (e.g. a game, a demo, etc.) that shows off the capabilities of you microprocessor as well as the I/O for your microprocessor. 
* If you did not complete Exercise 2, than this advanced program should incorporate your I/O from Exercise 1.  
* If your group did complete Exercise 2, than this program should incorporate that I/O hardware. You must demonstrate that this program works correctly on the FPGA and that the branch / jump statements work correctly, with correct values being computed. 

## 15 pts. Final Project Presentation
Your group's 20 minute final presentation will be delivered over discord during the final exam presentations.
1.	What was your original goal? What it what you ended up doing?
2.  Demonstrate your FPGA processor actually running and interacting with your I/O (either the basic I/O from exercise 1 or the more advanced I/O from exercise 2).
3.  Present your I/O design, your Microprocessor design using professional hardware diagrarms (similar to what we have in the book). 
4.  What challenges did you face? How did you overcome them? What did you learn?
5. Please also, at the end of your presentation say "Thank-You" to the alumni who made purchasing the BASYS 3 boards possible.  

## What to Push to the group Whigit Folder FP_4
1. Push all your VHDL code for your project into your group project folder FP_4 along with working gen.sh/setup.tcl scripts that will create the vivado project with a working simulation from the VHDL files/constraint/memory files in your project folder.
2. All the design documents in the project folder.
3. The final presentation document in the project folder.
4. Make sure your .gitignore file is correct!

## 25 pts. __Individual__ Final Reflection and Individual Contribution to the Project 
There will be a blackboard assignment to which you will submit your final (confidential) project reflection
1.	What did you learn doing this project?
2.	What went well?
3.	What challenges did you face individually?
4.	How did your group function? What could have been improved? How will you avoid any issues in the future?
5.  Evaluate each of your group members, how much did they contribute did they hold up the contract they signed onto? If you were assigning your group members a grade for their contributions to the group what grade would you give each of them?


# Evaluation Rubric
  

| CATEGORY |  Beginning 0%-79% | Satisfactory 80%-89% | Excellent 90%-100% |
|:--------:|:-----------------:|:--------------------:|:------------------:|
| 25 pts. Basic I/O | None or possibly one of the two switches or LEDs connected. | Both I/O connected and a satsifactory application program working | Excellent application program works with both switches and LEDs |
| 10 pts. Advanced I/O | No advanced I/O. Or for more points possibly just input or just advanced output and maybe not working correclty | Excellent advanced input or Excellent advanced output. | Excellent input, output and program all working on the board |
| 25 pts. Demostration Program  | Simulation test bench created but not documented well or does not work properly |	Single ad-hoc test code that tests every possible instruction. |	Both an ad-hoc program AND a more advanced program that runs correctly. |
| 25 pts. Mini Presentation | Little to no content, poor presentation. | Several of the required elements for Exercise 4 | All the required elements of Exercise 4 and a good presentation.
| 15 pts. Individual Reflection | Little to no reflection no grades assigned. | Some of the required elements of the reflection. Some evaluation of the group. | All the required elements of Exercise 4 and a good presentation and a good evaluation of group members.

