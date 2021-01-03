# Digital Design and Computer Architecture
## LM9 Sequential VHDL

## Introduction

Open the LM9_divideBy3FSM_50_Duty_Cycle.docx project and answer the questions in that document. Submit that document with your answers in it back here to Whitgit. 

For this learning module, the top level vhdl file and the simulation file, the setup_project.tcl files have all been made for you. You must modify the __divideBy3FSM_50.vhd__ there are instructions in the file for where to put your vhdl code.

The setup_project.tcl is ready to build a simulation and a bitstream. This file is currently setup to create a simulation project. 

1. divideBy3FSM_50.vhd 
   * Complete the vhdl code in this file to make the divideBy3FSM_50 component.
   * The port statements have already been made for you. You need to make the behavioral hardware to match the hardware design given in the .docx file.
   
2. sim_testbench/sim_divideby3FSM_50.vhd
   * The testbench has been written for you. 
   * Run the testbench and take a screen shot of the divide by 3 signal working correctly. Paste this screen shot in the .docx file.
  
3. divideBy3FSM_top.vhd
   * This is the top level vhdl file that interfaces to the FPGA board.
   * The top level file has a divider circuit that generates a slow (close to a second) clock. This clock maps to the LED(1). 
   * LED(0) is mapped to the output of your divideBy3 hardware.
   * The signals in the top level entity statement already match the names in the Basys3_Master.xdc file. You don't have to modify either of these files.

# Important notes:

* If you leave the Vivado project running when you got to re-run the project generation (./gen.sh), the generation will fail! You MUST close Vivado when re-generating a project!
* Always READ the outputs of the ./gen.sh script. If you see Error messages, something is wrong and you will need to fix the errors!
* Warnings are not neccessarily a problem.

# Generating and running a simulation
Open a bash terminal in vscode, and run the following command in the terminal:
```
./gen.sh
```
This will generate the Vivado project automatically. Open the folder multibitshifter/ that the script generates and run the .xpr file for the vivado project.





