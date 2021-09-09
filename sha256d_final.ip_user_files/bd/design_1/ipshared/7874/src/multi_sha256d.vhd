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
            current_nonce: out unsigned(31 downto 0); -- implementation specific: zedboard fits only 1 multi_sha256d instance
            ready, done: out std_logic );
end multi_sha256d;

architecture Behavioral of multi_sha256d is
    type state is (waiting, start_work, working, finished, reset);
    type array_std_logic_vector_256 is array (N_INST-1 downto 0) of std_logic_vector(255 downto 0);
    type array_std_logic_vector_640 is array (N_INST-1 downto 0) of std_logic_vector(639 downto 0);
    type array_unsigned_32 is array (N_INST-1 downto 0) of unsigned(31 downto 0);
    
    constant max_nonce: unsigned(31 downto 0) := x"ffffffff";
    
    function nonce_init return array_unsigned_32 is
        variable n: array_unsigned_32;
        variable tmp: unsigned(63 downto 0);
    begin
        for i in n'range loop
            tmp := (max_nonce/N_INST)*i;
            n(i) := tmp(31 downto 0);
        end loop;
        return n;
    end function;
    
    function byte_swap(x: unsigned) return unsigned is
        constant l: integer := x'length/8;
        variable y: unsigned(x'range);
    begin
        for i in 1 to l loop
            y(i*8-1 downto (i-1)*8) := x((l-i+1)*8-1 downto (l-i)*8);
        end loop;
        return y;
    end function;
    
    function meetsTarget(hash: unsigned(255 downto 0); target: unsigned(255 downto 0)) return std_logic is
    begin
        if hash <= target then
            return '1';
        else
            return '0';
        end if;
    end function;
    
    function find_first_one(x: std_logic_vector) return integer is
    begin
        for i in x'range loop
            if x(i)='1' then
                return i;
            end if;
        end loop;
        return -1;
    end function;
    
    
    constant all_zeros: std_logic_vector(N_INST-1 downto 0) := (others=>'0');
    signal si: array_std_logic_vector_640;
    signal output: array_std_logic_vector_256;
    signal sha_done, sha_ready, mt: std_logic_vector(N_INST-1 downto 0);  
    signal sha_start: std_logic;
    signal nonce_index: integer; 
    
    signal nonce_d, nonce_q: array_unsigned_32 := nonce_init;
    
    signal nonce_swap: array_unsigned_32;
    
    signal currentstate, nextstate: state;
    
begin

    current_nonce <= nonce_q(0);


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
            nonce_q <= nonce_init;
        elsif rising_edge(clk) then
            nonce_q <= nonce_d;
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