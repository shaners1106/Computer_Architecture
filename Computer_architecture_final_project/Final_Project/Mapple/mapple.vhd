---------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-17-21

-- Inspiration taken from mips.vhd
-- David_Harris@hmc.edu and Sarah_Harris@hmc.edu 30 May 2006
-- Single Cycle MIPS processor
------------------------------------------------------------

-- Entity Declarations

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;

entity mapple is
  generic(width: integer);
  port(clk, reset, new_ascii_flag: in  STD_LOGIC;
       data_in:               in STD_LOGIC_VECTOR(7 downto 0);
       start_flag:         in STD_LOGIC;
       hash_output:       out STD_LOGIC_VECTOR(31 downto 0));
end;

-- Architecture Definitions

architecture struct of mapple is
  component mapple_decoder
    port(
        clk, reset, start_hash:           in STD_LOGIC;
        ki_zero_flag:         in STD_LOGIC;                       -- FSM loop counter
        aluop:                out STD_LOGIC_VECTOR(2 downto 0));  -- Send the ALU the necessary signal  
  end component;
  
  component datapath 
    generic(width : integer );
        port(clk, reset, start_hash:     in  STD_LOGIC;                   -- start_hash flag tells the ALU that the loop has begun 
        data:                         in STD_LOGIC_VECTOR(7 downto 0);    -- holds the value entered from the keyboard
        write_data:                   in STD_LOGIC;                       -- tells MEM where to access data
        hash:                         out STD_LOGIC_VECTOR(31 downto 0);  -- The output of our process (the result of the CRC Varient Hashing algorithm)
        aluop:                        in STD_LOGIC_VECTOR(2 downto 0);
        ki_zero_flag:                 out STD_LOGIC);   -- Processor output
  end component;
  
  -- Signals to wire the datapath unit to the controller unit
  signal hash: STD_LOGIC_VECTOR(31 downto 0);
  signal alucontrol: STD_LOGIC_VECTOR(2 downto 0);
  
  -- Signals for data transmission
  -- instr decoding:
  -- x"00000000" => x"00" + x"00" + x"00" + x"00";
  --                  ^       ^       ^       ^
  --                  |       |       |       |
  --                 data                    last_byte 1 => start hashing
  signal data_signal : STD_LOGIC_VECTOR(7 downto 0) := x"00";
  signal start_hash_signal : STD_LOGIC := '0';
  signal write_data_signal : STD_LOGIC := '0';
  signal ki_zero_flag_signal : STD_LOGIC := '0';

begin
  hash_output <= hash;
  data_signal <= data_in;
  start_hash_signal <= start_flag;
  process(clk, reset) begin
    if reset = '1' then

    end if;
    if rising_edge(clk) then
      --instruction_address_signal <= std_logic_vector( unsigned(instruction_address) + 1 );
      
      --if (data_signal /= prev_data) and data_signal /= x"00" then
      if new_ascii_flag = '0' and (data_signal /= x"00") then
        write_data_signal <= '1';
      else
        write_data_signal <= '0';
      end if;
    end if;
  end process;
--  cont: controller port map( op => instr((width-1) downto 26), funct => instr(5 downto 0),
--                            zero => zero, memtoreg => memtoreg, memwrite => memwrite, 
--                            pcsrc => pcsrc, alusrc => alusrc,
--				            regdst => regdst, regwrite => regwrite, 
--				            jump => jump, alucontrol => alucontrol);
				            
--  dp: datapath generic map(width) port map(clk => clk, reset => reset, 
--                                           memtoreg => memtoreg, pcsrc => pcsrc, 
--                                           alusrc => alusrc, regdst => regdst,
--                                           regwrite => regwrite,  jump => jump, 
--                                           alucontrol => alucontrol, zero => zero, 
--                                           pc => pc, instr => instr,
--								           aluout => aluout, writedata => writedata, 
--								           readdata => readdata);


    mappledec: mapple_decoder port map(clk => clk, reset => reset, 
    ki_zero_flag => ki_zero_flag_signal, start_hash => start_hash_signal, aluop => alucontrol);

   mappledatapath: datapath generic map(8) port map(
       clk => clk, reset => reset, start_hash => start_hash_signal, 
       data => data_signal, write_data => write_data_signal, 
       hash => hash, aluop => alucontrol, ki_zero_flag => ki_zero_flag_signal
   );
    
end;
