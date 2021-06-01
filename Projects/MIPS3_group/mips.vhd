------------------------------------------------------------
-- mips.vhd
-- David_Harris@hmc.edu and Sarah_Harris@hmc.edu 30 May 2006
-- Single Cycle MIPS processor
------------------------------------------------------------



-- Levi Russell, Tyler Gamlem, Joseph McCann and Shane Snediker
-- CS 401 MIPS3 Single-Cycle Processor Group Project
-- Last Updated: 3-15-21



------------------------------------------------------------
-- Entity Declarations
------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity mips is
 -- single cycle MIPS processor
  generic(width: integer);
  port(clk, reset:        in  STD_LOGIC;
       pc:                inout STD_LOGIC_VECTOR((width-1) downto 0);
       instr:             in  STD_LOGIC_VECTOR((width-1) downto 0);
       memwrite:          out STD_LOGIC;
       aluout, writedata: inout STD_LOGIC_VECTOR((width-1) downto 0);
       readdata:          in  STD_LOGIC_VECTOR((width-1) downto 0));
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture struct of mips is
  component controller
    port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
         zero:               in  STD_LOGIC;
         memtoreg, memwrite: out STD_LOGIC;
         pcsrc, alusrc:      out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         extrabits:          out STD_LOGIC_VECTOR(1 downto 0);  -- Send the 2 extra bits out of the control unit
         alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  
  component datapath generic(width : integer );
  port(clk, reset:        in  STD_LOGIC;
       memtoreg, pcsrc:   in  STD_LOGIC;
       alusrc, regdst:    in  STD_LOGIC;
       regwrite, jump:    in  STD_LOGIC;
       extrabits:         in  STD_LOGIC_VECTOR(1 downto 0); -- Give the 2 extra bits to the data path
       alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
       zero:              out STD_LOGIC;
       pc:                inout STD_LOGIC_VECTOR((width-1) downto 0);
       instr:             in  STD_LOGIC_VECTOR((width-1) downto 0);
       aluout, writedata: inout STD_LOGIC_VECTOR((width-1) downto 0);
       readdata:          in  STD_LOGIC_VECTOR((width-1) downto 0));
  end component;
  
  -- Signals to wire the datapath unit to the controller unit
  signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc: STD_LOGIC;
  signal zero: STD_LOGIC;
  signal alucontrol: STD_LOGIC_VECTOR(2 downto 0);
  signal extrabits: STD_LOGIC_VECTOR(1 downto 0); -- Establish a wire to connect our extra bits from the controller to the data path
  
begin
  cont: controller port map( op => instr((width-1) downto 26), funct => instr(5 downto 0),
                            zero => zero, memtoreg => memtoreg, memwrite => memwrite, 
                            pcsrc => pcsrc, alusrc => alusrc,
                            extrabits => extrabits,
				            regdst => regdst, regwrite => regwrite, 
				            jump => jump, alucontrol => alucontrol);
				            
  dp: datapath generic map(width) port map(clk => clk, reset => reset, 
                                           memtoreg => memtoreg, pcsrc => pcsrc, 
                                           alusrc => alusrc, regdst => regdst,
                                           regwrite => regwrite,  jump => jump, 
                                           alucontrol => alucontrol, zero => zero,
                                           extrabits => extrabits, 
                                           pc => pc, instr => instr,
								           aluout => aluout, writedata => writedata, 
								           readdata => readdata);
end;