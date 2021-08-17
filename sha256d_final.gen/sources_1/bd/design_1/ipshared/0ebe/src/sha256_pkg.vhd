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


