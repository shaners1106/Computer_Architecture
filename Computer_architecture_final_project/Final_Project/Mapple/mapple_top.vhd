---------------------------------------------------------------------------------
-- Madi Binyon, Levi Russell, Stephen Haugland, Rudy Keopuhiwa and Shane Snediker
-- CS 401 Computer Architecture
-- FP 4
-- Last updated: 5-18-21

-- The top file is where we connect our microprocessor to the Basys3 board

-- mipssingletop.vhd
-- David_Harris@hmc.edu 30 May 2006
-- Single Cycle MIPS testbench & mem
-- Single Cycle MIPS testbench & mem
-- Modified and updated to standard libraries by Kent Jones
----------------------------------------------------------------------

-- Entity Declarations

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
USE ieee.numeric_std.ALL;


entity mapple_top is -- top-level design for testing
  port( 
        CLK100MHZ : in STD_LOGIC;
        --hash_output : out STD_LOGIC_VECTOR(31 downto 0);
      
        -- Copy and pasted from kent's I/O
        -- external input/output signals for the ps2 keyboard
         PS2Clk    : in  std_logic; -- keyboard clock
         PS2Data   : in  std_logic; -- keyboard data

        --     -- vga inputs and outputs
        Hsync, Vsync : out std_logic; -- Horizontal and Vertical Synch
        vgaRed       : out std_logic_vector(3 downto 0); -- Red bits
        vgaGreen     : out std_logic_vector(3 downto 0); -- Green bits
        vgaBlue      : out std_logic_vector(3 downto 0); -- Blue bits   

    --     -- switches and LEDs     
        sw   : in std_logic_vector (15 downto 0); -- 16 switch inputs
        btnC : in std_logic; -- center button for reset
        btnU : in std_logic;
        btnL : in std_logic;
        btnR : in std_logic;
        btnD : in std_logic;
        LED  : out std_logic_vector (15 downto 0); -- 16 leds above switches
        an   : out std_logic_vector (3 downto 0); -- Controls four 7-seg displays
        seg  : out std_logic_vector(6 downto 0); -- 6 leds per display
        dp   : out std_logic -- 1 decimal point per display
      );
end;

-- Architecture Definitions

