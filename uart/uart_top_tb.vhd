library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
entity uart_top_tb is
end uart_top_tb;

architecture arch of uart_top_tb is
    constant clk_period : time := 10 ns;
    constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us
    
    constant rx_data_ascii_m: std_logic_vector(7 downto 0) := x"6D"; -- receive m
    type RX_Data_Array_TYPE is array (natural range<>) of std_logic_vector(7 downto 0);
    constant rx_data_array : RX_Data_Array_TYPE := (x"48", x"65", x"6C", x"6C", x"6F", x"0D"); -- "Hello"+enter

    Component uart
    Port ( 
            clk, reset, rx, tx_start : in std_logic;
            tx, tx_done, rx_done: out std_logic;
            byte_to_transmit: in std_logic_vector(7 downto 0);
            received_byte :   out std_logic_vector(7 downto 0)
               );
    end Component;
    
    signal clk, reset: std_logic:='0';
    signal tx_done, rx_done, tx_start: std_logic;
    signal simulated_rx, simulated_tx: std_logic;
    signal received_byte, transmitted_byte: std_logic_vector(7 downto 0);

    begin
        uut: uart
        Port Map(clk=>clk, reset=>reset,
                rx=>simulated_rx,tx=>simulated_tx,
                byte_to_transmit =>transmitted_byte, 
                received_byte=>received_byte,
                tx_done=>tx_done,
                rx_done=>rx_done,tx_start=>tx_start
                );
        clock_pulse: process
            begin
                clk <= not clk;
--                clk <= not clk;
                wait for clk_period/2;
            end process;
            
        simulate: process
        begin
            reset <= '1'; -- Start with testing reset functionality
            wait for clk_period*2;
            reset <= '0';
            wait for clk_period*2;
            
--             simulated_rx <= '0'; -- Pull transmission line to initiate communication as per RS232
--             wait for bit_period;
--             for i in 0 to 7 loop
--                simulated_rx <= rx_data_ascii_m(i);
--                wait for bit_period;
--             end loop;   
--             simulated_rx <= '1';
--             wait for 1ms;
            
    
            
            for character_index in rx_data_array'range loop
                simulated_rx <= '0'; -- Pull transmission line to initiate communication as per RS232
                wait for bit_period;
                for i in 0 to 7 loop
                    simulated_rx <= rx_data_array(character_index)(i);
                    wait for bit_period;
                end loop;
--                for bit_index in rx_data_array(character_index)'range loop
--                    simulated_rx <= temp(bit_index);
--                    wait for bit_period;
--                end loop;
                simulated_rx <= '1'; -- pull tranmission line high to indicate stop bit
                wait for 1ms;
                
                transmitted_byte <= rx_data_array(0);
                tx_start<='1';
                while tx_done = '0'loop
                    wait for clk_period;
                end loop;
                
            end loop;
         end process;

end arch;