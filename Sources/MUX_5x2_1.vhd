library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_5x2_1 is
    Port ( in_A   : in  STD_LOGIC_VECTOR (4 downto 0);
           in_B   : in  STD_LOGIC_VECTOR (4 downto 0);        
           sel    : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (4 downto 0));
end MUX_5x2_1;

architecture Behavioral of MUX_5x2_1 is
    signal output_signal : STD_LOGIC_VECTOR (4 downto 0);
begin

--process(sel)
--begin

output_signal <= in_A    when sel = '0' else in_B when sel = '1';

output <= output_signal;

end Behavioral;