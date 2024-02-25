----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Aditi Deshpande
-- 
-- Create Date: 25.02.2024 18:36:11
-- Design Name: 
-- Module Name: rom_counter - arch
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

entity rom_counter is
--constants
 generic(
      N: integer := 5; 
      M: integer := 21
   );
  Port ( 
  clock, reset: in std_logic;
  synchronous_clear,load,increment,up : in std_logic;
  d: in std_logic_vector(N-1 downto 0);
  max_tick,min_tick: out std_logic;
  address: out std_logic_vector(N-1 downto 0)
  );
end rom_counter;

architecture arch of rom_counter is
 signal r_reg: unsigned(N-1 downto 0);
 signal r_next: unsigned(N-1 downto 0);
begin
-- register
   process(clock,reset)
   begin
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif (clock'event and clock='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   r_next <= (others=>'0') when (r_reg=(M-1) or synchronous_clear='1') else
             unsigned(d)   when load='1' else
             r_reg + 1     when increment ='1' and up='1' else
             r_reg - 1     when increment ='1' and up='0' else
             r_reg;
   -- output logic
   address <= std_logic_vector(r_reg);
   max_tick <= '1' when r_reg=(2**N-1) else '0';
   min_tick <= '1' when r_reg=0 else '0';

end arch;
