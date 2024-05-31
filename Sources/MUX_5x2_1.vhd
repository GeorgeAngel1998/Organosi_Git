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

process(sel)
begin
case sel is
	when '0' =>
    	output_signal <= in_A;
	when '1' =>
	    output_signal <= in_B;
	when others =>
	   output_signal <= "11111";
end case;
end process;

output <= output_signal;

end Behavioral;