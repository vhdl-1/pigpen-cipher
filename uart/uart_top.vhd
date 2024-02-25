library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity uart is
    generic(
        Data_Bits: integer:=8;
        Stop_Bit_Ticks: integer := 16;
        Baud_Rate: integer := 19200;
    )
    port ( 
        clk, reset, rx,tx : in std_logic;
        byte_to_transmit :   in std_logic_vector(7 downto 0)
        received_byte :   out std_logic_vector(7 downto 0)
        );
end uart;

architecture behaviour of uart is
    signal stop_tick, rx_done_tick:    std_logic;
    signal tx_start, tx_done: std_logic;
    signal dout:  std_logic_vector(7 downto 0);   

----------------------------------------------------------------------------------
begin

    Baud_Generator: entity work.baud_generator(behaviour)
        generic map(BAUD_RATE=>Baud_Rate)
        port map (  clk=>clk, reset=>reset, to_s_tick=>stop_tick );


    Receiver: entity work.uart_rx(behaviour)
        port map (  clk=>clk, reset=>reset, rx=>rx, output=>byte_to_transmit,
        stop_tick=>stop_tick, rx_done_tick=>rx_done_tick );

    Transmitter: entity work.uart_tx(behaviour)
    generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
    port map(
        clk=>clk, reset=>reset,
        tx_start=>tx_start,
        stop_tick=>stop_tick, byte_to_send=>byte_to_transmit,
        tx_done_tick=> tx_done, tx=>tx
    );
    
end behaviour;