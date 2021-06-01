library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity shift_right is
    generic ( N : integer := 32 );
        Port ( a : in STD_LOGIC_VECTOR(N-1 downto 0);
               shamt : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);
               c : out STD_LOGIC_VECTOR(N-1 downto 0) );
   end shift_right;
   
architecture Behavioral of shift_right is
   begin
        process(a, shamt)
   begin
    for i in 0 to N-1 loop
        if shamt = std_logic_vector(to_unsigned(i,N)) then
        c <= std_logic_vector( unsigned(a) srl i );
        end if;
    end loop;
   end process;
end Behavioral;