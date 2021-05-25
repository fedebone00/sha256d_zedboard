----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.05.2021 10:42:08
-- Design Name: 
-- Module Name: sha256_pkg - 
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

package sha256_pkg is
    --  Ch function
    pure function Ch (x,y,z: std_logic_vector(31 downto 0)) return std_logic_vector;
    
--  Maj function
    pure function Maj (x,y,z: std_logic_vector(31 downto 0)) return std_logic_vector;
    
--  S0 function
    pure function BIG_S0 (x: std_logic_vector(31 downto 0)) return std_logic_vector;
    
--  S1 function
    pure function BIG_S1 (x: std_logic_vector(31 downto 0)) return std_logic_vector;
    
--  s0 function
    pure function small_s0 (x: std_logic_vector(31 downto 0)) return std_logic_vector;
    
--  s1 function
    pure function small_s1 (x: std_logic_vector(31 downto 0)) return std_logic_vector;
    
    type WordsArray is array(integer range <>) of std_logic_vector(31 downto 0);
    type MessageBlockArray is array(15 downto 0) of std_logic_vector(511 downto 0);
end package;

package body sha256_pkg is
    --  Ch function
    pure function Ch (x,y,z: std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return (x and y) xor (not x and z);
    end function; --Ch
    
--  Maj function
    pure function Maj (x,y,z: std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return (x and y) xor (x and z) xor (y and z);
    end function; --Maj
    
--  S0 function
    pure function BIG_S0 (x: std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((unsigned(x) ror 2) xor (unsigned(x) ror 13) xor (unsigned(x) ror 22));
    end function; --BIG_S0
    
--  S1 function
    pure function BIG_S1 (x: std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((unsigned(x) ror 6) xor (unsigned(x) ror 11) xor (unsigned(x) ror 25));
    end function; --BIG_S1
    
--  s0 function
    pure function small_s0 (x: std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((unsigned(x) ror 7) xor (unsigned(x) ror 18) xor (unsigned(x) srl 3));
    end function; --small_s0
    
--  s1 function
    pure function small_s1 (x: std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((unsigned(x) ror 17) xor (unsigned(x) ror 19) xor (unsigned(x) srl 10));
    end function; --small_s1
end package body;


