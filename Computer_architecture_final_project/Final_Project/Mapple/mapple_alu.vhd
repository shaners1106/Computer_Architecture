----------------------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-17-21

-- The Mapple Em 1 ALU implements the CRC Varient Hashing algorithm
-- The core of this algorithm is a loop that runs the mathematical operations of the algorithm
-----------------------------------------------------------------------------------------------

-- THE FOLLOWING IS AN OUTLINE OF THE ALGORITHM THAT THE ALU PERFORMS

-- h is a variable to hold the loop's mathematical processes; 
--   the loop begins with h = 0 
-- ki holds the characters inputted from the keyboard.  
--   Each ki value is a byte of hash data

-- --LOOP BEGIN
-- highorder = h & 0xf8000000      // extract high-order 5 bits from h
--                                 // 0xf8000000 is the hexadecimal representation
--                                 //    for the 32-bit number with the first five 
--                                 //    bits = 1 and the other bits = 0   
-- h = h << 5                      // shift h left by 5 bits
-- h = h ^ (highorder >> 27)       // move the highorder 5 bits to the low-order
--                                 //    end and XOR into h
-- h = h ^ ki                      // XOR h and ki
-- --LOOP END

----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity mapple_alu is 
  generic(width: integer := 8);
  port( clk, reset:  in STD_LOGIC;
        ki : in  STD_LOGIC_VECTOR(7 downto 0);             -- next byte of input 
        alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
        h       : out STD_LOGIC_VECTOR(31 downto 0);       -- a variable to track our iterating hash value
        next_ki : inout STD_LOGIC_VECTOR(7 downto 0);        -- Address for next ki value (connected to Memory)
        ki_zero_flag, read_address_flag : out STD_LOGIC);  -- zero flag used as a loop counter
end;                                                       -- read address flag keeps track of whether or not the ALU loop is still running

architecture Behavioral of mapple_alu is
  component shift
    generic ( N : integer := 32 );
    port (a : in  STD_LOGIC_VECTOR(N-1 downto 0);                            -- address
      shamt : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);  -- shift amount
          c : out  STD_LOGIC_VECTOR(N-1 downto 0);                           -- hash value
          R : in STD_LOGIC );                                                -- Flag that sets shift direction (left or right)
  end component;

  -- Initialize the signals that we will need to wire up the ALU
  signal h_cache, highorder_cache, count : STD_LOGIC_VECTOR(31 downto 0);
  signal hash_memory : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
  signal highorder_shift, h_shift : STD_LOGIC_VECTOR(31 downto 0);
  signal const_zero : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal ki_32 : STD_LOGIC_VECTOR(31 downto 0);

  type statetype is (H0, H1, H2, H3, H4, H5, start, load_word, idle);  -- Signals that correspond to the various states within our FSM
  signal state: statetype;                         -- Signals to govern the flow of the FSM
  
begin
    
    
    -- Computes shift 
    highorder_shifter : shift generic map (  N => 32 ) port map( a => highorder_cache, shamt => "11011", c => highorder_shift, R => '1' );
    h_shifter : shift generic map (  N => 32 ) port map( a => h_cache, shamt => "00101", c => h_shift, R => '0' );

    -- STEPS for CRC Varient Hashing --
    -- 0. highorder = h & 0xf8000000  
    -- 1. highorder = highorder >> 27                      
    -- 2. h = h << 5                      
    -- 3. h = h ^ highorder                         
    -- 4. h = h ^ ki
    -----------------------------------       

    
    -- determine alu operation from alucontrol bits 0 and 1
    with alucontrol(2 downto 0) select state <=
      H0 when "000",
      H1 when "001",
      H2 when "010",
      H3 when "011",
      H4 when "100",
      H5 when "101", 
      start when "110", -- Resets algorithm
      load_word when "111", 
      idle     when others;
    -- Load the necessary signals into the sensitivity list
    process( clk, ki, ki_32 ) begin
        if rising_edge(clk) then
            
            read_address_flag <= '0'; -- Keep flag 0 unless needed.
            if reset = '1' then
                h_cache <= x"00000000";                      -- Zero h out
                next_ki <= "00000000";                       -- Zero next_ki out
                ki_32 <= x"00000000";
                read_address_flag <= '1';                    -- Set the flag indicating that it's time for the next hash byte
                ki_zero_flag <= '0';                         -- Set the flag indicating that we've finished the loop
            elsif ki = "00000000" then
                hash_memory <= h_cache;
                ki_zero_flag <= '1';  
            else
                case state is
                    when idle =>
                        -- Do nothing
                    when load_word => 
                        -- Do nothing because we are waiting for memory.
                    when H0 =>
                        --Hash Step 0
                        -- 0xf8000000 == 11111000000000000000000000000000 -- STEP 0
                        highorder_cache <= (h_cache and x"f8000000");  -- Create a little temporary memory to hold the bitwise AND operation
                    when H1 =>
                        --Hash Step 1
                        highorder_cache <= std_logic_vector(unsigned(highorder_shift));          -- shift high_order to the right 27
                    when H2 =>
                        --Hash Step 2
                        h_cache <= std_logic_vector(unsigned(h_shift));                          -- Shift h to the left 5
                    when H3 =>
                        --Hash step 3
                        h_cache <= (h_cache xor highorder_cache);      -- XOR h with high_order
                    when H4 =>
                        --Hash step 4
                        ki_32 <= x"000000" & ki;                     -- Zero extend ki
                        h_cache <= (h_cache xor ki_32);                -- XOR h with ki
                    when H5 =>
                        --Hash step 5
                        read_address_flag <= '1';                    -- Set the flag indicating that it's time for the next hash byte
                        next_ki <= std_logic_vector( unsigned(next_ki) + 1 );    -- Increment ki address
                    when start => 
                        -- Reset everything for aglorithm
                        h_cache <= x"00000000";                      -- Zero h out
                        next_ki <= "00000000";                       -- Zero next_ki out
                        ki_32 <= x"00000000";
                        read_address_flag <= '1';                    -- Set the flag indicating that it's time for the next hash byte
                        ki_zero_flag <= '0';                         -- Set the flag indicating that we've finished the loop
                end case;
            end if;

        end if;
    end process;

    -- Link output of h to h_cache for hash output
    h <= hash_memory;


end;