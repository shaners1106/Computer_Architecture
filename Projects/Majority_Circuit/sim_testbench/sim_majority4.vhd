-------------------------------------------------------------------------
-- Module Name: sim_majority4 Test Bench Code
-------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_majority4 is
--  Port ( );           -- we don't need a port here!
end sim_majority4;

-- Let's include our simulation architectural section:

architecture Behavioral of sim_majority4 is
    -- No entity statements here.  Rather declare your components
    component majority4 is
      port( a, b, c, d : in std_logic;    
            m : out std_logic );                              
  end component;


-- Now we need to define signal wires to drive our inputs:

signal sim_a : std_logic := '0';
signal sim_b : std_logic := '0';
signal sim_c : std_logic := '0';
signal sim_d : std_logic := '0';


-- define a signal wire to drive our output

signal sim_m : std_logic;

-- Now we define the component we want to test

begin
-- Define a majority4 hardware object and connect its inputs to our simulation signals
sim_unit : majority4 Port Map ( 
        -- Connect each simulation wire to its corresponding input or output
        a => sim_a,
        b => sim_b,
        c => sim_c,
        d => sim_d,
        m => sim_m
        );

process begin

    -- Let's test 8 out of the 16 possible test cases for this simulation

    -- 0000 case should result in a 0 output
    sim_a <= '0'; sim_b <= '0'; sim_c <= '0'; sim_d <= '0'; wait for 10 ns;
    assert sim_m = '0' report "m failed the 0 0 0 0 case";
    
    -- 0001 case should result in a 0 output
    sim_a <= '0'; sim_b <= '0'; sim_c <= '0'; sim_d <= '1'; wait for 10 ns;
    assert sim_m = '0' report "m failed the 0 0 0 1 case";

    -- 0011 case should result in a 0 output
    sim_a <= '0'; sim_b <= '0'; sim_c <= '1'; sim_d <= '1'; wait for 10 ns;
    assert sim_m = '0' report "m failed the 0 0 1 1 case";

    -- 1000 case should result in a 0 output
    sim_a <= '1'; sim_b <= '0'; sim_c <= '0'; sim_d <= '0'; wait for 10 ns;
    assert sim_m = '0' report "m failed the 1 0 0 0 case";

    -- 1100 case should result in a 0 output
    sim_a <= '1'; sim_b <= '1'; sim_c <= '0'; sim_d <= '0'; wait for 10 ns;
    assert sim_m = '0' report "m failed the 1 1 0 0 case";

    -- 1111 case should result in a 1 output
    sim_a <= '1'; sim_b <= '1'; sim_c <= '1'; sim_d <= '1'; wait for 10 ns;
    assert sim_m = '1' report "m failed the 1 1 1 1 case";

    -- 0111 case should result in a 1 output
    sim_a <= '0'; sim_b <= '1'; sim_c <= '1'; sim_d <= '1'; wait for 10 ns;
    assert sim_m = '1' report "m failed the 0 1 1 1 case";

    -- 1110 case should result in a 1 output
    sim_a <= '1'; sim_b <= '1'; sim_c <= '1'; sim_d <= '0'; wait for 10 ns;
    assert sim_m = '1' report "m failed the 1 1 1 0 case";

end process;


end Behavioral;
