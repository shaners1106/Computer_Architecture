---------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-6-21


-- Define our shift entity
-- This module uses a for loop to create N parallel comparators
-----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

-- Define the shift components
entity shift is
   generic ( N : integer := 32 );
   Port (    a : in  STD_LOGIC_VECTOR(N-1 downto 0);
	     shamt : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);
             c : out  STD_LOGIC_VECTOR(N-1 downto 0);
             R : in STD_LOGIC );
end shift;

-- Create a loop to implement parallel comparators
architecture Behavioral of shift is
begin
 process(a, shamt)
 begin
    for i in 0 to N-1 loop
        if shamt = std_logic_vector(to_unsigned(i,N)) then
            if R = '1' then
                c <= std_logic_vector( unsigned(a) srl i );
            else
                c <= std_logic_vector( unsigned(a) sll i );
            end if;
        end if;
    end loop;
 end process;
 
end Behavioral;