#!/bin/bash

if ! command -v /C/Xilinx/Vivado/2020.1/bin/vivado &> /dev/null
then
    echo "Please add the vivado folder to the system path!"
    echo "It should look similar to this in the windows path: C:\Xilinx\Vivado\2020.1\bin\ "
    echo "It should look similar to this in your .bash_profile: /c/Xilinx/Vivado/2020.1/bin/"
    echo "If you cant get the path to work correctly, you can hardcode the path to vivado on line 10 of this file."
else
    /C/Xilinx/Vivado/2020.1/bin/vivado -mode batch -source ./setup_project.tcl
fi
