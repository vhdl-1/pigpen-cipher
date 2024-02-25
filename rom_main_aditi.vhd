----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2024 18:00:15
-- Design Name: 
-- Module Name: rom_main - arch
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom_main is
--takes in the address of where the key is stored
--and what the data is
--32 addressable locations, each capable of holding a byte of data
 Port (rom_address: in std_logic_vector(4 downto 0);
 data: out std_logic_vector(7 downto 0)
  );
end rom_main;

architecture arch of rom_main is
type rom_type is array (0 to 2**5 -1)
    of std_logic_vector(7 downto 0);
    
   --defining the ROM
   -- the key is joseferreiraportugal
   constant hex_to_letter: rom_type:=(
    	x"6A",  -- addr 00: j
      	x"6F",  -- addr 01: o
	x"73",  -- addr 02: s
	x"65",  -- addr 03: e
	x"66",  -- addr 04: f
	x"65",  -- addr 05: e
 	x"72",  -- addr 06: r
 	x"72",  -- addr 07: r
	x"65",  -- addr 08: e
	x"69",  -- addr 09: i
	x"72",  -- addr 10: r
      	x"61",  -- addr 11: a
	x"70",  -- addr 12: p
      	x"6F",  -- addr 13: o
      	x"72",  -- addr 14 r
    	x"74",  -- addr 15: t
      	x"75",  -- addr 16: u
	x"67",  -- addr 03: g
	  x"61",  -- addr 18: a
	  x"6C",  -- addr 19: l
	  --they are empty as we need to fill 32 places
	  x"FF",  -- addr 20: (void)
	  x"FF",  -- addr 21: (void)
	  x"FF",  -- addr 22: (void)
	  x"FF",  -- addr 23: (void)
	  x"FF",  -- addr 24: (void)
	  x"FF",  -- addr 25: (void)
	  x"FF",  -- addr 26: (void)
	  x"FF",  -- addr 27: (void)
	  x"FF",  -- addr 28: (void)
	  x"FF",  -- addr 29: (void)
	  x"FF",  -- addr 30: (void)
	  x"FF"   -- addr 31: (void)
   );
   
   
begin

   -- the data becomes which address comes in
data <= hex_to_letter(to_integer(unsigned(address)));
end arch;
