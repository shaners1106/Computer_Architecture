--------------------------------------------------------
-- Shane Snediker
-- Dr. Jones CS 373 FINAL PROJECT
-- VGA Display Generator
-- 12/18/2020

-- *** I used Dr. Kent Jones' class examples as a foundation for this project  ***

----------------------------------------------------------

-- A file that create horizontal and vertical sync units that are used to 
-- track and display signals on a VGA monitor


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Initialize the horizontal/vertical sync entity
entity hv_syncs is
   port(
      clk, reset: in std_logic;
      hsync, vsync: out std_logic;
      video_on, p_tick: out std_logic;
      pixel_x, pixel_y: out std_logic_vector (9 downto 0)
    );
end hv_syncs;

architecture arch of hv_syncs is
   -- VGA 640-by-480 sync parameters
   constant HD: integer:=640; --horizontal display area
   constant HB: integer:=48 ; --h. back porch 
   constant HF: integer:=16 ; --h. front porch
   constant HR: integer:=96 ; --h. retrace
   constant VD: integer:=480; --vertical display area
   constant VB: integer:=33;  --v. back porch 
   constant VF: integer:=10;  --v. front porch
   constant VR: integer:=2;   --v. retrace
   
   -- clock frequency divider
   signal clk_divider : unsigned(1 downto 0) := "00";
   
   -- signals used for tracking the horizontal and vertical syncs
   signal v_count_reg, v_count_next: unsigned(9 downto 0) := to_unsigned(0,10);
   signal h_count_reg, h_count_next: unsigned(9 downto 0) := to_unsigned(0,10);
   
   -- signals for the output buffer
   signal v_sync_reg, h_sync_reg: std_logic;
   signal v_sync_next, h_sync_next: std_logic;
   
   -- status signal
   signal h_end, v_end, pixel_tick, clk50mhz, clk25mhz : std_logic;
begin

   -- clock divider divides the system clock by 4
   p_clk_divider: process(reset, clk, clk_divider)
   begin
     if(reset='1') then
       clk_divider <= (others=>'0');
     elsif(rising_edge(clk)) then
       clk_divider <= clk_divider + 1;
     end if;
   end process p_clk_divider;
   
   -- 50 and 25 MHz clocks
   clk50mhz <= clk_divider(0); 
   clk25mhz <= clk_divider(1);  
   
   -- Define a pixel tick using the 25MHZ clock
   pixel_tick <= clk25mhz;

   -- Create h/v sync registers
   process(clk50mhz, reset)
   begin
       if reset='1' then
          v_count_reg <= (others=>'0');
          h_count_reg <= (others=>'0');
          v_sync_reg <= '0';
          h_sync_reg <= '0';
       elsif (clk50mhz'event and clk50mhz='1') then 
          v_count_reg <= v_count_next;
          h_count_reg <= h_count_next;
          v_sync_reg <= v_sync_next;
          h_sync_reg <= h_sync_next;
       end if;
   end process;
   
   -- Create horizontal and vertical counters that track where the output is 
   -- currently at on the screen
   h_end <=  -- end of horizontal counter
      '1' when h_count_reg=(HD+HF+HB+HR-1) else --799
      '0';
   v_end <=  -- end of vertical counter
      '1' when v_count_reg=(VD+VF+VB+VR-1) else --524
      '0';
   
   -- Reset the horizontal counter every time the output reaches the end of the monitor
   process (h_count_reg,h_end,pixel_tick)
   begin
      if pixel_tick = '1' then  -- 25 MHz tick
         if h_end='1' then
            h_count_next <= (others=>'0');
         else
            h_count_next <= h_count_reg + 1;
         end if;
      else
         h_count_next <= h_count_reg;
      end if;
   end process;
   
   -- Reset the vertical counter every time the output reaches the bottom of the monitor
   process (v_count_reg,h_end,v_end,pixel_tick)
   begin
      if pixel_tick = '1' and h_end='1' then
         if (v_end='1') then
            v_count_next <= (others=>'0');
         else
            v_count_next <= v_count_reg + 1;
         end if;
      else
         v_count_next <= v_count_reg;
      end if;
   end process;
   
   -- Buffer the syncs to avoid glitch
   h_sync_next <=
      '1' when (h_count_reg>=(HD+HF))           --656
           and (h_count_reg<=(HD+HF+HR-1)) else --751
      '0';
	  
   v_sync_next <=
      '1' when (v_count_reg>=(VD+VF))           --490
           and (v_count_reg<=(VD+VF+VR-1)) else --491
      '0';
   
   -- video on/off
   video_on <=
      '1' when (h_count_reg<HD) and (v_count_reg<VD) else
      '0';
	  
   -- Make sure to output the signals
   hsync <= h_sync_reg;
   vsync <= v_sync_reg;
   pixel_x <= std_logic_vector(h_count_reg);
   pixel_y <= std_logic_vector(v_count_reg);
   p_tick <= pixel_tick;
   
end arch;