--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Adder is
    Port ( 
        adder1 : in  STD_LOGIC_VECTOR (31 downto 0);
        adderOut : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end Adder;

architecture Behavioral of Adder is

begin
process(adder1)
    begin
--        adderOut <= std_logic_vector(unsigned(adder1) + 4);
--        adderOut <= std_logic_vector(unsigned(adder1) + "00000000000000000000000000000100");
        adderOut <= adder1 + 4;
    end process;
end Behavioral;