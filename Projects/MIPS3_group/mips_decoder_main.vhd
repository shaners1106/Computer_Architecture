
library IEEE; 
use IEEE.STD_LOGIC_1164.all;


-- Levi Russell, Tyler Gamlem, Joseph McCann and Shane Snediker
-- CS 401 MIPS3 Single-Cycle Processor Group Project
-- Last Updated: 3-15-21



entity maindec is -- main control decoder
  port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
       memtoreg, memwrite: out STD_LOGIC;
       branch, alusrc:     out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       aluop:              out  STD_LOGIC_VECTOR(1 downto 0);
       extrabits:          out  STD_LOGIC_VECTOR(1 downto 0));
end;

architecture behave of maindec is
  signal controls: STD_LOGIC_VECTOR(10 downto 0);
begin
  process(op) begin
    case op is
      when "000000" => controls <= "11000001000"; -- Rtype
      when "100011" => controls <= "10100100000"; -- LW
      when "101011" => controls <= "0X101X00000"; -- SW
      when "000100" => controls <= "0X010X00101"; -- BEQ
      when "001000" => controls <= "10100000000"; -- ADDI
      when "000010" => controls <= "0XXX0X1XX00"; -- J
      when "001110" => controls <= "10100011000"; -- XORI 
      when "000111" => controls <= "0X010X00010"; -- BGTZ 
      when "000110" => controls <= "0X010X00011"; -- BLEZ 

      when others   => controls <= "-----------"; -- illegal op
    end case;
  end process;
  
  regwrite <= controls(10);
  regdst   <= controls(9);
  alusrc   <= controls(8);
  branch   <= controls(7);
  memwrite <= controls(6);
  memtoreg <= controls(5);
  jump     <= controls(4);
  aluop    <= controls(3 downto 2);
  extrabits <= controls(1 downto 0);  -- Last 2 bits of the control signal
end;


