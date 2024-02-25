library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cipher is
    Port ( ascii_r : in STD_LOGIC_VECTOR (7 downto 0);
           key : in STD_LOGIC_VECTOR (7 downto 0);
           cphr_out : out STD_LOGIC_VECTOR (7 downto 0));
end cipher;

architecture arch of cipher is
signal sdin:  unsigned (7 downto 0);
signal skey:  unsigned (7 downto 0);
signal sdout: unsigned (7 downto 0);

begin
   sdin <= unsigned(ascii_r);    
   skey <= unsigned(key);
    
   sdout <= -- case of space:
         x"20" when (sdin=x"20") else
         -- case of uppercase:
         (x"7A" + skey - sdin - x"20") when (((sdin >= x"41") and (sdin <= x"5A")) and ((sdin + X"20") >= skey)) else
         (x"60" + skey - sdin - x"20") when (((sdin >= x"41") and (sdin <= x"5A")) and ((sdin + X"20") <  skey)) else
         -- case of lowercase:
         (x"7A" + skey - sdin) when (((sdin >= x"61") and (sdin <= x"7A")) and (sdin >= skey)) else
         (x"60" + skey - sdin) when (((sdin >= x"61") and (sdin <= x"7A")) and (sdin <  skey)) else
         sdin;
         
    cphr_out <= std_logic_vector(sdout);
    
end arch;
