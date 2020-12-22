# Final Project
Class: CS 373 - Digital Logic Design
Last Modified: 11/22/2020

## Overview
The goal of the final project is to give you a chance to explore and apply digital logic design to the design and implementation of a hardware project you are interested in. 


### Grade Break Down
| Part               |                 | Points  |
|--------------------|-----------------|---------|
| Documentation: Readme.md File |  25 - good readme   | 25 pts  |    
| Working project submitted to whitgit| 18 - Good comments and code is working!  The project could have been better, it seems not quite enough time was allocated to it.  Looking forward to what you will do next semester! | 25 pts  |
| Final Presentation & Analysis |  25    | 25 pts  | 
| Final Reflection & Professionalism & Teamwork |   25      | 25 pts  |
| Total              |    93             | 100 pts |

### General Requirements
Overall this will be 30% of your total grade for this class.  
* Pick a problem or application that seems interesting to your group and implements the concepts we have learned this semester. 
* Example ideas for projects are listed later in this document. 
* Once you have picked a project, list the features that you hope to implement from easy to hard. 
* Whatever project you choose, layout a first draft of the major hardware components and the hardware design before you attempt to write the VHDL. 
* Divide your project up into major components. Design an entity for each unique component. 
* In your top level file, include the components and use portmaps to connect your design togther and to the FPGA board.

### Group Project Structure and Professionalism
You will be assigned a group for this final project. There is a survey on blackboard that you should complete before I assign groups so that you have some input to the make-up of your group.

Professional conduct when interacting with others in your group will be important. If there are specific reasons you cannot particpate in a group and wish to work alone, please state this in the group survey.

Desirable group behaviors are:
* Treating your group partner(s) the way you wish to be treated. 
* Following through on scheduled meetings (or texting/emailing if there is an emergency and a meeting can't be attended on time)
* Practicing good listening skills and diplomacy when discussing issues or problems with the hardware design. 
* Working to seek an understanding of your group partners and then focus on fixing issues.

In addition, since this project will be completed as a group, all VHDL hardware will be written utilizing pair/group programming, this means that:
* All group members will be present and actively engaged (e.g. using Live Share and Discord)  when working on the major hardware components together.
* Look for ways to include all group members in the design and learning process.  
* The rest of the work should be evenly divided among the group members and all group members should review all work before submitting it.
* The development of the documentation preferably should be done as a pair/group, but this is not required.
* Reliability in attending meetings, group project participation, will all form a part of your final grade for this project. 
  
All documents, with the exception of the confidential individual feedback sent via email, will be submitted via Whitgit. You and your partner will have access to a group project folder on whitgit. The submission closest to, but not past the start of the final presentations for your section will be graded.

### Project Description and Ideas

__I/O Components__
* A VGA text generator stream. This component can take an array of ASCII chars as input and then displays those characters onto the screen.
* Utilize a PS2 compatible USB keyboard and implement a keyboard scanner interface with an application on the board.
* Develop VHDL hardware that can talk to an external device via a pmod port

__A Game__
* Pong – use either a keyboard or buttons on the board as controllers. Show pong on the VGA monitor
* A Hardware Based Tic Tac Toe Game 
* Some other simple game
* Bonus points - program the SPI interface and use a joystick controller that's in the lab.
  
__PMOD Board Applications__
* Digital Filter - Implement a digital filter for filtering signals 
  
__A Mathematical Application or Processor__
* A floating point ALU to do floating point addition / subtraction / multiplication
* A Mandelbrot fractal generator (very challenging without a microprocessor and floating point)
* A hardware based encryption program that implements RSA (hard!) 
* A program for arbitrarily large integers (128 bits, 256 bits, … ) 
* Some other mathematical application approved by your instructor.
  
Some Other Application Approved by Your Instructor


### Deliverable #1: Project Proposal Due Mon Nov 30th 
I highly encourage each group to make a short project proposal to your instructor before you proceed. You don't want to be that group which at presentation time their project was not sufficient!  Take the time to talk to your instructor and determine if the level of difficulty is acceptable. Write up the project paragraph. Discuss this with your instructor before or on Nov 30th. This can eventually become a part of your projects Readme.md file.

### Deliverable #2: Final Project Readme.md File along  with the Final Project Due Fri Dec 18th at the final
Your group will submit a Readme.md file along with your with all the hardware VHDL files for your project to your shared Whitgit final project repository. 

The __Readme.md__ file will contain:
* The title of your final project VHDL device.
* A short description of the purpose and goals of the hardware device. 
* How to use the hardware
* What assumptions did you make when working on the project (e.g. knowledge level of users, etc.)?
* A hardware diagram of your project (use structural VHDL code to have this be readable and easily generated by vivado)
* __Works Cited__ This should includes any third party libraries used, any online sources and any VHDL utilized that was not specifically written for this project. These citations should also be listed directly in your VHDL.
* This documentation is worth 5% of your over all grade, make it representative of that weight. A single page likely will not be detailed enough.
* Your hardware must be appropriately commented. 

NOTE: Your hardware project must use the gen.sh script to build the project with vivado. 

### Deliverable #3: Final Presentation Fri Dec 18th at the final
During the final time for your section, your group will give a presentation on the work that you accomplished. 

* You must present your original (and possibly modified) goals.
* You must present your high level hardware diagram. You can draw this with a harware drawing tool, or if you use well designed structural VHDL code, then the hardware diagram made for you by Vivado will be easier to comprehend and read and of better quality for presentation.
* You must demonstrate your project working or describe what components are working and what roadblocks you encountered.
  

### Deliverable #4: Individual Project Reflection
In addition each group member will __email__ their instructor on the day of the final presentation an individual and confidential reflection of how the project went (subject line: CS 373 Project Reflection), along with a review of their group member(s) This will be worth 5% of your overall project grade. You should answer the following in this email:

* How did the project go? What went well? What would you do differently?
* How has your team dealt with the remote work aspect? What challenges have you faced and overcome?
* Did you and your team listen well to one another? Did you and your team work to positivly motivate each other? 
* Did you and your team made good team decisions, or did your or other team members make major decisions without first talking to the team as a whole?
* Did you and your team members shown passion/interest/enthusiasm for what you are building?
* What should you and your team keep doing well in the future?
* What improvements can you and your team make in the future to avoid these issues?
* Were your team objectives clear, did you make good progress?
