----------------------------------------------------------------------------------
-- Shane Snediker
-- Dr. Jones CS 373 FINAL PROJECT
-- VGA Display Generator
-- 12/18/2020 


-- *** I used Dr. Kent Jones' class examples as a foundation for this project  ***


-----------------------------------------------------------------------------------

-- A file that colors a box to a VGA screen with a contrasted background

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity col_gen is
  port (
    pixel_x, pixel_y                       : in std_logic_vector(9 downto 0);   -- signals for the screen pixels
    box_xl, box_yt, box_xr, box_yb         : in integer := 0;                   -- numeric standard integers for giving the box Cartesian coordinate values
    box2_xl, box2_xr, box2_yt, box2_yb     : in integer := 0;                   -- A second set of num_std ints for displaying a second box on the screen
    box_r, box_g, box_b                    : in std_logic_vector(3 downto 0);   -- box color signals
    red, green, blue                       : out std_logic_vector(3 downto 0)   -- output signals for sending color to VGA screen
  );
end col_gen;

architecture col_gen of col_gen is
begin

  -- process to generate output colors for the box           
  process (pixel_x, pixel_y, box_xl, box_xr, box_yt, box_yb, box2_xl, box2_xr, box2_yt, box2_yb)
  begin
    -- Draw a square using box 1's coordinates
    if (unsigned(pixel_x) > box_xl) and (unsigned(pixel_x) < box_xr) and
      (unsigned(pixel_y) > box_yt) and (unsigned(pixel_y) < box_yb) then
      -- Color every pixel within the box
      red   <= box_r;
      green <= box_g;
      blue  <= box_b;
    -- Draw a square using box 2's coordinates
    elsif (unsigned(pixel_x) > box2_xl) and (unsigned(pixel_x) < box2_xr) and
         (unsigned(pixel_y) > box2_yt) and (unsigned(pixel_y) < box2_yb) then
      -- Color every pixel within the box
      red <= box_r;
      green <= box_g;
      blue <= box_b;

    else
      -- Color every pixel not within the box the complement of the box color
      red   <= not box_r;
      green <= not box_g;
      blue  <= not box_b;
    end if;
  end process;

end col_gen;