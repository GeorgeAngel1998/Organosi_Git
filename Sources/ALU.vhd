library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           OutALU : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
signal result_signal : std_logic_vector (31 downto 0);
signal temp_signal : std_logic_vector (32 downto 0);
signal zero_signal : STD_LOGIC;

begin

process(A,B,Op)
begin

if Op <= "0000" then
  result_signal <= A + B;
  temp_signal <= ('0' & A) + ('0' & B);
  Ovf <= ((NOT result_signal(31)) XNOR A(31)) AND (A(31) XNOR B(31)) ;
  
  Cout <= temp_signal(32) after 10 ns;
   
elsif Op <= "0001" then
  result_signal <= A - B;
  temp_signal <= ('0' & A) - ('0' & B);
  Ovf <= (result_signal(31) XNOR B(31)) AND (result_signal(31) XOR A(31)) ;
  
  Cout <= temp_signal(32) after 10 ns;
   
elsif Op <= "0010" then
  result_signal <= A and B;
  
elsif Op <= "0011" then
  result_signal <= A or B;
  
elsif Op <= "0100" then
  result_signal <= NOT(A);
	
elsif Op <= "1000" then
  result_signal <= A(31) & A(31 downto 1);
  
elsif Op <= "1001" then
  result_signal <= '0' & A(31 downto 1);
	
elsif Op <= "1010" then
  result_signal <= A(30 downto 0) & '0';
  
elsif Op <= "1100" then
  result_signal <= A(30 downto 0) & A(31);
  
elsif Op <= "1101" then
  result_signal <= A(0) & A(31 downto 1);
  
else
  result_signal <= "00000000000000000000000000000000";
end if;
end process;

WITH result_signal SELECT

zero_signal <= '1' when "00000000000000000000000000000000",
            '0' when others;

OutALU <= result_signal after 10 ns;
Zero <= zero_signal after 10 ns;

end Behavioral;