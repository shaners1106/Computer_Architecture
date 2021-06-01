----------------------------------------------------------
-- mips computer wired to hexadecimal display and reset 
-- button
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity computer_top is -- top-level design for testing
  port( 
       CLK100MHZ : in STD_LOGIC;
       seg : out STD_LOGIC_VECTOR(6 downto 0);
       an : out STD_LOGIC_VECTOR(3 downto 0);
       dp : out STD_LOGIC;
       LED : out  STD_LOGIC_VECTOR(3 downto 0);
       reset : in STD_LOGIC
	   );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture computer_top of computer_top is

  component display_hex
    port (
        CLKM : in STD_LOGIC;
        x : in STD_LOGIC_VECTOR(15 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0);
        dp : out STD_LOGIC;
        LED : out  STD_LOGIC_VECTOR(3 downto 0);
        clk_div: out STD_LOGIC_VECTOR(28 downto 0)	
    );
  end component;

  component mips_top  -- top-level design for testing
    port( 
         clk : in STD_LOGIC;
         reset: in STD_LOGIC;
         out_port_1 : out STD_LOGIC_VECTOR(15 downto 0)
         );
  end component;
  
  -- this is a slowed signal clock provided to the mips_top
  -- set it from a lower bit on clk_div for a faster clock
  signal clk : STD_LOGIC := '0';
  
  -- clk_div is a 29 bit counter provided by the display hex 
  -- use bits from this to provide a slowed clock
  signal clk_div : STD_LOGIC_VECTOR(28 downto 0);

  -- this data bus will hold a value for display by the 
  -- hex display  
  signal display_bus: STD_LOGIC_VECTOR(15 downto 0); 
         
  
  begin
      -- wire up slow clock 
      clk <= clk_div(20); -- use a lower bit for a faster clock
      -- clk <= clk_div(0);  -- use this in simulation (fast clk)
           
	  -- wire up the processor and memories
	  mips1: mips_top port map( clk => clk, reset => reset, out_port_1 => display_bus );
	                                       
	  display: display_hex port map( CLKM  => CLK100MHZ,  x => display_bus, 
	           seg => seg,  an => an,  dp => dp,  LED => LED, clk_div => clk_div );                                      
	  
  end computer_top;
