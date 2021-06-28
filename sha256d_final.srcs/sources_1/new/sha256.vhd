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
        done: out std_logic
        );
end sha256;

architecture Behavioral of sha256 is
    constant K: WordsArray(63 downto 0) := ( 
        0=>x"428a2f98",1=>x"71374491",2=>x"b5c0fbcf",3=>x"e9b5dba5",4=>x"3956c25b",5=>x"59f111f1",6=>x"923f82a4",7=>x"ab1c5ed5",
        8=>x"d807aa98", 9=>x"12835b01",10=>x"243185be",11=>x"550c7dc3",12=>x"72be5d74",13=>x"80deb1fe",14=>x"9bdc06a7",15=>x"c19bf174",
        16=>x"e49b69c1",17=>x"efbe4786",18=>x"0fc19dc6",19=>x"240ca1cc",20=>x"2de92c6f",21=>x"4a7484aa",22=>x"5cb0a9dc",23=>x"76f988da",
        24=>x"983e5152",25=>x"a831c66d",26=>x"b00327c8",27=>x"bf597fc7",28=>x"c6e00bf3",29=>x"d5a79147",30=>x"06ca6351",31=>x"14292967",
        32=>x"27b70a85", 33=>x"2e1b2138",34=>x"4d2c6dfc",35=>x"53380d13",36=>x"650a7354",37=>x"766a0abb",38=>x"81c2c92e",39=>x"92722c85",
        40=>x"a2bfe8a1", 41=>x"a81a664b",42=>x"c24b8b70",43=>x"c76c51a3",44=>x"d192e819",45=>x"d6990624",46=>x"f40e3585",47=>x"106aa070",
        48=>x"19a4c116", 49=>x"1e376c08",50=>x"2748774c",51=>x"34b0bcb5",52=>x"391c0cb3",53=>x"4ed8aa4a",54=>x"5b9cca4f",55=>x"682e6ff3",
        56=>x"748f82ee", 57=>x"78a5636f",58=>x"84c87814",59=>x"8cc70208",60=>x"90befffa",61=>x"a4506ceb",62=>x"bef9a3f7",63=>x"c67178f2");
    constant init_HV: WordsArray(7 downto 0) :=
        (   0 => x"6a09e667", 1 => x"bb67ae85", 2 => x"3c6ef372", 3 => x"a54ff53a",
            4 => x"510e527f", 5 => x"9b05688c", 6 => x"1f83d9ab", 7 => x"5be0cd19" );
            
    type state is (waiting, pre,
     hashLoop0a, hashLoop0b, 
     hashLoop1a, hashLoop1b, hashLoop2, finish, reset);
    signal currentstate, nextstate: state;
    
    signal blocks_count: integer;
    signal message_block: std_logic_vector(511 downto 0);
    signal hv: WordsArray(7 downto 0);
    signal words: WordsArray(7 downto 0);
    signal W: WordsArray(63 downto 0);
    
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
        variable T1, T2: unsigned(31 downto 0);
        variable W: WordsArray(63 downto 0);
    begin
        message_block <= message_block;
        hv <= hv;
        
        if rising_edge(clk) then
            case currentstate is
                when pre =>
                    hv <= init_hv;
                when hashLoop0a =>
                    message_block <= message((blocks_count*512)-1 downto (blocks_count-1)*512);
                    words <= hv;
                when hashLoop0b =>
                    if w_counter_int_val < 16 then
                        W(w_counter_int_val) := message_block((16-w_counter_int_val)*32-1 downto (15-w_counter_int_val)*32);
                    else
                        W(w_counter_int_val) := std_logic_vector(unsigned(small_s1(W(w_counter_int_val-2))) + unsigned(W(w_counter_int_val-7)) + unsigned(small_s0(W(w_counter_int_val-15))) + unsigned(W(w_counter_int_val-16)));
                    end if;
                when hashLoop1a =>
                    --for i in 0 to 3 loop
                        T1 := unsigned(words(7))+unsigned(BIG_S1(words(4)))+unsigned(Ch(words(4), words(5), words(6)))+unsigned(K(hash_round_counter_int_val))+unsigned(W(hash_round_counter_int_val));
                        T2 := unsigned(BIG_S0(words(0)))+unsigned(Maj(words(0), words(1), words(2)));
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
                    output <= hv(0) & hv(1) & hv(2) & hv(3) & hv(4) & hv(5) & hv(6) & hv(7);
                when others =>
            end case;
        end if;
    end process;

    with currentstate select done <=
        '1' when finish,
        '0' when others;

    process(clk, rst) is
    begin
        if falling_edge(rst) then
            currentstate <= reset;
        end if;
        
        if rising_edge(clk) then
            currentstate <= nextstate;
        end if;
    end process;
    
    process(clk, currentstate, rst, start) is
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
--            when hashLoop0c => nextstate <= hashLoop0d;
--            when hashLoop0d => nextstate <= hashLoop0e;
--            when hashLoop0e => nextstate <= hashLoop0f;
--            when hashLoop0f => nextstate <= hashLoop0g;
--            when hashLoop0g => nextstate <= hashLoop1a;
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
