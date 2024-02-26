library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_block is
    generic (
        address_size : integer := 8;
        data_size : integer := 8
    );
    port(
        clock : in std_logic;
        write_enable : in std_logic;
        address : in std_logic_vector(0 to address_size-1);
        data_in : in std_logic_vector(0 to data_size-1);
        data_out : out std_logic_vector(0 to data_size-10 t)
    );
end entity ram_block;

architecture arch of ram_block is
    type ram_type is array (2**address_size-1 downto 0) 
        of std_logic_vector(data_size-1 downto 0);
    signal ram : ram_type;

    begin
        process(clock)
        begin
            if (clock'event and clock = '1') then
                if (write_enable = '1') then
                    ram(to_integer(unsigned(address))) <= data_in;
                end if;
            end if;
        end process;
        data_out <= ram(to_integer(unsigned(address)));
end architecture arch;
        
