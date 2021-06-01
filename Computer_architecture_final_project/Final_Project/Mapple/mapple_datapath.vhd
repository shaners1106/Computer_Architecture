---------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-17-21

-- Here we define our primary data flow path
---------------------------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

-- Mapple datapath
entity datapath is  
  generic(width: integer := 8);
  port(clk, reset, start_hash:     in  STD_LOGIC;                      -- start_hash flag tells the ALU that the loop has begun 
     data:                         in STD_LOGIC_VECTOR(7 downto 0);    -- holds the value entered from the keyboard
     write_data:                   in STD_LOGIC;                       -- tells MEM where to access data
     hash:                         out STD_LOGIC_VECTOR(31 downto 0);  -- The output of our process (the result of the CRC Varient Hashing algorithm)
     aluop:                        in STD_LOGIC_VECTOR(2 downto 0);    -- Receive control signal from the ALU
     ki_zero_flag:                 out STD_LOGIC                       -- Tell the control unit when the ALU algorithm is finished
     );   
end;

architecture struct of datapath is

  -- The datapath needs an ALU component
  component mapple_alu 
     generic(width: integer);
     port(     clk, reset:  in STD_LOGIC;
               ki : in  STD_LOGIC_VECTOR(7 downto 0);             -- next byte of input 
               alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);      -- interface with the control unit 
               --address: in STD_LOGIC_VECTOR(7 downto 0);          -- where's the data coming from?
               h       : out STD_LOGIC_VECTOR(31 downto 0);       -- a variable to track our iterating hash value
               next_ki : inout STD_LOGIC_VECTOR(7 downto 0);        -- Address for next ki value (connected to Memory)
               ki_zero_flag, read_address_flag : out STD_LOGIC);  -- zero flag used as a loop counter
  end component;                                                  -- read_address flag keeps track of whether or not the ALU loop is still running

  -- The datapath needs a register file component
  component Mapple_RAM 
     generic(width: integer);
     port(     RAM_ADDR_READ: in std_logic_vector(width-1 downto 0); -- Address to write/read RAM
               RAM_DATA_IN: in std_logic_vector(width-1 downto 0);   -- Data to write into RAM
               RAM_WR: in std_logic;                                 -- Write enable 
               RAM_CLOCK: in std_logic;                              -- clock input for RAM
               RAM_RESET: in std_logic;                              -- Memory reset
               RAM_DATA_OUT: out std_logic_vector(width-1 downto 0)  -- Data output of RAM
          );
  end component;
 
  -- The datapath needs a mux2 component for routing data
  component mux2 
     generic(width: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  
  -- The signals to wire the datapath components together
     signal h: STD_LOGIC_VECTOR(31 downto 0);
     signal next_ki: STD_LOGIC_VECTOR(7 downto 0);
     signal mem_data_out : STD_LOGIC_VECTOR(7 downto 0);
     signal ki_zero_flag_signal, read_address_flag : STD_LOGIC;

  begin
    -- Wire up all the components for the datapath unit
     ki_zero_flag <= ki_zero_flag_signal;
	-- memmux:        mux2 generic map(8) port map(d0 => read_address, d1 => next_ki, s => read_address_flag, y => mem_address);
	outputmux:     mux2 generic map(32) port map(d0 => x"00000000", d1 => h, s => ki_zero_flag_signal, y => hash);
     -- Connect memory signals
     main_memory: Mapple_RAM generic map(8) port map(
          RAM_ADDR_READ => next_ki,
          RAM_RESET => reset,
          RAM_DATA_IN => data,
          RAM_WR => write_data,
          RAM_CLOCK => clk,
          RAM_DATA_OUT => mem_data_out
     );
     -- Connect ALU components
     main_alu: mapple_alu generic map(width) port map(
          clk => clk,
          reset => reset,
          ki => mem_data_out,
          alucontrol => aluop,
          h => h,
          next_ki => next_ki,
          ki_zero_flag => ki_zero_flag_signal,
          read_address_flag => read_address_flag
     );

end;