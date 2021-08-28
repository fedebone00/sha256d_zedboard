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
            out_nonce: buffer unsigned(31 downto 0);
            out_hash: buffer std_logic_vector(255 downto 0);
            ready, done: out std_logic );
end multi_sha256d;

architecture Behavioral of multi_sha256d is
    type state is (waiting, working, finished, reset);
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
        if byte_swap(hash) <= byte_swap(target) then
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
    signal sha_reset, sha_inst_reset, sha_start: std_logic;
    signal nonce_index: integer; 
    
    signal nonce: array_unsigned_32 := nonce_init;
    
    signal nonce_swap: array_unsigned_32;
    
    signal currentstate, nextstate: state;
    
    
begin
    sha_inst_reset <= rst and sha_reset;

    NONCE_SWAP_GEN:
    for i in nonce_swap'range generate
        nonce_swap(i) <= byte_swap(nonce(i));
    end generate NONCE_SWAP_GEN;
    
    SI_GEN:
    for i in si'range generate
        si(i) <= data & std_logic_vector(nonce_swap(i));
    end generate SI_GEN;
    
    MT_GEN:
    for i in mt'range generate
        mt(i) <= meetsTarget(unsigned(output(i)), unsigned(target)) when sha_done(i)='1' else '0';
    end generate MT_GEN;
    
    nonce_index <= find_first_one(mt);
    
    SHA256D_INST_GEN:
    for i in si'range generate
        sha256_inst: entity work.sha256d generic map(640) port map (clk => clk, rst=>sha_inst_reset, start=>sha_start,input=>si(i),output=>output(i), ready=>sha_ready(i), done=>sha_done(i) );
    end generate SHA256D_INST_GEN;
    
    
--    process(sha_inst_reset) is
--    begin
--        if sha_inst_reset='1' then
--            nonce <= (x"00000000", x"000000ff", x"0000ffff", x"00ffffff"); --hardcoded
--        end if;
--    end process;
--    NONCE_INCR_GEN:
--    for i in nonce'range generate
--        process(sha_reset) is
--        begin
--            if sha_reset='1' then
----                nonce(i) <= (i*max_nonce/N_INST);
--                nonce(i) <= to_unsigned((x"000000ff"*i), 8); --hardcoded
--            end if;
--        end process;
        
--        process(sha_done(i), sha_inst_reset) is
--        begin
--            nonce(i) <= nonce(i);
--            if rising_edge(sha_done(i)) then
--                nonce(i) <= nonce(i) + 1;
--            end if;
--            if sha_inst_reset='1' then
--                nonce <= (x"00000000", x"000000ff", x"0000ffff", x"00ffffff"); --hardcoded
--            end if;
--        end process;
--    end generate NONCE_INCR_GEN;
    
    process(mt, rst) is
    begin
        nonce <= nonce;
        for i in nonce'range loop
            if sha_done(i)='1' and mt(i)='0' then
                nonce(i) <= nonce(i) + 1;
            end if;
        end loop;
        
        if rst='0' then
            nonce <= nonce_init;
        end if;
    end process;
    
    process(currentstate) is
    begin
        ready <= '0';
        done <= '0';
        sha_reset <= '0';
        sha_start <= '0';
        out_nonce <= out_nonce;
        out_hash <= out_hash;
        case currentstate is
            when waiting =>
                ready <= '1';
            when working =>
                sha_start <= '1';
                sha_reset <= '1';
            when finished =>
                out_nonce <= nonce(nonce_index);
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
    
    process(currentstate, start, rst, mt) is
    begin
        nextstate <= currentstate;
        case currentstate is
            when waiting =>
                if start='1' then
                    nextstate <= working;
                end if;
            when working =>
                if find_first_one(mt) /= -1 then
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