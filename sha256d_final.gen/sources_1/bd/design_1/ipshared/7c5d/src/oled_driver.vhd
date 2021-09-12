----------------------------------------------------------------------------------
-- Company: University of Trento
-- Designer: Roberto Passerone
-- 
-- Create Date: 10/19/2018 12:14:37 PM
-- Design Name: 
-- Module Name: oled_driver - Behavioral
-- Project Name: 
-- Target Devices: zynq 7000
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Include arithmetic functions
use IEEE.NUMERIC_STD.ALL;
use work.multi_sha256d_pkg.all;

entity oled_driver is
  port (
    -- System clock
    clock : in std_logic;
    -- Global reset (active low)
    reset : in std_logic;

    -- Turn off the OLED module. The poweroff command must be kept high for
    -- some time, since the state machine may be busy printing a line, which
    -- could take up to 327.68 us with the current spi controller
    poweroff : in std_logic;
    -- Data input. There are 8 4-bit inputs, for a total of 32 bits
    display_in : in array_unsigned_32(1 downto 0);
    hash_rate: in unsigned(31 downto 0);

    -- Outputs to the OLED module
    -- OLED SPI data out
    oled_sdin : out std_logic;
    -- OLED SPI clock
    oled_sclk : out std_logic;
    -- OLED data/command signal
    oled_dc : out std_logic;
    -- OLED reset signal
    oled_res : out std_logic;
    -- OLED Vbat enable
    oled_vbat : out std_logic;
    -- OLED Vdd enable
    oled_vdd : out std_logic
  );
end oled_driver;

architecture Behavioral of oled_driver is
    constant PAGES: natural := 4;

  component oled_counter is
    generic (
      -- Size in bits of the counter
      SIZE : integer := 4;
      -- Value at which the terminal count is asserted
      TERMINAL : integer := 15
    );
    port (
      -- System clock
      clock : in std_logic;
      -- Global reset (active low)
      reset : in std_logic;
      -- Count init
      counter_init : in std_logic;
      -- Count enable
      counter_enable : in std_logic;
      -- Terminal count
      counter_tc : out std_logic;
      -- Count value
      counter_val : out unsigned( SIZE - 1 downto 0 )
    );
  end component;

  component ascii_rom is
    port (
      -- Memory address
      addr : in std_logic_vector( 10 downto 0 );
      -- Data out
      dout : out std_logic_vector( 7 downto 0 )
    );
  end component;

  component spi_controller is
    port (
      -- System clock
      clock : in std_logic;
      -- Global reset (active low)
      reset : in std_logic;
      -- Start transmission
      start : in std_logic;
      -- Data to be transmitted, 8 bits
      data_in : in std_logic_vector( 7 downto 0 );
      -- Serial data out
      sdata : out std_logic;
      -- Serial clock out
      sclk : out std_logic;
      -- Latch flag
      latch : out std_logic;
      -- Done flag
      done : out std_logic
    );
  end component;

  component delay_module is
    port (
      -- System clock
      clock : in std_logic;
      -- Global reset (active low)
      reset : in std_logic;
      -- Start delay computation
      start : in std_logic;
      -- Delay amount
      delay_ms : in std_logic_vector( 7 downto 0 );
      -- Done flag
      done : out std_logic
    );
  end component;

  -- Internal signals
  signal spi_start : std_logic;
  signal spi_data_in : std_logic_vector( 7 downto 0 );
  signal spi_latch : std_logic;
  signal spi_done : std_logic;
  signal del_start : std_logic;
  signal del_delay_ms : std_logic_vector( 7 downto 0 );
  signal del_done : std_logic;

  -- Internal state
  signal poled_vbat, poled_vdd, noled_vbat, noled_vdd : std_logic;
  type state_t is ( idle, init0, init1, init2, init3, init4, init5, init6,
  init7, init8, init9, init10, init11, ready, screenon, screenoff, poweroff0,
  poweroff1, poweroff2, printline0, printline1, printline2, printline3, printline4,
  off_state );
  signal pstate, nstate : state_t;

  -- Internal signals with data to be printed. TODO: these will need to be
  -- turned into actual inputs to interface with the AXI bus
  -- The page on which to write (actually it is the line of the display)
  signal page_number : unsigned( 1 downto 0 );
  signal page_counter_init, page_counter_enable, page_counter_tc: std_logic;
  -- The code of the characters to be printed
  signal char_code : std_logic_vector( 7 downto 0 );
  -- Temporary to select the 4-bit group to display from the input. The
  -- additional bit is used to denote a white space
  signal display_select : std_logic_vector( 5 downto 0 );
  -- The column data to be printed
  signal col_bitmap : std_logic_vector( 7 downto 0 );
  -- Address in the ascii rom
  signal addr : std_logic_vector( 10 downto 0 );

  -- Counters
  -- Count the number of written characters. Counts from 0 to 15, TC at 15
  signal char_counter_val : unsigned( 3 downto 0 );
  signal char_counter_init, char_counter_enable, char_counter_tc : std_logic;
  -- Count the number of written columns. Counts from 0 to 7, TC at 7
  signal col_counter_val : unsigned( 2 downto 0 );
  signal col_counter_init, col_counter_enable, col_counter_tc : std_logic;

