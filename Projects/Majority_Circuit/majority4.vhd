------------------------------------------------
-- Module Name: majority4 
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Create a Majority circuit.  This will entail 4 input bits and 1 output bit.  The output of this circuit
-- will depend on the activity of the 4 inputs.  If less than 3 of the 4 inputs are high, the output will
-- be low.  However, if 3 or 4 of the inputs are turned on, then the output bit will be high as well.  This
-- is a circuit that runs high in the even that the majority of the inputs are high

-- entity section

entity majority4 is
    port( a, b, c, d : in std_logic;        -- 4 inputs a, b, c, and d each can be either 0 or 1
          m : out std_logic );              -- Output m only needs 1 wire  
end majority4;

-- architectural section

architecture majority4 of majority4 is
begin
    -- m = bcd + abd + acd + abc
    m <= (    b and c and d )       -- Give to output bcd
         or ( a and b and d )       -- or abd
         or ( a and c and d )       -- or acd
         or ( a and b and c );      -- or abc
                             
end majority4;