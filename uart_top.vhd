library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity uart is
    generic (
        Data_Bits: integer := 8;
        Stop_Bit_Ticks: integer := 16;
        Baud_Rate: integer := 19200
    );
    port ( 
        clk, reset, rx, tx_start : in std_logic;
        tx, tx_done, rx_done: out std_logic;
        byte_to_transmit :   in std_logic_vector(7 downto 0);
        received_byte :   out std_logic_vector(7 downto 0)
        );
end uart;

architecture behaviour of uart is
    signal stop_tick:  std_logic;
--    rx_done_tick:    
--    signal tx_start, tx_done_signal: std_logic;
--    signal dout:  std_logic_vector(7 downto 0);  

----------------------------------------------------------------------------------
begin

    Baud_Generator: entity work.baud_generator(behaviour)
        generic map(BAUD_RATE=>Baud_Rate)
        port map (  clk=>clk, reset=>reset, to_s_tick=>stop_tick );

    Receiver: entity work.uart_rx(behaviour)
        port map (  clk=>clk, reset=>reset, rx=>rx, output=>received_byte,
        stop_tick=>stop_tick, rx_done_tick=>rx_done );

    Transmitter: entity work.uart_tx(behaviour)
    generic map(DATA_BITS=>Data_Bits, STOP_TICKS=>Stop_Bit_Ticks)
    port map(
        clk=>clk, reset=>reset,
        tx_start=>tx_start,
        stop_tick=>stop_tick, byte_to_send=>byte_to_transmit,
        tx_done_tick=> tx_done, tx=>tx
    );
    
end behaviour;