----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2018 02:43:27 PM
-- Design Name: 
-- Module Name: test_driver - Behavioral
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

entity test_driver is
--  Port ( );
end test_driver;

architecture Behavioral of test_driver is
  
  component hex_display is
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
end component;

  signal clock : std_logic;
  signal reset : std_logic;
  signal poweroff : std_logic;
  signal oled_sdin : std_logic;
  signal oled_sclk : std_logic;
  signal oled_dc : std_logic;
  signal oled_res : std_logic;
  signal oled_vbat : std_logic;
  signal oled_vdd : std_logic;

begin

  -- Instantiate the driver
  hex_display_inst : entity work.hex_display(Behavioral) port map (
    clock => clock,
    reset => reset,
    poweroff => poweroff,
    oled_sdin => oled_sdin,
    oled_sclk => oled_sclk,
    oled_dc => oled_dc,
    oled_res => oled_res,
    oled_vbat => oled_vbat,
    oled_vdd => oled_vdd
  );

  -- Clock process
  process begin
    clock <= '1';
    wait for 5 ns;
    clock <= '0';
    wait for 5 ns;
  end process;
  -- Reset process
  process begin
    reset <= '0';
    wait for 100 ns;
    reset <= '1';
    wait;
  end process;

  -- Signal process
  process begin
    poweroff <= '0';
    wait for 400 ms;
    poweroff <= '1';
    wait for 500 us;
    poweroff <= '0';
    wait;
  end process;

end Behavioral;
