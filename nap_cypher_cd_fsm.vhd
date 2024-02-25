----------------------------------------------------------------------------------
-- Company:  Group 1 (Board with Hannes)
-- Engineer: Christopher Daffinrud
-- 
-- Create Date: 25.02.2024 17:21:52
-- Design Name: 
-- Module Name: nap_cypher_cd_fsm 
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

entity nap_cypher_cd_fsm is
   Port (
   clk, reset : in std_logic; -- Clock and reset
   receive_done, transmit_done : in std_logic; -- Receive and transmit signal
   ascii_received, ascii_transmitted :  in std_logic_vector(7 downto 0); -- The ascii data for received and transmitted to/from UART
   clr_ROM, inc_ROM, clr_RAM, inc_RAM : out std_logic; -- Clear and increment signals for ROM/RAM
   write : out std_logic; -- Write signal for RAM
   transmit_start : out std_logic -- Start signal for Transmit to UART
   );
end nap_cypher_cd_fsm;

architecture arch of nap_cypher_cd_fsm is
   type state_type is (clear, receive, check_data, transmit);
   signal state_reg, state_next: state_type;
begin

   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= clear;
      elsif rising_edge(clk) then
         state_reg <= state_next;
      end if;
   end process;

   -- FSM logic
   process(state_reg, receive_done, transmit_done, ascii_received, ascii_transmitted)
   begin
   -- Make sure that everything is set to zero in the beginning.
   clr_ROM <= '0';
   inc_ROM <= '0';
   clr_RAM <= '0';
   inc_RAM <= '0';
   write <= '0';
   transmit_start <= '0';
   state_next <= state_reg;
   
   case state_reg is 
   when clear =>
        clr_RAM <= '1';
        clr_ROM <= '1';
        state_next <= receive;
   when receive =>
        if (receive_done = '1') then
            if ((ascii_received >= x"41" and ascii_received <= x"5A") or -- If ascii is lower case a-z
                (ascii_received >= x"61" and ascii_received <= x"7A") or -- If ascii is upper case A-Z
                 ascii_received = x"20" or ascii_received = x"0D") then -- If ascii is space or enter
            write <= '1'; -- Send write signal to RAM.
            
                if (ascii_received = x"0D") then -- Checks for enter Key
                    clr_RAM <= '1'; -- Clear signal for RAM counter
                    state_next <= check_data; -- Change to Check enter-state
                else
                    inc_ROM <= '1'; -- Increment signal for ROM where key is stored
                    inc_RAM <= '1'; -- Increment signal for RAM to store next ascii
                end if;
            end if;
        end if;
   when check_data =>
       if (ascii_transmitted = x"0D") then -- Checks ascii from RAM if Enter-value
           state_next <= clear; -- Sets state to Clear.
       else 
           transmit_start <= '1'; -- Set transmit signal to 1
           state_next <= transmit; -- Changes FSM state to transmit
       end if; 
   when transmit =>
        if (transmit_done = '1') then -- Checks if transmitted is done
            inc_RAM <= '1'; -- Sets ram increment signal to 1
            state_next <= check_data; -- State for checking next value on RAM
        end if;
   end case;
   end process;
end ;
