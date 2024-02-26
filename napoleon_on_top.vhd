----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Oscar
-- 
-- Create Date: 25.02.2024 19:46:41
-- Design Name: 
-- Module Name: napoleon_top
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity napoleon is
   generic(
      -- Default setting:
      -- 19,200 baud, 8 data bis, 1 stop bits
      DBIT: integer           := 8;     -- # data bits
      SB_TICK: integer        := 16; -- # ticks for stop bits, 16/24/32: for 1/1.5/2 stop bits
      DVSR: integer           := 326;  -- baud rate divisor: DVSR = 100M/(16*baud rate)
      DVSR_BIT: integer       := 9; -- # bits of DVSR
      ROM_ADDR_WIDTH: integer := 5;   -- # maximum size of the ROM (key): 2^5 (32)
      KEY_LENGTH: integer     := 19;       -- length of the key currently used
	   RAM_ADDR_WIDTH: integer := 10;  -- # maximum size of the RAM: 2^10 (1024)
	   RAM_DATA_WIDTH: integer := 8   -- # 8-bit data words
   );
   port(
      clk, reset: in std_logic;
      rx: in std_logic;
      tx: out std_logic
   );
end napoleon;

architecture str_arch of napoleon is
   signal tick: std_logic;
   signal rx_done: std_logic;
   signal ascii_r, ascii_t: std_logic_vector(7 downto 0);
   signal tx_start, tx_done: std_logic;
   signal clra_rom, inca_rom, clrb_ram, incb_ram: std_logic;
   signal addrb_ram: std_logic_vector(9 downto 0);
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
      byte_to_transmit => ascii_t,
      received_byte => ascii_r
   );
   
   rom_counter_unit: entity work.rom_counter_aditi(arch)
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

   rom_unit: entity work.rom_main_aditi(arch)
   port map(
      rom_address => addra_rom,
      data => key
	);

   cnt_ram_unit: entity work.cnt_ram(arch)
   generic map(N=>RAM_ADDR_WIDTH)
   port map(
      clk => clk,
      reset => reset,
      syn_clr => clrB_ram,
      load => '0',
      en => incb_ram,
      up => '1',
      d => (others => '0'),
      max_tick => open,
      min_tick => open,
      q => addrB_ram   
	);

   ram_unit: entity work.xilinx_one_port_ram_sync(arch)
   generic map(ADDR_WIDTH=>RAM_ADDR_WIDTH, DATA_WIDTH=>RAM_DATA_WIDTH)
   port map(
      clk => clk,
      wr => wr,
      addr => addrb_ram,
      din => cphr_out,
      dout => ascii_t	  
	);

   cipher_unit: entity work.cipher(arch)
   port map(
      ascii_r => ascii_r,
      key => key,
      cphr_out => cphr_out	  
	);			   
 
   ctr_path_unit: entity work.nap_cypher_cd_fsm(arch)
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
			   
end str_arch;