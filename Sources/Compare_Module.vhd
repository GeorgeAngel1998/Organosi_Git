library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Compare_Module is
    Port (
        Ard     : in STD_LOGIC_VECTOR (4 downto 0);
        Awr     : in STD_LOGIC_VECTOR (4 downto 0);
        WrEn    : in STD_LOGIC;
        Output  : out STD_LOGIC 
    );
end Compare_Module;

architecture Behavioral of Compare_Module is
    
begin

    Output <= 	'1' when (WrEn = '1' and Awr = Ard) else
				'0';

end Behavioral;  