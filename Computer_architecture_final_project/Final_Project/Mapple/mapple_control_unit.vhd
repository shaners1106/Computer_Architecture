---------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-17-21


-- Define the main control unit of the microprocessor here
-----------------------------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;
-- main control decoder for the Mapple Em 1 ALU
entity mapple_decoder is 
  port(
    clk, reset, start_hash:           in STD_LOGIC;           -- start_hash dictates the beginning of the hashing algorithm
    ki_zero_flag:         in STD_LOGIC;                       -- FSM final state condition(if ki is zero then algo is finished)
    aluop:                out STD_LOGIC_VECTOR(2 downto 0));  -- Send the ALU the necessary signal
end;

-- Define the architecture of our main control decoding unit
architecture behave of mapple_decoder is
  type statetype is (H0, H1, H2, H3, H4, H5, start, Read_or_start, load_word);  -- Signals that correspond to the various states within our FSM
  signal state: statetype := Read_or_start;                          -- Signal to govern the flow of the FSM
  signal aluop_wire: STD_LOGIC_VECTOR(2 downto 0);  -- Connect the control unit to the ALU
  signal load_word_delay: STD_LOGIC_VECTOR(1 downto 0) := "00";  -- Provide a delay that helps mediate the flow of the ALU
begin

-- next state logic

process(clk, reset) begin
  -- Provide the control unit reset functionality
  if reset = '1' then 
    aluop_wire <= "111";
    state <= Read_or_start;
  -- Edge-driven FSM begins here
  elsif rising_edge(clk) then 
    -- Begin set of case statements that will control the flow of the FSM
    case state is
        -- Load a keyboard press into the ALU
        when load_word => 
            aluop_wire <= "111"; -- Alu idle
            if load_word_delay = "01" then
                load_word_delay <= "00";
                state <= H0;
            else
                load_word_delay <= std_logic_vector( unsigned(load_word_delay) + 1 );
            end if;
        -- Step 0 of the hashing algorithm : tell the ALU to extract high order bits from h
        when H0 =>
            aluop_wire <= "000";
            state <= H1;
        -- Step 1 of the hashing algorithm : tell the ALU to shift h left 5 bits
        when H1 =>
            aluop_wire <= "001";
            state <= H2;
        -- Step 2 of the hashing algorithm : tell the ALU to move the high_order 5 bits to lower_order
        when H2 =>
            aluop_wire <= "010";
            state <= H3;
        -- Step 3 of the hashing algorithm : tell the ALU to xor high_order and h
        when H3 =>
            aluop_wire <= "011";
            state <= H4;
        -- Step 4 of the hashing algorithm : tell the ALU to xor h and ki
        when H4 =>
            aluop_wire <= "100";
            state <= H5;
        -- Step 5 of the hashing algorithm : tell the ALU whether or not we're at the end of the input string
        when H5 =>
            aluop_wire <= "101";
            if ki_zero_flag = '1' then
              state <= Read_or_start;
            else
              load_word_delay <= "00";
              state <= load_word;
            end if;
        -- Reset the hashing algorithm
        when start => 
            aluop_wire <= "110";
            load_word_delay <= "00";
            state <= load_word;
        -- Ready to read a word or start the algorithm?
        when Read_or_start =>
            aluop_wire <= "XXX";

            -- Only have this if you want hash to infinitely cycle
            --state <= start;

            if start_hash = '1' then
              state <= start;
            else
              state <= Read_or_start;
            end if;
    end case;
  end if;
    -- Connect the hashed result as an alu op code that will be fed back into the ALU
    aluop <= aluop_wire;
end process;
end;