----------------------------------------------------------------------------------
-- Shane Snediker
-- Dr. Jones CS 373 FINAL PROJECT
-- VGA Display Generator
-- 12/18/2020 


-- *** I used Dr. Kent Jones' class examples as a foundation for this project  ***

-----------------------------------------------------------------------------------

-- A core file that instantiates the necessary components to create a box generating unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity box_unit is
  port (
    sw               : in std_logic_vector (11 downto 0); -- Pull in some switches that we will use to display boxes on the VGA screen
    video_on         : in std_logic;                      -- vga synch signal
    pixel_tick       : in std_logic;                      -- pixel tick from vga synch generator
    pixel_x, pixel_y : in std_logic_vector(9 downto 0);   -- counters from vga synch
    box_r            : in std_logic_vector(3 downto 0);   -- input red bits for the box color
    box_g            : in std_logic_vector(3 downto 0);   -- input green bits for the box color
    box_b            : in std_logic_vector(3 downto 0);   -- input blue bits for the box color  
    red              : out std_logic_vector(3 downto 0);  -- output red for mapping to vga
    green            : out std_logic_vector(3 downto 0);  -- output green for mapping to vga
    blue             : out std_logic_vector(3 downto 0)   -- output blue for mapping to vga
  );
end box_unit;

architecture box_unit of box_unit is
  -- Bring in signals to wire up your components
  signal box_xl, box_yt, box_xr, box_yb, box2_xl, box2_yt, box2_xr, box2_yb : integer := 0;  -- Numeric standard ints
  signal red_reg, red_next: std_logic_vector(3 downto 0) := (others => '0');
  signal green_reg, green_next: std_logic_vector(3 downto 0) := (others => '0');
  signal blue_reg, blue_next: std_logic_vector(3 downto 0) := (others => '0');
begin

  -------------------------------------------------------------------------------------
  -- Instantiate the unit that controls the box location
  box_controller_unit : entity work.box_controller
  port map (
    -- Connect the switches
    sw1 => sw(1 downto 0),   -- in: the first 2 switches
    sw2 => sw(3 downto 2),   -- in: 2nd and 3rd switches
    sw3 => sw(9 downto 8),   -- in: 8th and 9th switches
    sw4 => sw(11 downto 10), -- in: 10th and 11th switch
    -- Connect the signals that track the location of the box
    box_xl => box_xl,        -- out: left x box position for box 1
    box_xr => box_xr,        -- out: right x box position for box 1
    box_yt => box_yt,        -- out: top y box position for box 1
    box_yb => box_yb,        -- out: bottom y box position for box 1
    box2_xl => box2_xl,      -- out: left x box position for box 2
    box2_xr => box2_xr,      -- out: right x box position for box 2
    box2_yt => box2_yt,      -- out: top y box position for box 2
    box2_yb => box2_yb       -- out: bottom y box position for box 2
  );

  ---------------------------------------------------------------------------------------
  -- Instantiate the unit that controls the box colors
  col_gen_unit : entity work.col_gen
  port map (
    -- Connect signals
    pixel_x => pixel_x,
    pixel_y => pixel_y,
    box_xl => box_xl, 
    box_xr => box_xr, 
    box_yt => box_yt, 
    box_yb => box_yb,
    box2_xl => box2_xl,
    box2_xr => box2_xr,
    box2_yt => box2_yt,
    box2_yb => box2_yb,
    box_r => box_r,      -- Red within the box
    box_g => box_g,      -- Green within the box
    box_b => box_b,      -- Blue within the box
    red => red_next,     -- Red takes whatever value is stored in the red register
    green => green_next, -- Green takes whatever value is stored in the green register
    blue => blue_next    -- Blue takes whatever value is stored in the blue register
  );

  ----------------------------------------------------------------------------------------
  -- Instantiate the unit containing the registers that hold the colors steady
  col_regs_unit : entity work.col_regs
  port map (
    -- Connect signals
    video_on => video_on,
    pixel_tick => pixel_tick,
    red_D => red_next,      -- Take in the value from the Red register
    green_D => green_next,  -- Take in the value from the Green register
    blue_D => blue_next,    -- Take in the value from the Blue register
    red_Q => red,           -- Output red to the VGA port
    green_Q => green,       -- Output green to the VGA port
    blue_Q => blue          -- Output blue to the VGA port
  );
  

end box_unit;