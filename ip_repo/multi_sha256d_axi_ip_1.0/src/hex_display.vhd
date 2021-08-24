----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2019 06:42:34 PM
-- Design Name: 
-- Module Name: hex_display - Behavioral
-- Project Name: 
-- Target Devices: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hex_display is
  port (
    -- System clock
  clock : in std_logic;
  -- Global reset (active low)
  reset : in std_logic;

  -- Turn off the OLED module. The poweroff command must be kept high for
  -- some time, since the state machine may be busy printing a line, which
  -- could take up to 327.68 us with the current spi controller
  poweroff : in std_logic;

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
end hex_display;

architecture Behavioral of hex_display is
component oled_driver is
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
    display_in : in std_logic_vector( 31 downto 0 );

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
end component;
signal data : std_logic_vector( 31 downto 0 );
begin

  data <= x"0123abcd";
  
  -- Instantiate the driver
  DRIVER : oled_driver port map(
    clock => clock,
    reset => reset,
    poweroff => poweroff,
    display_in => data,
    oled_sdin => oled_sdin,
    oled_sclk => oled_sclk,
    oled_dc => oled_dc,
    oled_res => oled_res,
    oled_vbat => oled_vbat,
    oled_vdd => oled_vdd
  );

end Behavioral;
