----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2021 11:40:12
-- Design Name: 
-- Module Name: multibit_register - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.sha256_pkg.WordsArray;

entity wordsarray_reg is
    generic (n : natural := 4);
    port (d : in WordsArray(n-1 downto 0);
        clk, res, l : in std_logic;
        q : out WordsArray(n-1 downto 0));

end entity WordsArray_reg;

architecture behavioral of WordsArray_reg is
begin
    process (clk, res) is
    begin
        if res = '0' then
            q <= (others => (others=>'0'));
        elsif rising_edge(clk) then
            if l='1' then
                q <= d;
            end if;
        end if;
    end process;

end architecture behavioral;
