library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_count is
    Port ( clock : in  STD_LOGIC;
           clear_address : in  STD_LOGIC;
           increment: in  STD_LOGIC;
           address : out  std_logic_vector(7 downto 0)
           );
end ram_count;

architecture arch of ram_count is
     signal ram_address :integer;
     

begin
    process(clock)
    begin
        if (clear_address='1' and increment='0') then
            ram_address <=(others=>'0');
        end if;
        if (clear_address='0' and increment='1') then
            ram_address <= ram_address+1;
        end if;
    end process;

        
end arch;