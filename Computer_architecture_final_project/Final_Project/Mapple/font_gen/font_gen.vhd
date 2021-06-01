-------------------------------------------------------------------------------
-- Listing 13.2
-- Code modified from https://academic.csuohio.edu/chu_p/rtl/fpga_vhdl.html
-- Updated 12/2/2020 by Kent Jones
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity font_gen is
  port (
    clk              : in std_logic;
    video_on         : in std_logic;
    ps2_code_new     : in std_logic; -- new char available
    char_num         : in std_logic_vector(6 downto 0);
    pixel_x, pixel_y : in std_logic_vector(9 downto 0);
    rgb_text         : out std_logic_vector(2 downto 0)
  );
end font_gen;

architecture font_gen of font_gen is
  signal rom_addr  : std_logic_vector(10 downto 0);
  signal row_addr  : std_logic_vector(3 downto 0);
  signal bit_addr  : std_logic_vector(2 downto 0);
  signal font_word : std_logic_vector(7 downto 0);
  signal font_bit  : std_logic;
  signal char      : std_logic_vector(6 downto 0);
  signal x         : integer := 0;
  signal y         : integer := 0;

  type screen_type is array (0 to 79, 0 to 29) of std_logic_vector(6 downto 0); 
  
  signal screen_buf : screen_type;

begin

  process (ps2_code_new, char_num, clk, video_on)
    variable ps2_code_new_last : std_logic := '0';
    variable x, y : integer := 0;
  begin
    if rising_edge(clk) then
        -- If a new key is available put into screen memory
        if ( ps2_code_new_last = '0' and ps2_code_new = '1' and video_on = '1' ) then
            -- put chars into screen buf filling left to right and 
            -- top to bottom as then come from the keyboard
            x := x + 1;
            if ( x > 79 ) then 
                x := 0;
                y := y + 1;
            end if;
            -- Move the the next line
            if ( y > 29 ) then
                y := 0;
            end if;
            -- store in screen memory
            screen_buf(x,y) <= char_num;
        end if;

        ps2_code_new_last := ps2_code_new;
    end if;
  end process; 

  
  -- get x, y loc for next char to draw from screen buffer memory
  x <= to_integer(unsigned(pixel_x(9 downto 3))) - 2;
  y <= to_integer(unsigned(pixel_y(9 downto 4)));
  char <= screen_buf(x,y) when x >= 0 and x < 80 else (others => '0');

  -- compute the address in rom for character number char_num
  row_addr <= pixel_y(3 downto 0);
  rom_addr <= char & row_addr;

  -- lookup the 8 bit font_word from the font rom
  font_unit : entity work.font_rom
    port map(clk => clk, addr => rom_addr, data => font_word);

  bit_addr <= not (pixel_x(2 downto 0)) + "001";
  font_bit <= font_word(to_integer(unsigned(bit_addr)));

  -- rgb multiplexing circuit
  process ( video_on, font_bit )
  begin
    if video_on = '0' then
      rgb_text <= "000"; --blank
    else
      if font_bit = '1' then
        rgb_text <= "010"; -- green
      else
        rgb_text <= "000"; -- black
      end if;
    end if;
  end process;
end font_gen;