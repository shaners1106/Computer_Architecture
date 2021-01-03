-------------------------------------------------------------------------
-- Module Name: sim_divideby3FSM_50 Test Bench Code
-------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_divideby3FSM_50 is
--  Port ( );           -- we don't need a port here!
end sim_divideby3FSM_50;

architecture Behavioral of sim_divideby3FSM_50 is

-- declare the divideby3FSM_50 component here
component divideBy3FSM_50 is
    port ( clk :   in  STD_LOGIC;
           reset : in  STD_LOGIC;
           y :    out  STD_LOGIC);
end component;

-- define signal wires to drive the inputs of our divideby3FSM_50 module
signal clk : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal y : STD_LOGIC := '0';
-- define a signal wire for the output of our divideby3FSM_50 module

begin
      
   -- Clock process definitions
   clk_process : process
   begin
        clk <= '0';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
   end process;

    -- Define a divideby3FSM_50 hardware object and connect its inputs to our simulation signals
    sim_unit : divideBy3FSM_50 port map( 
        clk => clk,
        reset => reset,
        y => y
    );

    process begin
        -- drive the input wires here 
        -- assert statement to check the outputs
        -- look at the comp2bit example to get ideas on how to do this.
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 180 ns;
    end process;


end Behavioral;
