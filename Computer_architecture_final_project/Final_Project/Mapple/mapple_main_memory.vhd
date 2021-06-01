------------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-6-21

-- Our main memory file
------------------------------------------------------------------------------------

-- Adapted from https://www.fpga4student.com/2017/08/vhdl-code-for-single-port-ram.html
-- Converted 128x8 ram into 256x8 ram.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- A 256x8 single-port RAM in VHDL
entity Mapple_RAM is
generic(width: integer);
port(
 RAM_ADDR_READ: in std_logic_vector(width-1 downto 0); -- Address to read RAM
 RAM_DATA_IN: in std_logic_vector(width-1 downto 0);   -- Data to write into RAM
 RAM_WR: in std_logic;                                 -- Write enable 
 RAM_CLOCK: in std_logic;                              -- clock input for RAM
 RAM_RESET: in std_logic;                              -- Memory reset
 RAM_DATA_OUT: out std_logic_vector(width-1 downto 0)  -- Data output of RAM
);
end Mapple_RAM;

architecture Behavioral of Mapple_RAM is
-- define the new type for the 256x8 RAM 
type RAM_ARRAY is array (0 to 255) of std_logic_vector (7 downto 0);
-- initial values in the RAM
signal RAM: RAM_ARRAY :=(
   x"00",x"00",x"00",x"00",-- 0x00: Seed the control unit with a value of a
   x"00",x"00",x"00",x"00",-- 0x04: 
   x"00",x"00",x"00",x"00",-- 0x08: 
   x"00",x"00",x"00",x"00",-- 0x0C: 
   x"00",x"00",x"00",x"00",-- 0x10: 
   x"00",x"00",x"00",x"00",-- 0x14: 
   x"00",x"00",x"00",x"00",-- 0x18: 
   x"00",x"00",x"00",x"00",-- 0x1C: 
   x"00",x"00",x"00",x"00",-- 0x20: 
   x"00",x"00",x"00",x"00",-- 0x24: 
   x"00",x"00",x"00",x"00",-- 0x28: 
   x"00",x"00",x"00",x"00",-- 0x2C: 
   x"00",x"00",x"00",x"00",-- 0x30: 
   x"00",x"00",x"00",x"00",-- 0x34: 
   x"00",x"00",x"00",x"00",-- 0x38: 
   x"00",x"00",x"00",x"00",-- 0x3C: 
   x"00",x"00",x"00",x"00",-- 0x40: 
   x"00",x"00",x"00",x"00",-- 0x44: 
   x"00",x"00",x"00",x"00",-- 0x48: 
   x"00",x"00",x"00",x"00",-- 0x4C: 
   x"00",x"00",x"00",x"00",-- 0x50: 
   x"00",x"00",x"00",x"00",-- 0x54: 
   x"00",x"00",x"00",x"00",-- 0x58: 
   x"00",x"00",x"00",x"00",-- 0x5C: 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00"
   ); 

signal RAM_ADDR : STD_LOGIC_VECTOR(7 downto 0) := x"00";
signal NEXT_RAM_ADDR : STD_LOGIC_VECTOR(7 downto 0) := x"00";
signal prevent_duplicate : STD_LOGIC := '0';

begin
process(RAM_CLOCK, RAM_RESET, RAM_WR, RAM_DATA_IN)
begin
   if RAM_RESET = '1' then
      RAM_ADDR <= x"00";
      prevent_duplicate <= '0';
      -- for I in 0 to 255 loop
      --    RAM(I) <= x"FF";
      -- end loop;

      RAM <= (
         x"00",x"00",x"00",x"00",-- 0x00: Seed the control unit with a value of a
         x"00",x"00",x"00",x"00",-- 0x04: 
         x"00",x"00",x"00",x"00",-- 0x08: 
         x"00",x"00",x"00",x"00",-- 0x0C: 
         x"00",x"00",x"00",x"00",-- 0x10: 
         x"00",x"00",x"00",x"00",-- 0x14: 
         x"00",x"00",x"00",x"00",-- 0x18: 
         x"00",x"00",x"00",x"00",-- 0x1C: 
         x"00",x"00",x"00",x"00",-- 0x20: 
         x"00",x"00",x"00",x"00",-- 0x24: 
         x"00",x"00",x"00",x"00",-- 0x28: 
         x"00",x"00",x"00",x"00",-- 0x2C: 
         x"00",x"00",x"00",x"00",-- 0x30: 
         x"00",x"00",x"00",x"00",-- 0x34: 
         x"00",x"00",x"00",x"00",-- 0x38: 
         x"00",x"00",x"00",x"00",-- 0x3C: 
         x"00",x"00",x"00",x"00",-- 0x40: 
         x"00",x"00",x"00",x"00",-- 0x44: 
         x"00",x"00",x"00",x"00",-- 0x48: 
         x"00",x"00",x"00",x"00",-- 0x4C: 
         x"00",x"00",x"00",x"00",-- 0x50: 
         x"00",x"00",x"00",x"00",-- 0x54: 
         x"00",x"00",x"00",x"00",-- 0x58: 
         x"00",x"00",x"00",x"00",-- 0x5C: 
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00", 
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00",
         x"00",x"00",x"00",x"00"
         ); 


   end if;
 if(rising_edge(RAM_CLOCK)) then
   if (RAM_WR='1') and (prevent_duplicate = '0') and (RAM_DATA_IN /= x"00") then  -- when write enable = 1, write input data into RAM at the provided address
      prevent_duplicate <= '1';

      RAM_ADDR <= NEXT_RAM_ADDR;

      RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN;
      
      if RAM_ADDR < x"FF" then
         NEXT_RAM_ADDR <= std_logic_vector( unsigned(RAM_ADDR) + 1 );
      else
         NEXT_RAM_ADDR <= x"00";
      end if;  
      
   elsif (RAM_WR='0') then
      prevent_duplicate <= '0';
   else
    -- The index of the RAM array type needs to be integer so
    -- converts RAM_ADDR from std_logic_vector -> Unsigned -> Integer using numeric_std library
   end if;
 end if;
end process;
 -- Data to be read out 
 RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR_READ)));

end Behavioral; 