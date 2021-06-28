----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.05.2021 11:49:28
-- Design Name: 
-- Module Name: sha256_sim - Behavioral
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

entity sha256_sim is
--  Port ( );
end sha256_sim;

architecture Behavioral of sha256_sim is
    signal clk, rst, ready: std_logic := '1';
    signal input: std_logic_vector(23 downto 0) := x"616263";
    signal output: std_logic_vector(255 downto 0);
    signal done: std_logic;
begin

    clk <= not clk after 5ns;
    ready <= '0', '1' after 10ns;

    sha256d: entity work.sha256d generic map (SIZE=>24) port map (clk => clk, rst=>rst, ready=>ready,input=>input,output=>output, done=>done );
    
    process(done) is
    begin
        if rising_edge(done) then
            input <= not input;
        end if;
    end process;

end Behavioral;
