library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity divideby3FSM_top is
  port (
    CLK100MHZ : in std_logic; -- System clock 
    btnD      : in std_logic; -- Down Push Button 
    btnC      : in std_logic; -- Center Push Button
    sw        : in std_logic_vector (15 downto 0); -- 16 switch inputs
    LED       : out std_logic_vector (15 downto 0); -- 16 leds above switches
    an        : out std_logic_vector (3 downto 0); -- Controls four 7-seg displays
    seg       : out std_logic_vector(6 downto 0); -- 7 leds per display
    dp        : out std_logic -- 1 decimal point per display
  );
end divideby3FSM_top;

architecture divideby3FSM_top of divideby3FSM_top is

-- Define the divideby3FSM component here
  component divideBy3FSM_50 is
    port ( clk :   in  STD_LOGIC;
           reset : in  STD_LOGIC;
           y :    out  STD_LOGIC);
  end component;

  signal clk : STD_LOGIC := '0';

begin
  -- 100 mhz divider - Make a slow clock 
  -- this makes a 26 bit register and increments
  -- the register by 1 each 100 MHZ clock cycle
  -- the slow clock (clk) is driven by bit 25
  process ( CLK100MHZ ) 
		variable q: STD_LOGIC_VECTOR(25 downto 0);
	begin
      if rising_edge(CLK100MHZ) then 
        q := q + 1;
			  clk <= q(25);
      end if;
   end process;	


-- Divide the slow clock by 3 using the Divideby3 component
dvd : divideBy3FSM_50 port map( 
  clk => clk,
  reset => btnC,
  y => LED(0) -- drive LED 0 from slow clock divided by 3
);

-- Drive board's LED 1 from slow clock
LED(1) <= clk;

----------------------Leave this untouched------------------------------
-- Turn off the 7-segment LEDs
an <= "1111";     -- wires supplying power to 4 7-seg displays
seg <= "1111111"; -- wires connecting each of 7 * 4 segments to ground
dp <= '1';        -- wire connects decimal point to ground

end divideby3FSM_top;
