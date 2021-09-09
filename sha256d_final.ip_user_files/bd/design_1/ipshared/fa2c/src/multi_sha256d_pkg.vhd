----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.09.2021 19:24:24
-- Design Name: 
-- Module Name: multi_sha256d_pkg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

package multi_sha256d_pkg is
    
    type array_std_logic_vector_256 is array (natural range<>) of std_logic_vector(255 downto 0);
    type array_std_logic_vector_640 is array (natural range<>) of std_logic_vector(639 downto 0);
    type array_unsigned_32 is array (natural range<>) of unsigned(31 downto 0);
    
    constant max_nonce: unsigned(31 downto 0) := x"ffffffff";
    
    function nonce_init(n_inst: natural) return array_unsigned_32;
    
    function byte_swap(x: unsigned) return unsigned;
    
    function meetsTarget(hash: unsigned(255 downto 0); target: unsigned(255 downto 0)) return std_logic;
    
    function find_first_one(x: std_logic_vector) return integer;
end package;

package body multi_sha256d_pkg is
    function nonce_init(n_inst: natural) return array_unsigned_32 is
        variable n: array_unsigned_32(n_inst-1 downto 0);
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
end package body;
