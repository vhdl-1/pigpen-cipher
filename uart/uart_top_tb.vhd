entity uart_top_tb is
end uart_top_tb;

architecture arch of uart_top_tb is
    constant clk_period : time := 10 ns;
    constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us
    
    -- constant rx_data_ascii_m: std_logic_vector(7 downto 0) := x"6D"; -- receive m
    -- constant rx_data_ascii_a: std_logic_vector(7 downto 0) := x"61"; -- receive a
    -- constant rx_data_ascii_k: std_logic_vector(7 downto 0) := x"6B"; -- receive k
    -- constant rx_data_ascii_e: std_logic_vector(7 downto 0) := x"65"; -- receive e
    -- constant rx_data_ascii_enter: std_logic_vector(7 downto 0) := x"0D"; -- receive enter
    
    type ASCII_Array is array (natural range <>) of std_logic_vector(7 downto 0);
    type RX_Data_Array is array (natural range <>) of ASCII_Array(0 to 5);
    constant rx_data_array : RX_Data_Array := (
    (x"48", x"65", x"6C", x"6C", x"6F", x"0D") -- "Hello"+enter
    );

    Component napoleon
    Port ( reset, clk: in std_logic;
               rx:      in std_logic;
               tx:     out std_logic);
    end Component;
    
    signal clk, reset: std_logic;
    signal simulated_rx, simulated_tx: std_logic;

    begin
        uut: uart
        Port map(clk=>clk, reset=>reset,
                rx=>simulated_rx,simulated_tx);
        clock_pulse: process
            begin
                clk <= not clk;
                wait clk_period/2;
            end process;
        simulate: process
        begin
            reset <= '1'; -- Start with testing reset functionality
            wait for clk_period*2;
            reset <= '0';
            wait for clk_period*2;
            simulated_rx <= '0' -- Pull transmission line to initiate communication as per RS232
            wait for bit_period;
            for character_index in rx_data_array'range loop
                for bit_index in rx_data_array(character_index)'range loop
                    simulated_rx <= rx_data_array(character_index)(bit_index);
                    wait for bit_period;
                end loop;
                simulated_rx <= '1' -- pull tranmission line high to indicate stop bit
                wait for 1ms;
            end loop;

end arch;