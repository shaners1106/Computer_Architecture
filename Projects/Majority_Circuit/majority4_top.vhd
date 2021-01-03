library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity majority4_top is
  Port ( sw : in STD_LOGIC_VECTOR (15 downto 0);  -- 16 switch inputs
        LED : out STD_LOGIC_VECTOR (15 downto 0);  -- 4 leds above switches
        an  : out STD_LOGIC_VECTOR (3 downto 0);  -- Controls four 7-seg displays
        seg : out STD_LOGIC_VECTOR(6 downto 0);   -- 6 leds per display
        dp  : out STD_LOGIC                       -- 1 decimal point per display
  );
end majority4_top;

-- Top level architectural section defines the components we will be using

architecture majority4_top of majority4_top is
  -- No entity statements here.  Rather declare your components
  component majority4 is
    port( a, b, c, d : in std_logic;    
          m : out std_logic                                 
    );                              
end component;
begin

-- We need to map the Basys3 board components to our Majority  component

c1 : majority4 port map( a => sw(3),       -- Give input a to switch 3
                         b => sw(2),       -- Give input b to switch 2
                         c => sw(1),       -- Give input c to switch 1
                         d => sw(0),       -- Give input d to switch 0
                         m => LED(0) );     -- Finally route the output
                                            -- LED 0

----------------------Leave this untouched------------------------------
-- Turn off the 7-segment LEDs
an <= "1111";     -- wires supplying power to 4 7-seg displays
seg <= "1111111"; -- wires connecting each of 7 * 4 segments to ground
dp <= '1';        -- wire connects decimal point to ground

end majority4_top;
