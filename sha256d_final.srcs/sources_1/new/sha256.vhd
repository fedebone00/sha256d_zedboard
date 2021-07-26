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
    type state is (waiting, preprocess, words_ass, hash_calc_step, hv_calc, finished, reset);
    signal currentstate, nextstate: state;
    constant blocks_count: integer := (SIZE+65)/512 + 1;
    
    signal message: std_logic_vector((blocks_count*512)-1 downto 0);
    signal message_blocks: MessageBlockArray;
    
    signal W: WordsArray(63 downto 0);
    signal HV: WordsArray(7 downto 0);
    -- a,b,c,d,e,f,g,h
    signal words: WordsArray(7 downto 0);
    signal T1, T2: unsigned(31 downto 0);
    
    signal message_block_counter_int_val: integer;
    signal message_block_counter_val: unsigned(6 downto 0);
    signal message_block_counter_init, message_block_counter_enable, message_block_counter_tc: std_logic;
    
    signal hash_step_counter_int_val: integer;
    signal hash_step_counter_val: unsigned(6 downto 0);
    signal hash_step_counter_init, hash_step_counter_enable, hash_step_counter_tc: std_logic;
begin
    output <= hv(0) & hv(1) & hv(2) & hv(3) & hv(4) & hv(5) & hv(6) & hv(7);
    done <= '1' when (currentstate=hv_calc and message_block_counter_tc='1') or currentstate=finished else '0';
    ready <= '1' when (currentstate=hv_calc and message_block_counter_tc='1') or currentstate=waiting else '0';
    
    message <= input & '1' & std_logic_vector(to_unsigned(SIZE, message'length-SIZE-1));

    message_blocks_generator:
    for i in 0 to blocks_count-1 generate
        message_blocks(i) <= message((blocks_count-i)*512-1 downto (blocks_count-i-1)*512);
    end generate message_blocks_generator;
    
    w_generator:
    for i in 0 to 63 generate
        FIRST_15: if i<16 generate
            W(i) <= message_blocks(message_block_counter_int_val)((16-i)*32-1 downto (15-i)*32) when message_block_counter_int_val>-1 else (others=>'U');
        end generate FIRST_15;
        
        NEXT_16: if i>=16 generate
            W(i) <= std_logic_vector(unsigned(small_s1(W(i-2))) + unsigned(W(i-7)) + unsigned(small_s0(W(i-15))) + unsigned(W(i-16))) when message_block_counter_int_val>-1 else (others=>'U');
        end generate NEXT_16;
    end generate w_generator;
    
    T1 <= unsigned(words(7))+unsigned(BIG_S1(words(4)))+unsigned(Ch(words(4), words(5), words(6)))+unsigned(K(hash_step_counter_int_val))+unsigned(W(hash_step_counter_int_val)) when hash_step_counter_int_val>-1 and hash_step_counter_int_val<64 else (others=>'U');
    T2 <= unsigned(BIG_S0(words(0)))+unsigned(Maj(words(0), words(1), words(2)));

    message_block_counter_int_val <= to_integer(message_block_counter_val);
    message_block_counter_init <= '1' when currentstate=preprocess else '0';
    message_block_counter_enable <= '1' when currentstate=hv_calc else '0';
    message_block_counter: entity work.counter generic map (SIZE=>7, TERMINAL=>blocks_count-1)
        port map (  clock=>clk, reset=>rst,
                    counter_init=>message_block_counter_init,
                    counter_enable=>message_block_counter_enable,
                    counter_tc=>message_block_counter_tc,
                    counter_val=>message_block_counter_val);                    
                                    
    hash_step_counter_int_val <= to_integer(hash_step_counter_val);
    hash_step_counter_init <= '1' when currentstate=preprocess or currentstate=hv_calc else '0';
    hash_step_counter_enable <= '1' when currentstate=hash_calc_step else '0';
    hash_step_counter: entity work.counter generic map (SIZE=>7, TERMINAL=>63)
        port map (  clock=>clk, reset=>rst,
                    counter_init=>hash_step_counter_init,
                    counter_enable=>hash_step_counter_enable,
                    counter_tc=>hash_step_counter_tc,
                    counter_val=>hash_step_counter_val);
    
    process(clk, currentstate, T1, T2) is
    begin
        if rising_edge(clk) then
            case currentstate is
                when preprocess =>
                    hv <= init_hv;
                when words_ass =>
                    words <= hv;
                when hash_calc_step =>
                    words(7) <= words(6);
                    words(6) <= words(5);
                    words(5) <= words(4);
                    words(4) <= std_logic_vector(unsigned(words(3))+T1);
                    words(3) <= words(2);
                    words(2) <= words(1);
                    words(1) <= words(0);
                    words(0) <= std_logic_vector(T1+T2);
                when hv_calc =>
                    for i in 0 to 7 loop
                        hv(i) <= std_logic_vector(unsigned(words(i)) + unsigned(HV(i)));
                    end loop;
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
    
    process(clk, rst, start, currentstate, hash_step_counter_tc, message_block_counter_tc) is
    begin
        case currentstate is
            when waiting =>
                if start='1' then
                    nextstate <= preprocess;
                else
                    nextstate <= waiting;
                end if;
            when preprocess => nextstate <= words_ass;
            when words_ass => nextstate <= hash_calc_step;
            when hash_calc_step =>
                if hash_step_counter_tc='1' then
                    nextstate <= hv_calc;
                else
                    nextstate <= hash_calc_step;
                end if;
            when hv_calc =>
                if message_block_counter_tc='1' then
                    nextstate <= finished;
                else
                    nextstate <= words_ass;
                end if;
            when finished =>
                if start='1' then
                    nextstate <= preprocess;
                else 
                    nextstate <= waiting;
                end if;
            when reset =>
                if rst='1' then
                    if start='1' then
                        nextstate <= preprocess;
                    else
                        nextstate <= waiting;
                    end if;
                else
                    nextstate <= reset;
                end if;
        end case;
    end process;
    
    
end Behavioral;
