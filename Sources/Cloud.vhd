library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Cloud is
    Port ( in_Cloud : in  STD_LOGIC_VECTOR (15 downto 0);
           EN : in  STD_LOGIC_VECTOR(1 downto 0);
           Out_Cloud : out  STD_LOGIC_VECTOR (31 downto 0));
end Cloud;

architecture Behavioral of Cloud is

signal temp_signal : STD_LOGIC_VECTOR (31 downto 0);

begin

process(in_Cloud, EN)
begin
  if EN = "00" then  -- Zero Filling pure
    temp_signal(31 downto 16) <= "0000000000000000";
    temp_signal(15 downto 0) <= in_Cloud;
     
  elsif EN = "01" then -- Sign Extend pure
    temp_signal (31 downto 16) <= (others=>in_Cloud(15));
    temp_signal(15 downto 0) <= in_Cloud;
    
  elsif EN = "10" then -- Shift left with Zero Filling
    temp_signal(31 downto 18) <= "00000000000000";
    temp_signal(17 downto 2) <= in_Cloud;
    temp_signal(1 downto 0) <= "00";
    
  elsif EN = "11" then -- Shift left with Sign Extend
    temp_signal(31 downto 18) <= (others=>in_Cloud(15));
    temp_signal(17 downto 2) <= in_Cloud; 
    temp_signal(1 downto 0) <= "00";                          
  end if;

end process;	
 
Out_Cloud <= temp_signal;
		
end Behavioral;