architecture mapple_top of mapple_top is
  component imem 
    generic(width: integer);
    port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
         rd: out STD_LOGIC_VECTOR((width-1) downto 0));
  end component;
  
  component ps2_keyboard_to_ascii 
    generic(width: integer);
    port(
      clk        : IN  STD_LOGIC;                     --system clock input
      ps2_clk    : IN  STD_LOGIC;                     --clock signal from PS2 keyboard
      ps2_data   : IN  STD_LOGIC;                     --data signal from PS2 keyboard
      ascii_new  : OUT STD_LOGIC;                     --output flag indicating new ASCII value
      ascii_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)); --ASCII value
  end component;
  
  component mapple 
    generic(width: integer);
    port(clk, reset, new_ascii_flag, start_flag:               in  STD_LOGIC;
      data_in:                 in STD_LOGIC_VECTOR(7 downto 0);
      hash_output:          out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  -- signals to wire the instruction memory, data memory and mips processor together
  signal instr: STD_LOGIC_VECTOR(31 downto 0);
  signal writedata, dataadr: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
  signal instruction_address: STD_LOGIC_VECTOR(5 downto 0); 
  
  --   -- COPY AND PASTED FROM KENT'S I/O CODE
  --   -- this is a slowed signal clock provided to the mips_top
  --   -- set it from a lower bit on clk_div for a faster clock
    signal slow_clk : std_logic := '0';
    
  --   -- clk_div is a 29 bit counter provided by the display hex 
  --   -- use bits from this to provide a slowed clock
    signal clk_div  : std_logic_vector(28 downto 0);

  --   -- this data bus will hold a value from the keyboard
  --   -- for display by the hex display  and VGA display
    signal kybrd_ascii_out   : std_logic_vector(6 downto 0);  
    signal ps2_code_new  : std_logic;
    signal kybrd_buffer      : std_logic_vector(15 downto 0);

    signal hash_output_signal : std_logic_vector(31 downto 0);
    signal hash_output_signal_cache: std_logic_vector(31 downto 0);
    signal hex_output         : std_logic_vector(15 downto 0) := x"0000";

    -- scan position x,y from the font gen unit
    signal pixel_x, pixel_y  : std_logic_vector(9 downto 0);

    -- reset signal for the vga driver
    signal reset                : std_logic;
    signal start                : std_logic;
    signal temp_signal          : std_logic;
    signal manual_data_read     : std_logic;
    signal read_data            : std_logic := '0';
    signal data_out   : std_logic_vector(7 downto 0);
    signal mapplt_ascii_data_in : std_logic_vector(7 downto 0);
    
    signal video_on, pixel_tick : std_logic;
    signal rgb_reg, rgb_text    : std_logic_vector(2 downto 0);


    signal vga_channel          : std_logic_vector(6 downto 0);
  
    signal font_get_hash_flag: std_logic;
    signal output_hash_vga : std_logic := '0';
    signal vga_channel_switch, hash_output_new : std_logic;
    signal output_hash_vga_count: std_logic_vector(2 downto 0) := "000";
    signal output_hash_vga_write: std_logic := '1';

    signal switch0, switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8, switch9, switch10, switch11, switch12, switch13, switch14, switch15: std_logic;

    type ASCII_ARRAY is array (0 to 15) of std_logic_vector (6 downto 0);
    -- initial values in the RAM
    -- Build an ASCII memory table
    signal ascii_table: ASCII_ARRAY :=(
      "0110000", -- 0
      "0110001", -- 1
      "0110010", -- 2
      "0110011", -- 3
      "0110100", -- 4
      "0110101", -- 5
      "0110110", -- 6
      "0110111", -- 7
      "0111000", -- 8
      "0111001", -- 9
      "1000001", -- A
      "1000010", -- B
      "1000011", -- C
      "1000100", -- D
      "1000101", -- E
      "1000110" -- F
    );

    type VGA_ARRAY is array (0 to 7) of std_logic_vector (6 downto 0);
    -- initial values in the RAM
    -- Build a VGA memory table
    signal vga_table: VGA_ARRAY :=(
      "0000000", -- 0
      "0000000", -- 1
      "0000000", -- 2
      "0000000", -- 3
      "0000000", -- 4
      "0000000", -- 5
      "0000000", -- 6
      "0000000" -- 7
    );

  begin     
      
	  -- -- wire up the processor and memories

	  -- mips1: mips generic map(32) port map(clk => clk, reset => reset, pc => pc, 
	  --                                      instr => instr, memwrite => memwrite, aluout => dataadr, 
	  --                                      writedata => writedata, readdata => readdata);
    mappleem1: mapple generic map(32) port map( clk => CLK100MHZ, reset => reset, new_ascii_flag => read_data,
                                                data_in => mapplt_ascii_data_in, start_flag => start, hash_output => hash_output_signal);

    -- wire up the keyboardcontroller
    keybrd : ps2_keyboard_to_ascii generic map(32) port map(
        clk   => CLK100MHZ,   --50 mhz clock to keyboard
        ps2_clk  => PS2Clk,   --clock signal from PS2 keyboard
        ps2_data  => PS2Data, --data signal from PS2 keyboard
        ascii_new => ps2_code_new,  --flag that new PS/2 code is available on ps2_code bus
        ascii_code => kybrd_ascii_out -- ascii code received from PS/2
    );

      -- -- Copy and pasted form kent's I/O
      -- -- wire up rest
      reset <= btnC;
      start <= btnU;
      vga_channel_switch <= btnL;
      temp_signal <= btnR;
      manual_data_read <= btnD;
      mapplt_ascii_data_in <= ('0' & kybrd_ascii_out);

      switch0 <= sw(0);
      switch1 <= sw(1);
      switch2 <= sw(2);
      switch3 <= sw(3);
      switch4 <= sw(4);
      switch5 <= sw(5);
      switch6 <= sw(6);
      switch7 <= sw(7);
      switch8 <= sw(8);
      switch9 <= sw(9);
      switch10 <= sw(10);
      switch11 <= sw(11);
      switch12 <= sw(12);
      switch13 <= sw(13);
      switch14 <= sw(14);
      switch15 <= sw(15);



       -- wire up slow clock for the HEX display
      slow_clk <= clk_div(27); 

                     
      --  -- Drive x input of hex display from keyboard signal
      -- display: entity work.display_hex port map( CLKM  => CLK100MHZ,  x => ("000000000000000" & read_data), 
      -- seg => seg,  an => an,  dp => dp, clk_div => clk_div );  
       display: entity work.display_hex port map( CLKM  => CLK100MHZ,  x => hex_output, 
                        seg => seg,  an => an,  dp => dp, clk_div => clk_div );                                      

      --  -- instantiate VGA sync circuit
       vga_sync_unit : entity work.vga_sync
       port map(
           clk => CLK100MHZ, reset => reset, hsync => Hsync,
           vsync => Vsync, video_on => video_on,
           pixel_x => pixel_x, pixel_y => pixel_y,
           p_tick => pixel_tick
       );

      --  -- instantiate font ROM control character to look up 
      --  -- from the keyboard bus which is driven from keyboard
       font_gen_unit : entity work.font_gen
           port map(
               clk => CLK100MHZ, video_on => video_on,
               ps2_code_new => hash_output_new,
               --char_num => kybrd_buffer(6 downto 0),
               char_num => vga_channel,
               pixel_x => pixel_x, pixel_y => pixel_y,
               rgb_text => rgb_text
           );

      --  -- rgb buffer
       process (ps2_code_new, kybrd_ascii_out, CLK100MHZ)
        variable ps2_code_new_last : std_logic := '0';
        variable key_buf : std_logic_vector (15 downto 0) := (others => '0');
       begin
           if rising_edge(CLK100MHZ) then

            if ( ps2_code_new_last = '0' and ps2_code_new = '1' ) then
              -- shift old ascii code to the left bring in new on right
              key_buf := key_buf(7 downto 0) & '0' & kybrd_ascii_out;
            end if;
            ps2_code_new_last := ps2_code_new;
            read_data <= ps2_code_new_last;

            if (vga_channel_switch = '1') then
              hex_output <= hash_output_signal_cache(31 downto 16);
            else
              hex_output <= hash_output_signal_cache(15 downto 0);
            end if;


            
               if (pixel_tick = '1') then
                   rgb_reg <= rgb_text;
               end if;


              vga_table(7) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(31 downto 28))));
              vga_table(6) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(28 downto 24))));
              vga_table(5) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(24 downto 20))));
              vga_table(4) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(20 downto 16))));
              vga_table(3) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(16 downto 12))));
              vga_table(2) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(12 downto 8))));
              vga_table(1) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(8 downto 4))));
              vga_table(0) <= ascii_table(to_integer(unsigned(hash_output_signal_cache(4 downto 0))));

              
              
              
              
              -- Switch 15 saves hash output because we had issues with hash resetting
              -- once the keyboard sent another signal.
              if switch15 = '1' then
                hash_output_signal_cache <= hash_output_signal;
              end if;
              -- Switch between switch outputtting hash and keyboard to vga
              if switch14 = '1' then 
                vga_channel <= vga_table(to_integer(unsigned(output_hash_vga_count)));
                --hash_output_new <= manual_data_read;
                hash_output_new <= font_get_hash_flag;
              else
                vga_channel <= kybrd_buffer(6 downto 0);
                hash_output_new <= ps2_code_new;
              end if;

              -- Switches used to output final hash
              if switch7 = '1' then
                output_hash_vga_count <= "111";
                font_get_hash_flag <= '0';
              elsif switch6 = '1' then
                output_hash_vga_count <= "110";
                font_get_hash_flag <= '0';
              elsif switch5 = '1' then
                output_hash_vga_count <= "101";
                font_get_hash_flag <= '0';
              elsif switch4 = '1' then
                output_hash_vga_count <= "100";
                font_get_hash_flag <= '0';
              elsif switch3 = '1' then
                output_hash_vga_count <= "011";
                font_get_hash_flag <= '0';
              elsif switch2 = '1' then
                output_hash_vga_count <= "010";
                font_get_hash_flag <= '0';
              elsif switch1 = '1' then
                output_hash_vga_count <= "001";
                font_get_hash_flag <= '0';
              elsif switch0 = '1' then
                output_hash_vga_count <= "000";
                font_get_hash_flag <= '0';
              else
                font_get_hash_flag <= '1';
              end if;


           end if;
          -- drive keyboard buffer signal and LED signal
          kybrd_buffer <= key_buf;
          LED <= key_buf;
       end process;

      --  -- build the RGB colors from the rgb_reg
       vgaRed <= rgb_reg(2) & rgb_reg(2) & rgb_reg(2) & rgb_reg(2);
       vgaGreen <= rgb_reg(1) & rgb_reg(1) & rgb_reg(1) & rgb_reg(1);
       vgaBlue <= rgb_reg(0) & rgb_reg(0) & rgb_reg(0) & rgb_reg(0);

end mapple_top;


