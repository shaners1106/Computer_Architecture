
-- D Flip Flop Definition File

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity statement for our D Flip Flop component
-- We need three inputs(clock, reset and d) 
-- and 2 outputs(q and q not)

entity D_FF is
    Port ( clk   : in std_logic;
           reset : in std_logic;
           d     : in std_logic;
           q     : out std_logic;
           qNot  : out std_logic
        );
end D_FF;

-- Now we use the architectural section
-- to define the internal combinational 
-- logic of our D flip flop component

architecture D_FF of D_FF is
begin
    process(clk, reset, d)
    begin
        if reset = '1' then
            q <= '0';
            qNot <= '1';    -- MAKE SURE TO INITIALIZE
                            -- qNot AS WELL OR IT MIGHT
                            -- CREATE A 10 HOUR HICCUP
                            -- FOR YOURSELF  :)
        elsif (clk'event and clk = '1') then
            q <= d;
            qNot <= not d;
        end if;
    end process;    
end D_FF;
