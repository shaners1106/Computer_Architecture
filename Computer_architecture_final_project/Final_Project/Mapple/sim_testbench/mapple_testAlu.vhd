---------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 3
-- Last updated: 4-27-21

--  Purpose: Test all operations in the alu used by the hashing algorithm

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH
 
ENTITY sim_group_alu IS
END sim_group_alu;
 
ARCHITECTURE behavioral OF sim_group_alu IS 

  -- These signals are used to wire the alu to the board level signals
  signal ki_sim  : STD_LOGIC_VECTOR( 7 downto 0 );
  signal address_sim, next_ki_sim :  STD_LOGIC_VECTOR(7 downto 0);
  signal h_sim : STD_LOGIC_VECTOR(31 downto 0);

  ----------------------------------------------------------------------------------------
  -- Function to_string for testbench
  -- convert a STD Logic vector to a string so we can report it in the testbench console
  -- output.
  -- source: https://stackoverflow.com/questions/15406887/vhdl-convert-vector-to-string
  -----------------------------------------------------------------------------------------
  function to_string ( a: std_logic_vector) return string is
    variable b : string (1 to a'length) := (others => NUL);
    variable stri : integer := 1; 
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
        stri := stri+1;
        end loop;
    return b;
  end function;

BEGIN
    uut : entity work.alu generic map( N => 4 )
    port map( ki => signed(ki_sim), h => signed(h_sim), address => address_sim, next_ki => next_ki_sim, ki_zero_flag => zero_sim );

  stim_proc: process
      variable i: INTEGER range 0 to 4; 
      signal highorder: std_logic_vector(31 downto 0);
   begin
    -- We aren't 100% sure how to really test our alu as hashing is meant to be random		
      for count in 0 to 4 loop
        if count = 0 then
          h_sim <= x"00000000";

          if h_sim /= x"00000000" then
            report "ERROR: count 0";

          highorder <= h_sim and  x"f8000000";
        elsif count = 1 then
          -- Bitshift testing will be tested in shifting component test.
          --highorder <= highorder_shift; -- Shift right 27 bits
        elsif count = 2 then
          -- Bitshift testing will be tested in shifting component test.
          --h_sim <= h_sim_shift;         -- Shift left 5 bits
        elsif count = 3 then
          h_sim <= h_sim xor highorder;

          if h_sim /= h_sim xor highorder then
            report "ERROR: count 3";

        elsif count = 4 then
          h_sim <= h_sim xor ki_sim;

          if h_sim /= h_sim xor ki_sim then
            report "ERROR: count 4";
      end loop;
   end process;
END behavioral;
