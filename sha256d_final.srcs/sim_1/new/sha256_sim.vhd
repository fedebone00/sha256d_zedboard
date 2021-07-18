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
    signal clk, rst, start: std_logic := '1';
    signal input: std_logic_vector(447 downto 0) := x"6162636462636465636465666465666765666768666768696768696a68696a6b696a6b6c6a6b6c6d6b6c6d6e6c6d6e6f6d6e6f706e6f7071";
    signal output: std_logic_vector(255 downto 0);
    signal done, ready: std_logic;
begin

    rst <= '0', '1' after 5 ns;
    clk <= not clk after 5ns;

    sha256d: entity work.sha256d generic map (SIZE=>448) port map (clk => clk, rst=>rst, start=>start,input=>input,output=>output, ready=>ready, done=>done );
    
    process(clk, ready, done) is
    begin
        if rising_edge(clk) then
            input <= input;
            start <= '0';
            if ready='1' then
                --input <= not input;
                start <= '1';
            end if;
        end if;
    end process;
    
end Behavioral;
