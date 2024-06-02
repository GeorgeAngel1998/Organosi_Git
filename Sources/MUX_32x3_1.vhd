library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_32x3_1 is
    Port ( 	  in_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  in_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  in_C : in  STD_LOGIC_VECTOR (31 downto 0);
			  sel: in STD_LOGIC_VECTOR (1 downto 0);
              output : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX_32x3_1;

architecture Behavioral of MUX_32x3_1 is

begin
	output <= in_A when sel = "00" else
		      in_B when sel = "01" else
			  in_C when sel = "10";

end Behavioral;

