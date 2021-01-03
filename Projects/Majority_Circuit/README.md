# Digital Design and Computer Architecture
## LM8 4 Bit Majority Gate

## Introduction

Open the LM8_4_Input_Majority_Gate.docx project and answer the questions in that document. Submit that document with your answers in it back here to Whitgit. 

For this learning module, you must modify the following three VHDL files.
You will also need to modify one line in the setup_project.tcl file once you are ready to build a bitstream. This file is currently setup to create a simulation project. 

1. majority4.vhd 
   * Complete the vhdl code in this file to make the majority4 component.
      * This should have 4 std_logic inputs, a, b, c, d
      * This should have 1 std_logic output, m
   * This vhdl is the majority4 entity and as such this should not have signals that communicate directly to the FPGA. (see majority_4_top.vhd to connect to those signals).
2. sim_testbench/sim_majority4.vhd
   * Modify this testbench and write code to test your majority4 compoment. There are comments in the file to help prompt you with what should go where.
   * This vhdl file contains testbench simulation code that does NOT synthesize directly to hardware.
   * It should load the majority4 component and simulate inputs to the majority4 gate. 
3. majority4_top.vhd
   * This is the top level vhdl file that interfaces to the FPGA board.
   * Map SW(4) SW(3) ... SW(0) to a, b, c, d of the majority4 component.
   * Map LED(0) to the output m of your majority circuit.
   * The signals in the top level entity statement *must* match the names in the Basys3_Master.xdc file.

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

# Understanding the setup_project.tcl script
You will also need to modify one line in the setup_project.tcl file once you are ready to build a bitstream. This file is currently setup to create a simulation project. 

The start of the setup_project.tcl file is where you set variables that will affect the script. Currently this script is configured correctly for this project. You don't have to do anything. 

The beginning of this file has changed from the previous file, because it has been modified to also generate the bitstream file automatically.

If you want to re-purpose this script for your own VHDL project, you will need to change the variable contents at the beginning of the tcl script.







