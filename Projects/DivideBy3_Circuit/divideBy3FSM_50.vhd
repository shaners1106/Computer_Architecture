-----------------------------------------------
-- Module Name:    divideby3FSM 
-- A true divide by 3 clock with 50% duty cycle
-----------------------------------------------
library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity divideby3FSM_50 is
    port ( clk :   in  STD_LOGIC;
           reset : in  STD_LOGIC;
           y :    out  STD_LOGIC);
end divideby3FSM_50;

-- Define the behavior of the divide by 3 circuit by
-- pulling in our d flip flop component

architecture Behavioral of divideby3FSM_50 is
   component D_FF is
      port (
         clk : in std_logic;
         reset : in std_logic;
         d : in std_logic;
         q : out std_logic;
         qNot : out std_logic
      );
   end component;

-- Remember to declare which signals you will need to wire
-- each individual d flip flop together

   signal d1    : std_logic := '0';
   signal q1    : std_logic := '0';
   signal q1Not : std_logic := '0';
   signal q2    : std_logic := '0';
   signal q2Not : std_logic := '0';
   signal q3    : std_logic := '0';
   
-- Now we need to port each flip flop into our circuit
-- by assigning each internal node of the individual 
-- d flip flop components to specific wires

begin

-- The first flip flop takes in (not q1 and not q2), 
-- reset and clock and outputs q1 and q1not

   A : D_FF port map(
      clk => clk,
      reset => reset,
      d => q1Not and q2Not,
      q => q1,
      qNot => q1Not      
   );

-- The second flip flop in our circuit takes in 
-- q1, reset and clock and outputs q2 and q2not

   B : D_FF port map(
      clk => clk,
      reset => reset,
      d => q1,
      q => q2,
      qNot => q2Not      
   );

-- The third flip flop takes in q2, reset and 
-- clock and outputs q3

   C : D_FF port map(
      clk => not clk,
      reset => reset,
      d => q2,
      q => q3     
   );

-- Finally, we define our output signals.  d1 is 
-- a combination of q1Not and q2Not.
-- y is an or of q2 q3

   d1 <= q1Not and q2Not;
   y <= q2 or q3;
	
end Behavioral;