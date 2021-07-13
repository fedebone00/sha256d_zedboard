----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2021 11:04:39
-- Design Name: 
-- Module Name: sha256 - Behavioral
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

use work.sha256_pkg.all;

entity sha256 is
    Generic ( SIZE: integer := 512 );
    Port (
        clk: in std_logic;
        rst: in std_logic;
        start: in std_logic;
        input: in std_logic_vector(SIZE-1 downto 0);
        output: out std_logic_vector(255 downto 0);
        ready: out std_logic;
        done: out std_logic
        );
end sha256;

architecture Behavioral of sha256 is       
    type state is (waiting, pre,
     hashLoop0a, hashLoop0b, 
     hashLoop1a, hashLoop1b, hashLoop2, finish, reset);
    signal currentstate, nextstate: state;
    
    signal blocks_count: integer;
    signal message_block: std_logic_vector(511 downto 0);
    signal hv: WordsArray(7 downto 0);
    signal words: WordsArray(7 downto 0);
    signal W: WordsArray(63 downto 0);
    signal T1, T2: unsigned(31 downto 0);
    
    signal message: std_logic_vector(((((SIZE+65) / 512) + 1)*512)-1 downto 0);
    
    signal message_block_counter_int_val: integer;
    signal message_block_counter_val: unsigned(6 downto 0);
    signal message_block_counter_init, message_block_counter_enable, message_block_counter_tc: std_logic;
    
    signal w_counter_int_val: integer;
    signal w_counter_val: unsigned(6 downto 0);
    signal w_counter_init, w_counter_enable, w_counter_tc: std_logic;
    
    signal hash_round_counter_int_val: integer;
    signal hash_round_counter_val: unsigned(6 downto 0);
    signal hash_round_counter_init, hash_round_counter_enable, hash_round_counter_tc: std_logic;
        
begin
    output <= hv(0) & hv(1) & hv(2) & hv(3) & hv(4) & hv(5) & hv(6) & hv(7);
    
    done <= '1' when (currentstate=hashLoop2 and message_block_counter_tc='1') or currentstate=finish else '0';
        
    ready <= '1' when (currentstate=hashLoop2 and message_block_counter_tc='1') or currentstate=waiting else '0';

    blocks_count <= ((SIZE+65) / 512) + 1;
    
    message <= input & '1' & std_logic_vector(to_unsigned(SIZE, message'length-SIZE-1));
    
    message_block_counter_int_val <= to_integer(message_block_counter_val);
    message_block_counter_init <= '1' when currentstate=pre else '0';
    message_block_counter_enable <= '1' when currentstate=hashLoop2 else '0';
    message_block_counter: entity work.counter generic map (SIZE=>7, TERMINAL=>(SIZE+65) / 512)
        port map (  clock=>clk, reset=>rst,
                    counter_init=>message_block_counter_init,
                    counter_enable=>message_block_counter_enable,
                    counter_tc=>message_block_counter_tc,
                    counter_val=>message_block_counter_val);
                    
    w_counter_int_val <= to_integer(w_counter_val);
    w_counter_init <= '1' when currentstate=hashLoop0a else '0';
    w_counter_enable <= '1' when currentstate=hashLoop0b else '0';
    w_counter: entity work.counter generic map (SIZE=>7, TERMINAL=>63)
        port map (  clock=>clk, reset=>rst,
                    counter_init=>w_counter_init,
                    counter_enable=>w_counter_enable,
                    counter_tc=>w_counter_tc,
                    counter_val=>w_counter_val);
                    
                                    
    hash_round_counter_int_val <= to_integer(hash_round_counter_val);
    hash_round_counter_init <= '1' when currentstate=hashLoop0b else '0';
    hash_round_counter_enable <= '1' when currentstate=hashLoop1b else '0';
    hash_round_counter: entity work.counter generic map (SIZE=>7, TERMINAL=>63)
        port map (  clock=>clk, reset=>rst,
                    counter_init=>hash_round_counter_init,
                    counter_enable=>hash_round_counter_enable,
                    counter_tc=>hash_round_counter_tc,
                    counter_val=>hash_round_counter_val);    
    
    process(clk, message_block, hv) is
    begin
        message_block <= message_block;
        hv <= hv;
        words <= words;
        W <= W;
        T1 <= T1;
        T2 <= T2;
        
        if rising_edge(clk) then
            case currentstate is
                when pre =>
                    hv <= init_hv;
                    message_block <= message((blocks_count*512)-1 downto (blocks_count-1)*512);
                when hashLoop0a =>
                    words <= hv;
                when hashLoop0b =>
                    if w_counter_int_val < 16 then
                        W(w_counter_int_val) <= message_block((16-w_counter_int_val)*32-1 downto (15-w_counter_int_val)*32);
                    else
                        W(w_counter_int_val) <= std_logic_vector(unsigned(small_s1(W(w_counter_int_val-2))) + unsigned(W(w_counter_int_val-7)) + unsigned(small_s0(W(w_counter_int_val-15))) + unsigned(W(w_counter_int_val-16)));
                    end if;
                when hashLoop1a =>
                    --for i in 0 to 3 loop
                        T1 <= unsigned(words(7))+unsigned(BIG_S1(words(4)))+unsigned(Ch(words(4), words(5), words(6)))+unsigned(K(hash_round_counter_int_val))+unsigned(W(hash_round_counter_int_val));
                        T2 <= unsigned(BIG_S0(words(0)))+unsigned(Maj(words(0), words(1), words(2)));
                when hashLoop1b =>
                        words(7) <= words(6);
                        words(6) <= words(5);
                        words(5) <= words(4);
                        words(4) <= std_logic_vector(unsigned(words(3))+T1);
                        words(3) <= words(2);
                        words(2) <= words(1);
                        words(1) <= words(0);
                        words(0) <= std_logic_vector(T1+T2);
                    --end loop;
                when hashLoop2 =>
                    for i in HV'range loop
                        hv(i) <= std_logic_vector(unsigned(words(i)) + unsigned(HV(i)));
                    end loop;
                    message_block <= message((message_block_counter_int_val+1)*512-1 downto message_block_counter_int_val*512);
                when finish =>
                when others =>
            end case;
        end if;
                
    end process;

    process(clk, rst) is
    begin
        if rst='0' then
            currentstate <= reset;
        elsif rising_edge(clk) then
            currentstate <= nextstate;
        end if;
    end process;
    
    process(clk, currentstate, rst, start, w_counter_tc, hash_round_counter_tc, message_block_counter_tc) is
    begin
        case currentstate is
            when waiting =>
                if start='1' then
                    nextstate <= pre;
                else
                    nextstate <= waiting;
                end if;
            when pre => nextstate <= hashLoop0a;
            when hashLoop0a => nextstate <= hashLoop0b;
            when hashLoop0b =>
                if w_counter_tc='1' then
                    nextstate <= hashLoop1a;
                else
                    nextstate <= hashLoop0b;
                end if;
            when hashLoop1a => nextstate <= hashLoop1b;
            when hashLoop1b => 
                if hash_round_counter_tc='1' then
                    nextstate <= hashLoop2;
                else
                    nextstate <= hashLoop1a;
                end if;
            when hashLoop2 =>
                if message_block_counter_tc='1' then
                    nextstate <= finish;
                else
                    nextstate <= hashLoop0a;
                end if;
            when finish => 
                if start='1' then
                    nextstate <= pre;
                else
                    nextstate <= waiting;
                end if;
            when reset =>
                if rst='0' then nextstate <= reset;
                else nextstate <= pre;
                end if;
        end case;
    end process;
    
end Behavioral;
