library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.all;
entity baud_generator is
    generic (
        CLOCK_FREQUENCY: integer := 100_000_000;
        BAUD_RATE: integer := 19200;
        OVERSAMPLE: integer := 16;
        N: integer := 9 -- num of bits
        -- M: integer := 326 ); -- mod-326 counter 
        );
    port ( 
        clk, reset:   in std_logic;
        to_s_tick:  out std_logic );
end baud_generator;
------------------------------------------
architecture behaviour of baud_generator is
    signal r_reg:   unsigned(N-1 downto 0);
    signal r_next:  unsigned(N-1 downto 0);
    signal q:       std_logic_vector(N-1 downto 0);
    constant M :integer := integer(CLOCK_FREQUENCY/(BAUD_RATE*OVERSAMPLE));
----------------------------------------------------------------------------------
begin
    process(clk, reset) begin
        if (reset = '1') then
            r_reg <= (others =>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
    
    -- next-state logic
    r_next <= (others => '0') when r_reg=(M-1) else r_reg+1;
    
    -- output logic
    q <= std_logic_vector(r_reg);
    to_s_tick <= '1' when r_reg=(M-1) else '0';
end behaviour;