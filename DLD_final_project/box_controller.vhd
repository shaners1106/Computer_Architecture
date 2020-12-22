----------------------------------------------------------------------------------
-- Shane Snediker
-- Dr. Jones CS 373 FINAL PROJECT
-- VGA Display Generator
-- 12/18/2020 


-- *** I used Dr. Kent Jones' class examples as a foundation for this project  ***

-----------------------------------------------------------------------------------

-- A file that gives definition to switches that will control the location of the box
-- being printed on the screen

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- We will need number comparisons

-- Create an entity that will allow us to control the movement of the display box on the screen
entity box_controller is
    port (
        sw1, sw2, sw3, sw4                 : in std_logic_vector;  -- Use 4 2 bit switches to control box locations
        box_xl, box_xr, box_yt, box_yb     : out integer := 0;     -- Give the 4 box corners definition
        box2_xl, box2_xr, box2_yt, box2_yb : out integer := 0      -- Grab another 4 signals to allow for multiple
    );
end box_controller;

architecture box_controller of box_controller is
    -- Where do we want the box locations to be?
begin
    -- Define different locations of the box depending on the switch
    process ( sw1, sw2, sw3, sw4 )
        -- Initialize 4 variables we will use to provide cartesian coordinates to the boxes that we are going to display on the VGA screen
        variable x, y, u, v : integer := 0;
    begin

        -- Define distinct screen locations for the box depending on which switch is on
        -- sw1, sw2, sw3 and sw4 are each 2 bit std_logic_vectors.  So, we can use boolean 
        -- math to display boxes onto the VGA screen 

        -- sw1 is connected to switches 0 and 1 on the FPGA
        -- Therefore if only switch 0 is turned on, put a box in the upper left corner of the screen
        if (sw1 = "01") then
            x := 0;
            y := 0;
        -- If only switch 1 is turned on, place a box in the upper right corner of the screen
        elsif (sw1 = "10") then
            u := 540;
            v := 0;
        -- However, if both switch 0 and switch 1 are turned on, display both boxes
        elsif (sw1 = "11") then
            x := 0;
            y := 0;
            u := 540;
            v := 0;
        -- sw2 is connected to switches 2 and 3 on the FPGA
        -- Therefore if only switch 2 is on, display a box at 100, 100
        elsif (sw2 = "01") then
            x := 150;
            y := 100;
        -- If only switch 3 is turned on, display a box at 550, 100
        elsif (sw2 = "10") then
            u := 420;
            v := 100;
        -- But if 2 and 3 are both turned on, display both boxes
        elsif (sw2 = "11") then
            x := 150;
            y := 100;
            u := 420;
            v := 100;
        -- sw3 is connected to switches 8 and 9 on the FPGA
        -- If only switch 8 is turned on, display a box at 200, 200
        elsif (sw3 = "01") then
            x := 250;
            y := 200;
        -- If only switch 9 is on, display a box at 100, 200
        elsif (sw3 = "10") then
            u := 150;
            v := 200;
        -- But if they're both turned on, display both boxes
        elsif (sw3 = "11") then
            x := 250;
            y := 200;
            u := 150;
            v := 200;
        -- sw4 is connected to switches 10 and 11 on the FPGA
        -- If only switch 10 is turned on, display a box at 300,300
        elsif (sw4 = "01") then
            x := 400;
            y := 370;
        -- If only switch 11 is turned on, display a box at 0, 300
        elsif (sw4 = "10") then
            u := 0;
            v := 370;
        -- If both switches are turned on, display both boxes
        elsif (sw4 = "11") then
            x := 400;
            y := 370;
            u := 0;
            v := 370;
        -- If any other configuration of buttons is in place, send the boxes off the screen
        else
            x := 800;
            y := 400;
            u := 800;
            v := 400;
        end if;
        -- Give the x,y coordinates their corresponding positions
        -- Box 1 signals and coordinates
        box_xl <= x;
        box_xr <= x + 100;
        box_yt <= y;
        box_yb <= y + 100;
        -- Box 2 signals and coordinates
        box2_xl <= u;
        box2_xr <= u + 100;
        box2_yt <= v;
        box2_yb <= v + 100;

    end process;

end box_controller;




