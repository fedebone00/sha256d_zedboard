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
use IEEE.NUMERIC_STD.ALL;
use work.multi_sha256d_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multi_sha256d is
    Generic ( N_INST: natural := 4 );
    Port (  clk, rst, start: in std_logic;
            data: in std_logic_vector(607 downto 0);
            target: in std_logic_vector(255 downto 0);
            out_nonce: out unsigned(31 downto 0);
            out_hash: out std_logic_vector(255 downto 0);
            current_nonce: out array_unsigned_32(N_INST-1 downto 0);
            hash_rate: out unsigned(31 downto 0);
            ready, done: out std_logic );
end multi_sha256d;

architecture Behavioral of multi_sha256d is
    type state is (waiting, start_work, working, finished, reset);
    
    
    constant all_zeros: std_logic_vector(N_INST-1 downto 0) := (others=>'0');
    signal si: array_std_logic_vector_640(N_INST-1 downto 0);
    signal output: array_std_logic_vector_256(N_INST-1 downto 0);
    signal sha_done, sha_ready, mt: std_logic_vector(N_INST-1 downto 0);  
    signal sha_start: std_logic;
    signal nonce_index: integer; 
    
    signal nonce_d, nonce_q: array_unsigned_32(N_INST-1 downto 0) := nonce_init(N_INST);
    
    signal nonce_swap: array_unsigned_32(N_INST-1 downto 0);
    
    signal currentstate, nextstate: state;
    
    signal hash_rate_d, hash_rate_q: unsigned(31 downto 0);
    
    signal hash_counter: unsigned(31 downto 0);
    signal hash_counter_init, hash_counter_enable, hash_counter_tc: std_logic;
    
    signal clk_counter: unsigned(31 downto 0);
    signal clk_counter_init, clk_counter_enable, clk_counter_tc: std_logic;
    
begin

    hash_rate <= hash_rate_q;

    clk_counter_inst: entity work.counter generic map(SIZE=>32, TERMINAL=>25000000)
        port map(clock=>clk, reset=>rst, counter_init=>clk_counter_init,
                counter_enable=>clk_counter_enable, counter_tc=>clk_counter_tc,
                counter_val=>clk_counter);
                
    hash_counter_inst: entity work.counter generic map(SIZE=>32, TERMINAL=>25000000)
        port map(clock=>clk, reset=>rst, counter_init=>hash_counter_init,
                counter_enable=>hash_counter_enable, counter_tc=>hash_counter_tc,
                counter_val=>hash_counter);
                
    process(clk, rst, clk_counter_tc, sha_done) is
        variable tmp: unsigned(63 downto 0);
    begin
        hash_rate_d <= hash_rate_q;
        
        clk_counter_init<='0';
        clk_counter_enable<='1';
        
        hash_counter_init<='0';
        hash_counter_enable<='0';
        
        if rst='0' then
            hash_counter_init<='1';
            clk_counter_init<='1';
        elsif clk_counter_tc='1' then
            hash_counter_init<='1';
        
            clk_counter_init<='1';
            tmp := hash_counter*8;
            hash_rate_d <= tmp(31 downto 0); --clk_counter_tc raises after 1/4 of second * 2 instances
            
        end if;
        
        if find_first_one(sha_done) /= -1 then
            hash_counter_enable<='1';
            --actually every instance of sha256d starts and finish at the same time, so I can multiply the hash_counter for the number of instances
        end if;
    end process;





    current_nonce <= nonce_q;


    NONCE_SWAP_GEN:
    for i in nonce_swap'range generate
        nonce_swap(i) <= byte_swap(nonce_q(i));
    end generate NONCE_SWAP_GEN;
    
    SI_GEN:
    for i in si'range generate
        si(i) <= data & std_logic_vector(nonce_swap(i));
    end generate SI_GEN;
    
--    MT_GEN:
--    for i in mt'range generate
--        mt(i) <= meetsTarget(byte_swap(unsigned(output(i))), byte_swap(unsigned(target))) when sha_done(i)='1' or currentstate=finished else '0';
--    end generate MT_GEN;
    
    nonce_index <= find_first_one(mt);
    
    SHA256D_INST_GEN:
    for i in si'range generate
        sha256_inst: entity work.sha256d generic map(640) port map (clk => clk, rst=>rst, start=>sha_start,input=>si(i),output=>output(i), ready=>sha_ready(i), done=>sha_done(i) );
    end generate SHA256D_INST_GEN;
    
    process(output, sha_done) is
    begin
        for i in mt'range loop
            if sha_done(i)='1' then
                mt(i) <= meetsTarget(byte_swap(unsigned(output(i))), byte_swap(unsigned(target)));
            else
                mt(i) <= '0';
            end if;
        end loop;
    end process;
    
    process(sha_done, mt, nonce_q) is
    begin
        nonce_d <= nonce_q;
        for i in nonce_q'range loop
            if sha_done(i)='1' and mt(i)='0' then
                nonce_d(i) <= nonce_q(i) + 1;
            end if;
        end loop;
    end process;
    
    process(currentstate, nonce_q) is
    begin
        ready <= '0';
        done <= '0';
        sha_start <= '0';
        out_nonce <= (others=>'U');
        out_hash <= (others=>'U');
        case currentstate is
            when waiting =>
                ready <= '1';
            when start_work =>
                sha_start <= '1';
            when finished =>
                out_nonce <= nonce_q(nonce_index);
                out_hash <= output(nonce_index);
                done <= '1';
            when others=>
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
            nonce_q <= nonce_init(N_INST);
            hash_rate_q <= (others=>'0');
        elsif rising_edge(clk) then
            nonce_q <= nonce_d;
            hash_rate_q <= hash_rate_d;
        end if;
    end process;
    
    process(currentstate, start, rst, nonce_index, sha_ready) is
    begin
        nextstate <= currentstate;
        case currentstate is
            when waiting =>
                if start='1' then
                    nextstate <= start_work;
                end if;
            when start_work =>
                nextstate <= working;
            when working =>
                if find_first_one(sha_ready) /= -1 then
                    nextstate <= start_work;
                elsif nonce_index /= -1 then
                    nextstate <= finished;
                end if;
            when finished =>
                nextstate <= waiting;
            when reset =>
                if rst='1' then
                    nextstate <= waiting;
                end if;
        end case;
    end process;
end Behavioral;