begin

  spi_control_inst : spi_controller port map (
    clock => clock,
    reset => reset,
    start => spi_start,
    data_in => spi_data_in,
    sdata => oled_sdin,
    sclk => oled_sclk,
    latch => spi_latch,
    done => spi_done
  );

  delay_module_inst : delay_module port map (
    clock => clock,
    reset => reset,
    start => del_start,
    delay_ms => del_delay_ms,
    done => del_done
  );
  
  page_counter: oled_counter generic map(
    SIZE => 2,
    TERMINAL => PAGES-1
    ) port map (
        clock=>clock,
        reset=>reset,
        counter_init => page_counter_init,
        counter_enable => page_counter_enable,
        counter_tc => page_counter_tc,
        counter_val => page_number
        );

  -- Counter that counts the number of characters that have been written out
  char_counter_inst : oled_counter generic map (
    SIZE => 4,
    TERMINAL => 15
  ) port map (
    clock => clock,
    reset => reset,
    counter_init => char_counter_init,
    counter_enable => char_counter_enable,
    counter_tc => char_counter_tc,
    counter_val => char_counter_val
  );
  -- Counter that counts the columns of the character
  col_counter_inst : oled_counter generic map (
    SIZE => 3,
    TERMINAL => 7
  ) port map (
    clock => clock,
    reset => reset,
    counter_init => col_counter_init,
    counter_enable => col_counter_enable,
    counter_tc => col_counter_tc,
    counter_val => col_counter_val
  );

  -- Ascii table
  --
  --    0 1 2 3 4 5 6 7 8 9 A B C D E F 
  --    --------------------------------
  -- 2_   ! " # $ % & ' ( ) * + , - . /
  -- 3_ 0 1 2 3 4 5 6 7 8 9 : ; < = > ?
  -- 4_ @ A B C D E F G H I J K L M N O
  -- 5_ P Q R S T U V W X Y Z [ \ ] ^ _
  -- 6_ ` a b c d e f g h i j k l m n o
  -- 7_ p q r s t u v w x y z { | } ~ DEL

  -- The ROM with the bitmap data. The address is given by the character code
  -- that we need to access, plus the counter that sweeps the columns of the
  -- character
  addr <= char_code( 7 downto 0 ) & std_logic_vector( col_counter_val );
  ascii_rom_inst : ascii_rom port map (
    addr => addr,
    dout => col_bitmap
  );

  -- Write on this line of the display
  --page_number <= "00";

  -- Select which character to display from the input, according to the
  -- character counter
  process ( char_counter_val, display_in, page_number ) is
  
    --set1
    -- n->"01 1010"
    -- o->"01 1011"
    -- c->"01 1100"
    -- e->"01 1110"
--    *space*->"10 0100"
--    :->"10 0101"
    
    --set2
--    h->"10 1111"
--    a->"10 1010"
--    s->"10 1101"
--    r->"10 1100"
--    t->"10 1011"
--    e->"10 1110"
--    k->"10 0101"
--    *space*->"10 0000"
--    :->"10 0001"
--    [->"10 0010"
--    ]->"10 0011"
--    /->"10 0100"
--    0->"10 0110"
--    x->"10 0111"
    variable page_index: integer;
    variable prefix_labels, prefix_values: std_logic_vector(1 downto 0);
    variable display: std_logic_vector(63 downto 0);
  begin
    page_index := to_integer(page_number);
    case page_index is
        when 0 =>
            display(63 downto 32) := x"abace154"; --"nonce1 :"
            display(31 downto 0) := std_logic_vector(display_in(page_index));
            prefix_labels := "01";
            prefix_values := "00";
        when 1 =>
            display(63 downto 32) := x"abace254"; --"nonce2 :"
            display(31 downto 0) := std_logic_vector(display_in(page_index));
            prefix_labels := "01";
            prefix_values := "00";
        when 2 =>
            display(63 downto 0) := x"fadf0cabe02f4d31"; --hash rate [h/s]:
            prefix_labels := "10";
            prefix_values := "10";
        when 3 =>
            display(63 downto 40) := (others=>'0');
            display(39 downto 32) := x"67"; --0x
            display(31 downto 0) := std_logic_vector(hash_rate);
            prefix_labels := "10";
            prefix_values := "00";
        when others =>
            display := (others=>'0');
            prefix_labels := "10";
            prefix_values := "10";
    end case;
  
  
    -- Select the character value
    case char_counter_val is
      when "1111" => display_select <=  prefix_values & std_logic_vector(display( 3 downto 0 ));
      when "1110" => display_select <=  prefix_values & std_logic_vector(display( 7 downto 4 ));
      when "1101" => display_select <=  prefix_values & std_logic_vector(display( 11 downto 8 ));
      when "1100" => display_select <=  prefix_values & std_logic_vector(display( 15 downto 12 ));
      when "1011" => display_select <=  prefix_values & std_logic_vector(display( 19 downto 16 ));
      when "1010" => display_select <=  prefix_values & std_logic_vector(display( 23 downto 20 ));
      when "1001" => display_select <=  prefix_values & std_logic_vector(display( 27 downto 24 ));
      when "1000" => display_select <=  prefix_values & std_logic_vector(display( 31 downto 28 ));
      when "0111" => display_select <=  prefix_labels & std_logic_vector(display( 35 downto 32));
      when "0110" => display_select <=  prefix_labels & std_logic_vector(display( 39 downto 36));
      when "0101" => display_select <=  prefix_labels & std_logic_vector(display( 43 downto 40));
      when "0100" => display_select <=  prefix_labels & std_logic_vector(display( 47 downto 44));
      when "0011" => display_select <=  prefix_labels & std_logic_vector(display( 51 downto 48));
      when "0010" => display_select <=  prefix_labels & std_logic_vector(display( 55 downto 52));
      when "0001" => display_select <=  prefix_labels & std_logic_vector(display( 59 downto 56));
      when "0000" => display_select <=  prefix_labels & std_logic_vector(display( 63 downto 60));
      when others => display_select <= "110000";
    end case;
  end process;
  -- Decode the selected display input to display a hex digit or a space
  process ( display_select ) begin
    -- By default, we display a space
    
    case display_select is
      -- decimal digits
      when "000000" => char_code <= x"30";
      when "000001" => char_code <= x"31";
      when "000010" => char_code <= x"32";
      when "000011" => char_code <= x"33";
      when "000100" => char_code <= x"34";
      when "000101" => char_code <= x"35";
      when "000110" => char_code <= x"36";
      when "000111" => char_code <= x"37";
      when "001000" => char_code <= x"38";
      when "001001" => char_code <= x"39";
      -- hex digits (upper case, use x61, x62... for lowercase)
      when "001010" => char_code <= x"41";
      when "001011" => char_code <= x"42";
      when "001100" => char_code <= x"43";
      when "001101" => char_code <= x"44";
      when "001110" => char_code <= x"45";
      when "001111" => char_code <= x"46";
      
      
    --set1
    -- n->"01 1010"
    -- o->"01 1011"
    -- c->"01 1100"
    -- e->"01 1110"
--    *space*->"10 0100"
--    :->"10 0101"
      when "010001" => char_code <= x"31";
      when "010010" => char_code <= x"32";
      when "010100" => char_code <= x"20";
      when "010101" => char_code <= x"3a";
      when "011010" => char_code <= x"4e";
      when "011011" => char_code <= x"4f";
      when "011100" => char_code <= x"43";
      when "011110" => char_code <= x"45";
      
      
      
    --set2
--    h->"10 1111"
--    a->"10 1010"
--    s->"10 1101"
--    r->"10 1100"
--    t->"10 1011"
--    e->"10 1110"
--    k->"10 0101"
--    *space*->"10 0000"
--    :->"10 0001"
--    [->"10 0010"
--    ]->"10 0011"
--    /->"10 0100"
      when "100000" => char_code <= x"20";
      when "100001" => char_code <= x"3a";
      when "100010" => char_code <= x"5b";
      when "100011" => char_code <= x"5d";
      when "100100" => char_code <= x"2f";
      when "100101" => char_code <= x"4b";
      when "100110" => char_code <= x"30";
      when "100111" => char_code <= x"78";
      -- hex digits (upper case, use x61, x62... for lowercase)
      when "101010" => char_code <= x"41";
      when "101011" => char_code <= x"54";
      when "101100" => char_code <= x"52";
      when "101101" => char_code <= x"53";
      when "101110" => char_code <= x"45";
      when "101111" => char_code <= x"48";
      
      -- display a space in all other cases
      when others  => char_code <= x"20";
    end case;
  end process;

  -- The state machine
  process ( clock, reset, poweroff ) begin
    if ( reset = '0' ) then
      -- These signals are active low
      poled_vbat <= '1';
      poled_vdd <= '1';
      pstate <= idle;
    elsif rising_edge( clock ) then
      pstate <= nstate;
      poled_vbat <= noled_vbat;
      poled_vdd <= noled_vdd;
    end if;
  end process;
  oled_vbat <= poled_vbat;
  oled_vdd <= poled_vdd;

  process ( pstate, poled_vbat, poled_vdd, del_done, spi_done,
  poweroff, page_number, page_counter_tc, col_bitmap,
  col_counter_tc, char_counter_tc ) begin
    -- Initial defaults
    nstate <= pstate;
    noled_vbat <= poled_vbat;
    noled_vdd <= poled_vdd;
    -- Set data mode by default
    oled_dc <= '1';
    -- Reset off by default (active low)
    oled_res <= '1';
    -- Timer control
    del_start <= '0';
    del_delay_ms <= "00000000";
    -- SPI control
    spi_data_in <= "00000000";
    spi_start <= '0';
    -- Counters control
    char_counter_init <= '0';
    char_counter_enable <= '0';
    col_counter_init <= '0';
    col_counter_enable <= '0';
    
    page_counter_init <= '0';
    page_counter_enable <= '0';

    -- Compute next state and output functions
    case pstate is

      when idle =>
        -- First thing, initialize the OLED module (I know, the idle state is
        -- useless, we could make init0 the initial state). After the
        -- initialization, the init11 state goes to screenon, which turns on
        -- the screen
        nstate <= init0;

      -- Ready state, component ready to receive a command
      when ready =>
        -- Set up the delay counter to wait for 100 ms, and check for
        -- completion. Each time it ends the count, we print the values
        -- that are at the input, so 100 ms is our refresh rate. Meanwhile,
        -- also check if there is a poweroff command.
        page_counter_init <= '1';
        
        del_start <= '1';
        del_delay_ms <= "01010000";
        -- Wait for the timer to complete or for the command
        if ( poweroff = '1' ) then
          nstate <= poweroff0;
        elsif ( del_done = '1' ) then
          nstate <= printline0;
        end if;

      -- Print a line of text. I must have the line number stored in a
      -- register, and the ASCII values of 16 characters in 16/4 = 4 registers
      when printline0 =>
        -- Initialize the character counter
        char_counter_init <= '1';
        -- Initialize the column counter
        col_counter_init <= '1';
        -- Set command mode
        oled_dc <= '0';
        -- Send the Set page command, 0xB0 - 0xB7, depending on the page 0-7
        spi_data_in <= "1011" & "00" & std_logic_vector(page_number);
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= printline1;
        end if;

      when printline1 =>
        -- Set data mode (this is actually the default, no need to do it)
        oled_dc <= '1';
        -- Send the value coming from the ASCII ROM
        spi_data_in <= col_bitmap;
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= printline2;
        end if;

      -- Check if we are done with the character
      -- (I know, I could merge states printline2 and printline3 in one, but
      -- this way I reduce the length of the combinatorial path to activate
      -- the char_counter_enable signal)
      when printline2 =>
        -- Enable count for next column
        col_counter_enable <= '1';
        -- Check if the column counter has finished
        if ( col_counter_tc = '1' ) then
          -- Finished current character
          nstate <= printline3;
        else
          -- Continue with next column
          nstate <= printline1;
        end if;

      -- Check if we are done with the whole string
      when printline3 =>
        -- Enable count for next character
        char_counter_enable <= '1';
        -- Check if the character counter has finished
        if ( char_counter_tc = '1' ) then
          -- Finished the string. Go back to ready
          nstate <= printline4;
        else
          -- Continue with next character
          nstate <= printline1;
        end if;
        
      when printline4 =>
        page_counter_enable <= '1';
        
        if ( page_counter_tc = '1') then
          nstate <= ready;
        else
          nstate <= printline0;
        end if;

      when screenon =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the entire display on command, 0xA5
        spi_data_in <= "10100101";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= ready;
        end if;

      when screenoff =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the disable entire display on command, 0xA4
        spi_data_in <= "10100100";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= ready;
        end if;

      when init0 =>
        -- Set command mode
        oled_dc <= '0';
        -- Turn Vdd on (active low)
        noled_vdd <= '0';
        -- Wait for 1 ms
        del_start <= '1';
        del_delay_ms <= "00000001";
        -- Wait for the timer to complete
        if ( del_done = '1' ) then
          nstate <= init1;
        end if;

      when init1 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the display off command, 0xAE
        spi_data_in <= "10101110";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= init2;
        end if;

      when init2 =>
        -- Set command mode
        oled_dc <= '0';
        -- Turn on reset signal (active low)
        oled_res <= '0';
        -- Wait for 1 ms
        del_start <= '1';
        del_delay_ms <= "00000001";
        -- Wait for the timer to complete
        if ( del_done = '1' ) then
          nstate <= init3;
        end if;

      when init3 =>
        -- Set command mode
        oled_dc <= '0';
        -- Turn off reset signal (active low)
        oled_res <= '1';
        -- Wait for 1 ms
        del_start <= '1';
        del_delay_ms <= "00000001";
        -- Wait for the timer to complete
        if ( del_done = '1' ) then
          nstate <= init4;
        end if;

      when init4 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the ChargePump command, 0x8D
        spi_data_in <= "10001101";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= init5;
        end if;

      when init5 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the ChargePump command, enable, 0x14
        spi_data_in <= "00010100";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= init6;
        end if;

      when init6 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the SetPrechargePeriod command, 0xD9
        spi_data_in <= "11011001";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= init7;
        end if;

      when init7 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the SetPrechargePeriod command, data, 0xF1
        spi_data_in <= "11110001";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= init8;
        end if;

      when init8 =>
        -- Set command mode
        oled_dc <= '0';
        -- Turn on Vbat (active low)
        noled_vbat <= '0';
        -- And wait for 100 ms (actually 80 runs)
        del_start <= '1';
        del_delay_ms <= "01010000";
        -- Wait for the timer to complete
        if ( del_done = '1' ) then
          nstate <= init9;
        end if;

      when init9 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the SetCOMPinHardwareConfig command, 0xDA
        spi_data_in <= "11011010";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= init10;
        end if;

      when init10 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the SetCOMPinHardwareConfig command, data, 0x00
        spi_data_in <= "00000000";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= init11;
        end if;

      when init11 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the DisplayOn command, 0xAF
        spi_data_in <= "10101111";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          -- Next, go to the ready state
          nstate <= ready;
        end if;

      when poweroff0 =>
        -- Set command mode
        oled_dc <= '0';
        -- Send the display off command, 0xAE
        spi_data_in <= "10101110";
        spi_start <= '1';
        if ( spi_done = '1' ) then
          nstate <= poweroff1;
        end if;

      when poweroff1 =>
        -- Set command mode
        oled_dc <= '0';
        -- Turn off Vbat (active low)
        noled_vbat <= '1';
        -- And wait for 100 ms (actually 80 runs)
        del_start <= '1';
        del_delay_ms <= "01010000";
        -- Wait for the timer to complete
        if ( del_done = '1' ) then
          nstate <= poweroff2;
        end if;

      when poweroff2 =>
        -- Set command mode
        oled_dc <= '0';
        -- Turn off Vdd (active low)
        noled_vdd <= '1';
        -- And wait for 100 ms (actually 80 runs)
        del_start <= '1';
        del_delay_ms <= "01010000";
        -- Wait for the timer to complete
        if ( del_done = '1' ) then
          nstate <= off_state;
        end if;

      when off_state =>
        -- Just remain here with the defaults

      when others =>
    end case;
  end process;



end Behavioral;
