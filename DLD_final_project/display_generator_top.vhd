-------------------------------------------------------------------------------
-- Shane Snediker
-- Dr. Jones CS 373 FINAL PROJECT
-- VGA Display Generator
-- 12/18/2020 

-- *** I used Dr. Kent Jones' class examples as a foundation for this project  ***

-------------------------------------------------------------------------------

-- Top Level file pulls it all together


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity display_generator_top is
  port (
    -- System Clock  
    CLK100MHZ : in std_logic;

    -- vga inputs and outputs
    Hsync, Vsync : out std_logic; -- Horizontal and Vertical Synch
    vgaRed       : out std_logic_vector(3 downto 0); -- Red bits
    vgaGreen     : out std_logic_vector(3 downto 0); -- Green bits
    vgaBlue      : out std_logic_vector(3 downto 0); -- Blue bits   

    -- switches and LEDs
    btnC : in std_logic;     
    sw   : in std_logic_vector (11 downto 0); -- 12 switch inputs
    an   : out std_logic_vector (3 downto 0); -- Controls 7-seg displays
    seg  : out std_logic_vector(6 downto 0);  -- Controls 7-seg displays
    dp   : out std_logic                      -- 1 decimal point per display
  );
end display_generator_top;

architecture display_generator_top of display_generator_top is
  signal clk, reset           : std_logic;
  signal pixel_x, pixel_y     : std_logic_vector(9 downto 0);
  signal video_on, pixel_tick : std_logic;
begin
  clk   <= CLK100MHZ; -- system clock
  reset <= btnC;      -- reset signal for vga driver

  ---------------------------------------------------------------------------------
  -- Turn off the 7-segment LEDs
  an  <= "1111"; -- wires supplying power to 4 7-seg displays
  seg <= "1111111"; -- wires connecting each of 7 * 4 segments to ground
  dp  <= '1'; -- wire connects decimal point to ground
  ---------------------------------------------------------------------------------    

  ---------------------------------------------------------------------------------
  -- Instantiate your VGA sync circuit component
  vga_sync_unit : entity work.hv_syncs
    port map(
      clk => clk, reset => reset, hsync => Hsync,
      vsync => Vsync, video_on => video_on,
      pixel_x => pixel_x, pixel_y => pixel_y,
      p_tick => pixel_tick
    );

------------------------------------------------------------------------------------
  -- Instantiate the main component of this project: the box generator unit
  box_gen_unit : entity work.box_unit
    port map(
      video_on => video_on,
      pixel_tick => pixel_tick,
      sw => sw(11 downto 0),
      -- Connect the signal colors to the switches on the FPGA
      box_r => sw(11 downto 8), box_g => sw(7 downto 4), box_b => sw(3 downto 0),
      pixel_x => pixel_x, pixel_y => pixel_y,
      red => vgaRed, green => vgaGreen, blue => vgaBlue
   );

end display_generator_top;