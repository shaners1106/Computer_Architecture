--------------------------------------------------------------------------------
--  Module Name:  sim_group_alu 
--      Purpose:  Example of a programmed test bench 
-- Project Name:  Test all inputs for the 4 bit alu (has two 4 bit input)
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH
 
ENTITY sim_group_alu IS
END sim_group_alu;
 
ARCHITECTURE behavioral OF sim_group_alu IS 
  -- These signals are use to wire the alu to the board level signals
  -- input signals
  -- TODO Define input signals
  -- output signals
  -- TODO Define output signals

  -- TODO define other signals your group may need
  
  signal a_sim, b_sim  : STD_LOGIC_VECTOR( 3 downto 0 );
  signal function_bits_sim : STD_LOGIC_VECTOR( 3 downto 0 );
  -- output signals
  signal y_sim : STD_LOGIC_VECTOR( 3 downto 0 );
  
  signal abf : STD_LOGIC_VECTOR( 11 downto 0 ) := "000000000000";

 

  ----------------------------------------------------------------------------------------
  -- Function to_string for testbench
  -- convert a STD Logic vector to a string so we can report it in the testbench console
  -- output.
  -- source: https://stackoverflow.com/questions/15406887/vhdl-convert-vector-to-string
  -----------------------------------------------------------------------------------------
  function to_string ( a: std_logic_vector) return string is
    variable b : string (1 to a'length) := (others => NUL);
    variable stri : integer := 1; 
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
        stri := stri+1;
        end loop;
    return b;
  end function;

BEGIN
    uut : entity work.alu generic map( N => 4 )
        port map( a => signed(a_sim), b => signed(b_sim), f => unsigned(function_bits_sim), signed(y) => y_sim );
 
  stim_proc: process
      variable i: INTEGER range 0 to 4095; 
      variable alu_test: std_logic_vector(4 downto 0);
   begin		
      for i in 0 to 4095 loop
        abf <= std_logic_vector(to_unsigned(i, 12));
        function_bits_sim <= abf(3 downto 0);
        b_sim <= abf(7 downto 4);
        a_sim <= abf(11 downto 8);
        
        wait for 10 ns;
        
        if function_bits_sim = "0000" then
            alu_test := "0" & (a_sim and b_sim);
            if alu_test /= y_sim then
                report "Failure. Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\nInputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
        end if;
        
        --check 'OR' function 001
          if function_bits_sim = "0001" then
            alu_test := "0" & (a_sim or b_sim);
            if alu_test /= y_sim then
                report "Failure. Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\nInputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
           end if;
          
         --check '+' function 010
          if function_bits_sim = "0010" then
            alu_test := ("0" & a_sim) + ("0" & b_sim);
            if alu_test(3 downto 0) /= y_sim then
               report "Failure at + . Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\n Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
          end if;          
        end loop;
      
        --check 'A AND Not B' 100
          if function_bits_sim = "0100" then
            alu_test := "0"&(a_sim and (not b_sim));
            if alu_test(3 downto 0) /= y_sim then
               report "Failure at A AND Not B . Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\n Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
          end if;
          
          -- check 'A OR Not B' 0101
          if function_bits_sim = "0101" then
            alu_test := "0"&(a_sim or (not b_sim));
            if alu_test(3 downto 0) /= y_sim then
               report "Failure at A OR Not B . Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\n Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
          end if;
          
          --check 'A - B' 110
          if function_bits_sim = "0110" then
            alu_test := "0"&(a_sim - b_sim);
            if alu_test(3 downto 0) /= y_sim then
               report "Failure at - . Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\n Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
          end if;
          
          --check 'A < B' 1000
          if function_bits_sim = "1000" then
            if a_sim < b_sim then
                alu_test := (4 downto 1 => '0') & '1';
            else
                alu_test := (4 downto 0 => '0');
            end if;
            if alu_test(3 downto 0) /= y_sim then
               report "Failure at < . Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\n Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
          end if;
          
--          --check 'A >= B' 1000
--          if function_bits_sim = "1001" then
--            if a_sim < b_sim then
--                alu_test := (4 downto 1 => '0') & '1';
--            else
--                alu_test := (4 downto 0 => '0');
--            end if;
--            if alu_test(3 downto 0) /= y_sim then
--               report "Failure at - . Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\n Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
--                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
--            end if;
--          end if;

            --check 'A = B' 1000
          if function_bits_sim = "1000" then
            if a_sim = b_sim then
                alu_test := (4 downto 1 => '0') & '1';
            else
                alu_test := (4 downto 0 => '0');
            end if;
            if alu_test(3 downto 0) /= y_sim then
               report "Failure at = . Value expected:" & to_string(alu_test) & ", value got:" & to_string(y_sim) & "\n Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
                --report "Inputs at failure: a: " & to_string(a_sim) & " b: " & to_string(b_sim);
            end if;
          end if;
          
          
          


      --end loop;
   end process;
END behavioral;