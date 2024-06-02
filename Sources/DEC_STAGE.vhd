library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DEC_STAGE is
    Port ( Clk : in  STD_LOGIC;
           Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           cloud_enable : in  STD_LOGIC_VECTOR (1 downto 0);
           Reset : in STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);     
           
           DEC_IMMED : out STD_LOGIC;
           DEC_PC_SEL : out STD_LOGIC;      
           
           --Testing Outputs
           TEST_Ard1_out : out STD_LOGIC_VECTOR(4 downto 0);
           TEST_Ard2_out : out STD_LOGIC_VECTOR(4 downto 0);
           TEST_Awr_out : out STD_LOGIC_VECTOR(4 downto 0)
       );
end DEC_STAGE;

architecture Behavioral of DEC_STAGE is

component Register_File is
	Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           RST : in STD_LOGIC
           );
end component;

component MUX_5x2_1 is 
	Port ( in_A : in  STD_LOGIC_VECTOR (4 downto 0);
           in_B : in  STD_LOGIC_VECTOR (4 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

component MUX_32x2_1 is 
	Port ( in_A : in  STD_LOGIC_VECTOR (31 downto 0);
           in_B : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Cloud is
	Port ( in_Cloud : in  STD_LOGIC_VECTOR (15 downto 0);
           EN : in  STD_LOGIC_VECTOR (1 downto 0);
           Out_Cloud : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal MUX5_output_signal: std_logic_vector(4 downto 0);
signal MUX32_output_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal RF_A_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal RF_B_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Immed_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

MUX01 : MUX_5x2_1 port map ( sel => RF_B_sel,
									in_A =>Instr(15 downto 11),
									in_B =>Instr(20 downto 16),
									output => MUX5_output_signal);
									

MUX02 : MUX_32x2_1 port map ( sel => RF_WrData_sel,
								     	 in_A =>ALU_out,
										 in_B =>MEM_out,
										 output=> MUX32_output_signal);

CL01: Cloud port map ( in_Cloud => Instr(15 downto 0),
							EN => cloud_enable,
							Out_Cloud => Immed_signal);							
				
RF : Register_File port map ( Ard1 => Instr(25 downto 21),
							  Ard2 => MUX5_output_signal,
							  Awr =>  Instr(20 downto 16),
							  Dout1=> RF_A_signal,
							  Dout2=> RF_B_signal,
							  WrEn=> RF_WrEn,
						      Clk=>  Clk,
							  Din=> MUX32_output_signal,
							  RST => Reset);

TEST_Ard1_out <= Instr(25 downto 21);
TEST_Ard2_out <= MUX5_output_signal;
TEST_Awr_out <= Instr(20 downto 16);
	
Immed <= Immed_signal;
RF_A <= RF_A_signal;
RF_B <= RF_B_signal;

process(Instr)
begin
    if(Instr(31 downto 26) =  "111111" or Instr(31 downto 25) =  "01000") then
        DEC_PC_SEL <= '1';
    else
        DEC_PC_SEL <= '0';
    end if;
    
    if(Instr(31 downto 30) =  "10") then
        DEC_IMMED <= '0';
    else
        DEC_IMMED <= '1';
    end if;          
end process;    

end Behavioral;