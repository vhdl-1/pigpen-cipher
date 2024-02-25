----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Erica Fegri
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity napoleon_tb is
   -- Port ();
end napoleon_tb;

architecture arch of napoleon_tb is
constant clk_period : time := 10 ns;
constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us

constant rx_data_ascii_m: std_logic_vector(7 downto 0) := x"6D"; -- receive m
constant rx_data_ascii_a: std_logic_vector(7 downto 0) := x"61"; -- receive a
constant rx_data_ascii_k: std_logic_vector(7 downto 0) := x"6B"; -- receive k
constant rx_data_ascii_e: std_logic_vector(7 downto 0) := x"65"; -- receive e
constant rx_data_ascii_enter: std_logic_vector(7 downto 0) := x"0D"; -- receive enter

Component napoleon
Port ( reset, clk: in std_logic;
           rx:      in std_logic;
           tx:     out std_logic);
end Component;

signal clk, reset: std_logic;
signal srx, stx: std_logic;

begin

    uut: napoleon
    Port Map(clk => clk, reset => reset, 
              rx => srx, tx => stx);
    
    clk_process: process 
            begin
               clk <= '0';
               wait for clk_period/2;
               clk <= '1';
               wait for clk_period/2;
            end process; 
        
     stim: process
        begin
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        wait for clk_period*2;
        
        -- Test ASCII char m
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_m(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 1ms;
        
        -- Test ASCII char a
                        srx <= '0';                      -- start bit = 0
                        wait for bit_period;
                        for i in 0 to 7 loop
                            srx <= rx_data_ascii_a(i);   -- 8 data bits
                            wait for bit_period;
                        end loop;
                        srx <= '1';                      -- stop bit = 1
                        wait for 1ms;

        -- Test ASCII char k
                        srx <= '0';                      -- start bit = 0
                        wait for bit_period;
                        for i in 0 to 7 loop
                            srx <= rx_data_ascii_k(i);   -- 8 data bits
                            wait for bit_period;
                        end loop;
                        srx <= '1';                      -- stop bit = 1
                        wait for 1ms;
 
         -- Test ASCII char e
                        srx <= '0';                      -- start bit = 0
                        wait for bit_period;
                        for i in 0 to 7 loop
                            srx <= rx_data_ascii_e(i);   -- 8 data bits
                            wait for bit_period;
                        end loop;
                        srx <= '1';                      -- stop bit = 1
                        wait for 1ms;
                                                
         -- Test ACII Enter
                    srx <= '0';                      -- start bit = 0
                    wait for bit_period;
                    for i in 0 to 7 loop
                      srx <= rx_data_ascii_enter(i);   -- 8 data bits
                      wait for bit_period;
                    end loop;
                    srx <= '1';                      -- stop bit = 1
                    wait;
       
        end process;

end arch;
