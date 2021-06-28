----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2021 10:20:41
-- Design Name: 
-- Module Name: sha256d - Behavioral
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

entity sha256d is
    Generic (SIZE: integer);
    Port (
        clk: in std_logic;
        rst: in std_logic;
        ready: in std_logic;
        input: in std_logic_vector;
        output: out std_logic_vector(255 downto 0);
        new_data: out std_logic;
        done: out std_logic
        );
end sha256d;

architecture Behavioral of sha256d is
    type state is (waiting, first, waitingfirst, working, waitingwork, finished, reset);
    signal currentstate, nextstate: state;
    signal ready1, ready2, done1, done2: std_logic := '0';
    signal input1: std_logic_vector(input'length-1 downto 0);
    signal input2, output1, output2, output_out: std_logic_vector(255 downto 0);
begin
    
    sha1: entity work.sha256 generic map (SIZE=>SIZE) port map (clk=>clk, rst=>rst, start=>ready1, input=>input1, output=>output1, done=>done1);
    sha2: entity work.sha256 generic map (SIZE=>256) port map (clk=>clk, rst=>rst, start=>ready2, input=>input2, output=>output2, done=>done2);
    
    with currentstate select done <=
        '1' when finished,
        '0' when others;
        
    output <= output_out;

    process(clk, currentstate, input, ready, output1, output2) is
    begin
        ready1<='0'; ready2<='0';
        input1<=input; input2<=output1;
        output_out<=output2;
        case currentstate is
            when waiting =>
            when first =>
                ready1 <= '1';
            when waitingwork|waitingfirst=>
                ready1 <= '0';
                ready2 <= '0';
            when working =>
                if ready='1' then
                    ready1 <= '1';
                end if;
                
                ready2 <= '1';
            when finished =>
            when reset =>
        end case;
    end process;

    process(clk, rst) is
    begin
        if falling_edge(rst) then
            currentstate <= reset;
        end if;
        
        if rising_edge(clk) then
            currentstate <= nextstate;
        end if;
    end process;
    
    process(clk, currentstate, rst, ready, done1, done2) is
    begin
        case currentstate is
            when waiting =>
                if ready='1' then
                    nextstate <= first;
                else
                    nextstate <= waiting;
                end if;
            when first =>
                nextstate <= waitingfirst;
            when waitingfirst =>
                if done1='1' then
                    nextstate <= working;
                else
                    nextstate <= waitingfirst;
                end if;
            when working =>
                nextstate <= waitingwork;
            when waitingwork =>
                if done1='1' and done2='1' then
                    nextstate <= finished;
                else
                    nextstate <= waitingwork;
                end if;
            when finished =>
                nextstate <= working;
            when reset =>
                if rst='1' and ready='1' then
                    nextstate <= first;
                elsif rst='1' then
                    nextstate <= waiting;
                else
                    nextstate <= reset;
                end if;
        end case;
    end process;

end Behavioral;
