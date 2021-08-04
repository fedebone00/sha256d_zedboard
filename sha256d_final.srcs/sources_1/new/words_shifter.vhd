----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.07.2021 11:48:11
-- Design Name: 
-- Module Name: words_shifter - Behavioral
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
use work.sha256_pkg.WordsArray;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity words_shifter is
  Port (clk, rst: in std_logic;
        T: in WordsArray(1 downto 0);
        se: in std_logic; --shift enable
        words_in: in WordsArray(7 downto 0);
        words_out: out WordsArray(7 downto 0)
        );
end words_shifter;

architecture Behavioral of words_shifter is
    signal words: WordsArray(7 downto 0);
begin
    words_out <= words;
    process(clk, rst, se) is
    begin
        words <= words_in;
        if rst='0' then
            words <= (others=>(others=>'0'));
        elsif rising_edge(clk) then
            if se='1' then
                words(7) <= words(6);
                words(6) <= words(5);
                words(5) <= words(4);
                words(4) <= std_logic_vector(unsigned(words(3))+unsigned(T(0)));
                words(3) <= words(2);
                words(2) <= words(1);
                words(1) <= words(0);
                words(0) <= std_logic_vector(unsigned(T(0))+unsigned(T(1)));
            end if;
        end if;
    end process;

end Behavioral;
