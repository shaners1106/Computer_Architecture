---------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-10-21

-- Test file for our main memory unit
---------------------------------------------------------------------------------

-- Adapted from https://www.fpga4student.com/2017/08/vhdl-code-for-single-port-ram.html
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
-- VHDL testbench code for the single-port RAM
ENTITY mapple_testbench IS
END mapple_testbench;
 
ARCHITECTURE behavior OF mapple_testbench IS 
 
    -- Component Declaration for the single-port RAM in VHDL
 
    -- COMPONENT mapple
    -- PORT(   clk, reset:        in  STD_LOGIC;
    --         instruction_address:inout STD_LOGIC_VECTOR(5 downto 0);
    --         instr:             in  STD_LOGIC_VECTOR(31 downto 0);
    --         memwrite:          out STD_LOGIC;
    --         hash_output:       out STD_LOGIC_VECTOR(31 downto 0));
    -- END COMPONENT;
    COMPONENT mapple_top
    PORT(   clk, reset:        in  STD_LOGIC;
            out_port_1, hash_output : out STD_LOGIC_VECTOR(31 downto 0));
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal instruction_address : std_logic_vector(5 downto 0) := (others => '0');
   signal instr : std_logic_vector(31 downto 0) := (others => '0');

   signal out_port_1 : std_logic_vector(31 downto 0) := (others => '0');

  --Outputs
  signal hash_output : std_logic_vector(31 downto 0) := (others => '0');


 
BEGIN


 -- Instantiate the single-port RAM in VHDL
--    uut: mapple PORT MAP (
--         clk => clk,
--         reset => reset,
--         instruction_address => instruction_address,
--         instr => instr,        
--         memwrite => memwrite,
--         hash_output => hash_output
--     );

    uut: mapple_top PORT MAP(
        clk => clk, reset => reset,
        out_port_1 => out_port_1, hash_output => hash_output
    );

    -- Generate clock with 10 ns period
    process begin
        clk <= '1';
        wait for 5 ns; 
        clk <= '0';
        wait for 5 ns;
    end process;

    -- Generate reset for first two clock cycles
    process begin
        reset <= '1';
        wait for 12 ns;
        reset <= '0';
        wait;
    end process;

    -- process (clk) begin
    --     if rising_edge(clk) then
    --         -- if read_instr = '0' then
    --         --     instr <= x"61000000";
    --         --     read_instr <= '1';
    --         -- else
    --         --     instr <= x"00000001";
    --         -- end if;
    --     end if;

    --     -- RAM_WR <= '0'; 
    --     -- RAM_ADDR <= "0000000";
    --     -- RAM_DATA_IN <= x"FF";
    --     -- wait for 100 ns; 
    --     -- -- start reading data from RAM 
    --     -- for i in 0 to 5 loop
    --     --     RAM_ADDR <= RAM_ADDR + "0000001";
    --     --     wait for clk_period*5;
    --     -- end loop;
    --     -- RAM_ADDR <= "0000000";
    --     -- RAM_WR <= '1';
    --     -- -- start writing to RAM
    --     -- wait for 100 ns;
    --     -- for i in 0 to 5 loop
    --     --     RAM_ADDR <= RAM_ADDR + "0000001";
    --     --     RAM_DATA_IN <= RAM_DATA_IN-x"01";
    --     --     wait for clk_period*5;
    --     -- end loop;  
    --     -- RAM_WR <= '0';
    -- end process;

END;