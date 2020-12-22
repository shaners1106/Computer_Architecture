----------------------------------------------------------------------------------
-- Shane Snediker
-- Dr. Jones CS 373 FINAL PROJECT
-- VGA Display Generator
-- 12/18/2020 


-- *** I used Dr. Kent Jones' class examples as a foundation for this project  ***


-----------------------------------------------------------------------------------
  
-- A file that gives definition to a component that creates registers for the 3 VGA
-- colors in order to hold the colors steady during video_on  


  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
  entity col_regs is
    port (
      video_on   : in std_logic;  -- vga synch signal
      pixel_tick : in std_logic;  -- pixel tick for each pixel generated     
      red_D, green_D, blue_D : in std_logic_vector(3 downto 0);  -- next value of r,g,b
      red_Q, green_Q, blue_Q : out std_logic_vector(3 downto 0)  -- current value of r,g,b     
    );
  end col_regs;
  
  architecture col_regs of col_regs is
  begin
    
    -- generate red, green, and blue registers using the rising edge of the clock
    process (video_on, pixel_tick, red_D, green_D, blue_D)
    begin
        -- Use the rising edge of the clock to save color signals in a register
        if rising_edge(pixel_tick) then
        if (video_on = '1') then
            red_Q   <= red_D;
            green_Q <= green_D;
            blue_Q  <= blue_D;
        else
            red_Q   <= "0000";
            green_Q <= "0000";
            blue_Q  <= "0000";
        end if;
        end if;
    end process;
    
  end col_regs;