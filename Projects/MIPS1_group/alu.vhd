-------------------------------------------------
-- Module Name: alu - group designed 
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
--use IEEE.STD_LOGIC_VECTOR.all;
use IEEE.NUMERIC_STD.all;   

entity alu is
    generic ( N : integer := 32 );
    port (  
      a  : in  signed(N-1 downto 0);   -- operand A
      b  : in  signed(N-1 downto 0);   -- operand b
      f  : in  unsigned(3 downto 0);  --4bit function
      y  : out signed(N-1 downto 0)
    -- the alu connections to external circuitry:
      -- TODO - Design your groups ALU inputs and outputs!
    );-- operation result
end alu;

architecture Behavioral of alu is
  signal diff, sum, bnot : signed(N-1 downto 0);
  signal smaller, equal: signed(N-1 downto 0);
begin
  
  bnot <= not b;
  diff <= a + bnot + 1; -- THIS IS NOT SUM
  smaller <= (N-1 downto 1 => '0') & diff(N-1);
  equal <= (N-1 downto 1 => '0') & '1' when (a=b) else
           (N-1 downto 1 => '0') & '0'; 

  

  process (a, b, diff, f)
  begin
  

    case f is
      when "0000" => y <= a and b;
      when "0001" => y <= a or b;
      when "0010" => y <= a + b;
      when "0100" => y <= a and bnot;
      when "0101" => y <= a or bnot;
      when "0110" => y <= a + bnot + 1; -- a - b
      when "1000" => y <= smaller;
      when "1001" => y <= (N-1 downto 1 => '0') & not smaller(0); -->=???
      when "1010" => y <= equal;
      when "1011" => y <= (N-1 downto 1 => '0') & not equal(0);

      when others => y <= (others => 'X');
    end case;
  end process;
end Behavioral;


-- TODO - Design your group's ALU




