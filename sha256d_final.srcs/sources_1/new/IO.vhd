----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2021 12:32:10
-- Design Name: 
-- Module Name: IO - Behavioral
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

entity IO is
    Port (GCLK: in std_logic; input: in std_logic_vector(6 downto 0); outputLed: out std_logic_vector(7 downto 0) );
end IO;

architecture Behavioral of IO is
    signal rst, ready: std_logic := '1';
    signal output: std_logic_vector(255 downto 0);
    signal done: std_logic;
    signal inp: std_logic_vector(7 downto 0);
begin

    inp <= "0" & input;
    outputLed <= output(7 downto 0);

    sha256d: entity work.sha256d generic map (SIZE=>8) port map (clk => GCLK, rst=>rst, ready=>ready,input=>inp,output=>output, done=>done );
    
    

end Behavioral;
