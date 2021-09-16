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
        start: in std_logic;
        input: in std_logic_vector(SIZE-1 downto 0);
        output: out std_logic_vector(255 downto 0);
        ready: out std_logic;
        done: out std_logic
        );
end sha256d;

architecture Behavioral of sha256d is
    type state is (waiting, round1, waitinground1, round2, waitinground2, finished, reset);
    signal currentstate, nextstate: state;
    signal start1, start2, done1, done2: std_logic := '0';
    signal ready1, ready2: std_logic;
    signal input1_d, input1_q: std_logic_vector(input'length-1 downto 0);
    signal input2_d, input2_q, output1, output2: std_logic_vector(255 downto 0);
begin
    
    sha1: entity work.sha256 generic map (SIZE=>SIZE) port map (clk=>clk, rst=>rst, start=>start1, input=>input1_q, output=>output1, ready=>ready1, done=>done1);
    sha2: entity work.sha256 generic map (SIZE=>256) port map (clk=>clk, rst=>rst, start=>start2, input=>input2_q, output=>output2, ready=>ready2, done=>done2);
    
    --output <= output_q;
    --done <= '1' when currentstate=finished else '0';
        
    ready <= '1' when currentstate=waiting else '0';
    
    process(clk, currentstate, input1_q, input2_q, input, output1, output2) is
    begin
        input1_d <= input1_q;
        input2_d <= input2_q;
        done <= '0';
        output <= (others=>'1');
        start1<='0'; start2<='0';
        case currentstate is
            when round1 =>
                input1_d <= input;
                start1 <= '1';
            when round2 =>
                input2_d <= output1;
                start2 <= '1';
            when finished =>
                output <= output2;
                done <= '1';
            when others =>
        end case;
    end process;

    process(clk, rst) is
    begin
        if rst='0' then
            currentstate <= reset;
        elsif rising_edge(clk) then
            currentstate <= nextstate;
        end if;
    end process;
    
    process(clk, rst) is
    begin
        if rst='0' then
            input1_q <= (others=>'0');
            input2_q <= (others=>'0');
        elsif rising_edge(clk) then
            input1_q <= input1_d;
            input2_q <= input2_d;
        end if;
    end process;
    
    process(clk, currentstate, rst, start, done1, done2, ready1, ready2) is
    begin
        case currentstate is
            when waiting =>
                if start='1' and ready1='1' then
                    nextstate <= round1;
                else
                    nextstate <= waiting;
                end if;
            when round1 =>
                nextstate <= waitinground1;
            when waitinground1 =>
                if done1='1' and ready2='1' then
                    nextstate <= round2;
                else
                    nextstate <= waitinground1;
                end if;
            when round2 =>
                nextstate <= waitinground2;
            when waitinground2 =>
                if done2='1' then
                    nextstate <= finished;
                else
                    nextstate <= waitinground2;
                end if;
            when finished =>
                if start='1' and ready1='1' then
                    nextstate <= round1;
                else
                    nextstate <= waiting;
                end if;
            when reset =>
                if rst='1' and start='1' and ready1='1' then
                    nextstate <= round1;
                elsif rst='1' then
                    nextstate <= waiting;
                else
                    nextstate <= reset;
                end if;
        end case;
    end process;

end Behavioral;
