# Box Generator Circuit
Welcome to my CS373 Final Project.  I built a VHDL project that displays boxes on a VGA monitor.  I hope you enjoy!


## Goals
I intentionally documented my goals for this project.  As with any computer science project, it's important to organize the project into stages.  
The first thing that I did was outline my vision for the project.  I wanted my goal set to encompass a wide range of potential outcomes.  Defining goals across
the spectrum from simple to complex has a two-fold purpose.  The first aspect is that having simple, easily achievable goals helps me avoid getting overwhelmed 
in the early stages of the project.  It keeps me focused on taking the project one step of the time.  The second aspect that motivates defining robust goals is
to prevent me from settling on a local maximum.  It's important for me to include a few loft, even unrealistic goals so that I don't complete a project quickly
and settle for something that is far below my capabilities.  Having a solid goal set keeps me balanced.  The following is a list of the goals that I compiled
for this project, from simple to complex:
* I will write my own well-commented VHDL files
* I will create a box unit hard coded to be displayed on a VGA screen
* I will connect my box unit to one of the switches on my Basys3 board so that the box will appear/disappear based on the flip of a switch
* I will connect the box unit to 8 switches on the Basys3 board so that the box will appear/disappear in multiple locations on the screen based on the flip of different switches
* I will change the color of each box so that with each location iteration, the color of the box will change
* I will create a ROM register to hold ASCII characters
* I will create a component that will process the ASCII character and display it in my box unit
* I will add 7 more ASCII characters to the VHDL code and iterate through them so that a different ASCII character will show up in a different location on the screen based on the flip of a switch
* I will add the rest of the alphabet to the program so that every letter in the English alphabet is accounted for
* I will end by displaying an English message to my classmates by combining ASCII characters and display locations together connecting them to a switch on the Basys3 board so that when I flip the switch it displays the message

## Hardware Description and Diagram

![Top Level Hardware Design](https://whitgit.whitworth.edu/2020/fall/CS-373-1/Group_Projects/Final_Project/final_project_chennai/-/blob/master/.images/Top_level.PNG)

See directory .images for a visual representation of my hardware design (I couldn't get the picture to attach to the README.md file).

The hardware that I ended up with is a box generating circuit.  At the top level, I turn off the 7 segment displays.  My top level hardware uses the 100 MHZ clock signal to drive the horizontal and vertical sync unit, and I pull in switches 11 down to 0 to drive my core component which is called box_unit.  The box_unit instantiates 3 components: a color generating component, a color register component, and a box controller component.  I connect the red register signals to switches 11 down to 8, the green register signals to switches 7 down to 4 and the blue register to switches 3 down to 0.  My box_controller unit uses 4 2-bit standard logic vectors to display boxes on a VGA screen.  Each standard logic vector is connected to 2 switches.  I use if/elseif statements that generate multiplexers that connect the VGA monitor to the FPGA and assign cartesian coordinates to boxes on the screen.  When switches 0, 1, 2, 3, 8, 9, 10 and 11 are flipped, a box shows up at a different hard coded location on the screen.

To operate my box generator, toggle those switches on and off.  Because I used a separate set of signals to output the second box onto the screen, you can flip switches 0 and 1, 2 and 3, 8 and 9 and 10 and 11 together and end up with 2 boxes on the screen. 

## Works Cited

Special thanks to Dr. Kent Jones.  My code was based heavily on the examples provided by him in class.

