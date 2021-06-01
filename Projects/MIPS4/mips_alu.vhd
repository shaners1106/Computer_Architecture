---------------------------------------------------------------
-- Arithmetic/Logic unit with add/sub, AND, OR, set less than
---------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity alu is 
  generic(width: integer);
  port(a, b:       in  STD_LOGIC_VECTOR((width-1) downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
       shamt:      in  STD_LOGIC_VECTOR(4 downto 0);
       result:     inout STD_LOGIC_VECTOR((width-1) downto 0);
       zero:       out STD_LOGIC);
end;

architecture behave of alu is

-------------------------------------------------------------------------
-- Elizabeth Roberts, Benjamin Greenwood, Christopher Oriolt and Shane Snediker
-- CS 401 MIPS 4
--Last updated: 3-24-21
-------------------------------------------------------------------------

  --shift left component
  component shift_left
  generic (N: integer :=32); 
  port(a : in std_logic_vector(N-1 downto 0);
       shamt: in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);
       c : out std_logic_vector(N-1 downto 0));
  end component;
  --shift right component
  component shift_right
  generic (N: integer :=32); 
  port(a : in std_logic_vector(N-1 downto 0);
       shamt: in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);
       c : out std_logic_vector(N-1 downto 0));
  end component;

  signal b2, sum, slt: STD_LOGIC_VECTOR((width-1) downto 0);
  signal const_zero : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '0');
  signal bgtzflag: std_logic;
  signal const_error : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '-');
  signal normZero: std_logic;
  signal normResult: STD_LOGIC_VECTOR((width-1) downto 0);
  signal shift_multiply: STD_LOGIC_VECTOR(31 downto 0); -- Signal needed to connect the left shifter
  signal shift_divide: STD_LOGIC_VECTOR(31 downto 0);   -- Signal needed to connect the right shifter

begin

  --shift left hardware
  shleft : shift_left generic map (N =>32) port map 
  ( a => b, shamt => shamt, c => shift_multiply );

  --shift right hardware
  shright : shift_right generic map (N => 32) port map
  ( a => b, shamt => shamt, c => shift_divide);

  -- hardware inverter for 2's complement 
  b2 <= not b when alucontrol(2) = '1' else b;
  
  -- hardware adder
  sum <= a + b2 + alucontrol(2);
  
  -- slt should be 1 if most significant bit of sum is 1
  --slt <= ( const_zero(width-1 downto 1) & '1') when sum((width-1)) = '1' else (others =>'0');
  slt <= "00000000000000000000000000000001" when ( to_integer(unsigned(a) > to_intger(unsigned(b))) ) else
    "00000000000000000000000000000000"; -- Hard code the slti
    
  -- determine alu operation from alucontrol bits 0, 1 and 2
  with alucontrol(2 downto 0) select result <=
    a and b when "000",
    a or b  when "001",
    sum     when "010",
    slt     when "011",
    a or b  when "101",         --when opcode is ORI, result is the or'd value of a and b
    shift_multiply when "100",  --when opcode is shift left, result should be multiplied value
    shift_divide when "111",    --when opcode is shift right, result should be divided value
    const_error when others; 

	
  -- set the zero flag if result is 0
  normZero <= '1' when result = const_zero else '0';


  --Zero flag for BGTZ should be set as 0...
  bgtzflag <= '1' when a > 0 else '0'; --if A is negative, bgtz should be set to 1
  zero <= bgtzflag when alucontrol(2 downto 0) = "111" else normZero;
end;
