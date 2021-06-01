------------------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-6-21

-- Define the Moore FSM that runs the multicycle control unit of the Mapple microprocessor
------------------------------------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity patternMoore is
    port(clk, reset: in STD_LOGIC;
        a: in STD_LOGIC;
        y: out STD_LOGIC);
end;

architecture synth of patternMoore is
type statetype is (S0, S1, S2, S3, S4, S5, S6, S7);
signal state, nextstate: statetype;
begin
-- state register
process(clk, reset) begin
    if reset then 
        state <= S0;
    elsif rising_edge(clk) then 
        state <= nextstate;
    end if;
end process;
-- next state logic
process(all) begin
case state is
    when S0 =>
        --LW

    when S1 =>
        --Read or Start flag
        if a then 
            nextstate <= S2;
        else 
            nextstate <= S1;
        end if;
    when S2 =>
        --Hash Step 0
        
    when S3 =>
        --Hash step 1

    when S4 =>
        --Hash step 2

    when S5 =>
        --Hash step 3

    when S6 =>
        --Hash step 4
    when others =>
        --Hash step 5
        if a then 
            nextstate <= S0;
        else 
            nextstate <= S1;
        end if;
end case;
end process;

-- output logic
y <= '1' when state = S2 else '0';
end;