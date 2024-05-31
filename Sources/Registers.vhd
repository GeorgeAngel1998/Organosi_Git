library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registers is
    Port (
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        WE : in  STD_LOGIC;
        Data : in  STD_LOGIC_VECTOR (31 downto 0);
        Dout : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end Registers;

architecture Behavioral of Registers is

signal output_signal : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";

begin
process
begin  
wait until CLK'event and CLK='1';	
if(RST = '1') then
   output_signal <= "00000000000000000000000000000000";
else
   if(WE = '1') then
      output_signal <= Data;
   else
	  output_signal <= output_signal;	
   end if;
end if;
end process;
Dout <= output_signal;
    
end Behavioral;

