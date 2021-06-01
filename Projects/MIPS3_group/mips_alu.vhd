---------------------------------------------------------------
-- Arithmetic/Logic unit with add/sub, AND, OR, set less than


-- Levi Russell, Tyler Gamlem, Joseph McCann and Shane Snediker
-- CS 401 MIPS3 Single-Cycle Processor Group Project
-- Last Updated: 3-15-21

---------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity alu is 
  generic(width: integer);
  port(a, b:       in  STD_LOGIC_VECTOR((width-1) downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
       extrabits:  in  STD_LOGIC_VECTOR(1 downto 0);  -- These are our extra bits from the controller that go into the processor's ALU unit
       result:     inout STD_LOGIC_VECTOR((width-1) downto 0);
       zero:       out STD_LOGIC);
end;

architecture behave of alu is
  signal b2, sum, xori, slt: STD_LOGIC_VECTOR((width-1) downto 0);
  signal const_zero : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '0');

  -- The following signals will be used in our ALU for the branch instructions
  signal beqValue, bgtzValue, blezValue : STD_LOGIC;
begin
   
  -- hardware inverter for 2's complement 
  b2 <= not b when alucontrol(2) = '1' else b;
  
  -- hardware adder
  sum <= a + b2 + alucontrol(2);

  xori <= (not a and b) or (a and not b);
  
  -- slt should be 1 if most significant bit of sum is 1
  slt <= ( const_zero(width-1 downto 1) & '1') when sum((width-1)) = '1' else (others =>'0');
  
  -- determine alu operation from alucontrol bits 0 and 1
  with alucontrol(1 downto 0) select result <=
    a and b when "00",
    a or b  when "01",
    sum     when "10",
    xori    when "11",  -- This value was not used in the given ALU design, so we will designate it for the XORI instruction
    slt     when others;
	
  -- We couldn't figure out how to combine our branch signals into less code, so we've created 3 separate signals to handle 
  -- the corresponding logic 
  blezValue <= '1' when a <= 0 else '0';
  bgtzValue <= '1' when a > 0 else '0';
  beqValue <= '1' when result = const_zero else '0';
  -- set the zero flag if result is 0
  with extrabits(1 downto 0) select zero <=
  bgtzValue when "10", --BGTZ
  blezValue when "11", --BLEZ
  beqValue when "01", --BEQ
  '0' when others;

  
end;
