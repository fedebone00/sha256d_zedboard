library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity counter is
  generic (
    -- Size in bits of the counter
    SIZE : integer := 4;
    -- Starting value of the counter
    START: integer := 0;
    -- Value at which the terminal count is asserted
    TERMINAL : integer := 15
  );
  port (
    -- System clock
    clock : in std_logic;
    -- Global reset (active low)
    reset : in std_logic;
    -- Count init
    counter_init : in std_logic;
    -- Count enable
    counter_enable : in std_logic;
    -- Terminal count
    counter_tc : out std_logic;
    -- Count value
    counter_val : out unsigned( SIZE - 1 downto 0 )
  );
end counter;

architecture behavioral of counter is

  -- Temporary value to hold the count
  signal the_count : unsigned( SIZE - 1 downto 0 );

begin

  counter_val <= the_count;

  process ( clock, reset ) begin
    if reset = '0' then
      the_count <= to_unsigned(START, SIZE);
    elsif rising_edge( clock ) then
      if ( counter_init = '1' ) then
        the_count <= to_unsigned(START, SIZE);
      elsif ( counter_enable = '1' ) then
        if  the_count = TERMINAL then
            the_count <= to_unsigned(START, SIZE);
        else
            the_count <= the_count + 1;
        end if;
      end if;
    end if;
  end process;

  counter_tc <= '1' when ( the_count = TERMINAL ) else '0';

end behavioral;
