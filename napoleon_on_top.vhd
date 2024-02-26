----------------------------------------------------------------------------------
-- Company: Group 1 (Board with Hannes)
-- Engineer: Oscar
-- 
-- Create Date: 25.02.2024 19:46:41
-- Design Name: 
-- Module Name: napoleon_on_top
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity napoleon_top is
   generic(
      ROM_ADDR_WIDTH: integer := 5; -- max size of the key: 2^5=32 > 20
      KEY_LENGTH: integer     := 20; -- length of "joseferreiraportugal"
	   RAM_ADDR_WIDTH: integer := 8; -- # maximum size of the RAM: 2^10 (1024)
	   RAM_DATA_WIDTH: integer := 8 -- # 8-bit data words
   );
   port(
      clk, reset: in std_logic;
      rx: in std_logic;
      tx: out std_logic;
      rx_done_p: out std_logic
      
--      tx_start_p: out std_logic;
--      write_p: out std_logic;
--      ascii_r_p, ascii_t_p: std_logic_vector(7 downto 0)

   );
end napoleon_top;

architecture str_arch of napoleon_top is
   signal tick: std_logic;
   signal rx_done: std_logic;
   signal ascii_r, ascii_t: std_logic_vector(7 downto 0);
   signal tx_start, tx_done: std_logic;
   signal clra_rom, inca_rom, clrb_ram, incb_ram: std_logic;
   signal addrb_ram: std_logic_vector(7 downto 0);
   signal addra_rom: std_logic_vector(4 downto 0);
   signal key, cphr_out: std_logic_vector(7 downto 0);
   signal wr: std_logic;
begin
   uart_unit: entity work.uart(behaviour)
   generic map(Baud_Rate=>19200)
   port map(
      clk => clk,
      reset => reset,
      rx => rx,
      tx => tx,
      tx_done => tx_done,
      tx_start => tx_start,
      rx_done =>rx_done,
      byte_to_transmit => ascii_t,
      received_byte => ascii_r
   );
   
   rom_counter_unit: entity work.rom_counter(arch)
	generic map(N=>ROM_ADDR_WIDTH, M=>KEY_LENGTH)
   port map(
      clock => clk,
      reset => reset,
      synchronous_clear => clrA_rom,
      load => '0',
      increment => inca_rom,
      up => '1',
      d => (others => '0'),
      max_tick => open,
      min_tick => open,
      address => addrA_rom
	);

   rom_unit: entity work.rom_main(arch)
   port map(
      rom_address => addra_rom,
      data => key
	);

   cnt_ram_unit: entity work.ram_count(arch)
--   generic map(address_size=>RAM_ADDR_WIDTH)
   port map(
      clock => clk,
	  clear_address => clrB_ram,
      increment => incb_ram,
      address => addrB_ram
	);

   ram_unit: entity work.ram_block(arch)
   generic map(address_size=>RAM_ADDR_WIDTH, data_size=>RAM_DATA_WIDTH)
   port map(
      clock => clk,
      write_enable => wr,
      address => addrb_ram,
      data_in => cphr_out,
      data_out => ascii_t
	);

   cipher_unit: entity work.cipher(arch)
   port map(
      ascii_r => ascii_r,
      key => key,
      cphr_out => cphr_out
	);
 
   nap_cypher: entity work.nap_cypher_cd_fsm(arch)
   port map(
      clk => clk,
      reset => reset,
      receive_done => rx_done,
      ascii_received => ascii_r,
	   clr_ROM => clra_rom,
      inc_ROM => inca_rom,
	   clr_RAM => clrb_ram,
      inc_RAM => incb_ram,
	   write => wr,
      ascii_transmitted => ascii_t,
	   transmit_start => tx_start,
      transmit_done => tx_done
	);
	rx_done_p <= '1';
end str_arch;