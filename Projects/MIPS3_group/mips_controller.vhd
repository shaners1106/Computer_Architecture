library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;


-- Levi Russell, Tyler Gamlem, Joseph McCann and Shane Snediker
-- CS 401 MIPS3 Single-Cycle Processor Group Project
-- Last Updated: 3-15-21



entity controller is -- single cycle control decoder
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
       zero:               in  STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       pcsrc, alusrc:      out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       alucontrol:         out STD_LOGIC_VECTOR(2 downto 0);
       extrabits:          out  STD_LOGIC_VECTOR(1 downto 0));  -- We've added 2 bits to our control unit to be able to account for the 3 instructions we're adding
end;

architecture struct of controller is
  component maindec
    port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         branch, alusrc:     out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         aluop:              out  STD_LOGIC_VECTOR(1 downto 0);
         extrabits:          out  STD_LOGIC_VECTOR(1 downto 0));  -- The extra bits will be the last 2 bits of the control
  end component;
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));

  end component;
  signal aluop: STD_LOGIC_VECTOR(1 downto 0);
  signal branch: STD_LOGIC;
begin
  md: maindec port map( op => op, memtoreg => memtoreg, memwrite => memwrite, branch => branch,
                       alusrc => alusrc, regdst => regdst, regwrite => regwrite, jump => jump, aluop => aluop,
                       extrabits => extrabits);
  ad: aludec port map(funct => funct, aluop => aluop, alucontrol => alucontrol);

  pcsrc <= branch and zero;
end;


