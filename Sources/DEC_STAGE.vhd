library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DEC_STAGE is
    Port ( Clk : in  STD_LOGIC;
           Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           Reset : in STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
           
           DEC_PC_SEL : out STD_LOGIC;      
           
           --Testing Outputs
           TEST_Ard1_out : out STD_LOGIC_VECTOR(4 downto 0);
           TEST_Ard2_out : out STD_LOGIC_VECTOR(4 downto 0);
           TEST_Awr_out : out STD_LOGIC_VECTOR(4 downto 0)
       );
end DEC_STAGE;

architecture Behavioral of DEC_STAGE is

SIGNAL cloud_enable : STD_LOGIC_VECTOR (1 downto 0);
SIGNAL SIGNAL_IMMED : STD_LOGIC := '0';
SIGNAL SIGNAL_PC_SEL : STD_LOGIC := '0';
SIGNAL SIGNAL_RF_WrEn : STD_LOGIC := '0';
SIGNAL SIGNAL_RF_B_sel : STD_LOGIC := '0';

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

MUX01 : MUX_5x2_1 port map ( sel => SIGNAL_IMMED,
									in_A =>Instr(15 downto 11),
									in_B =>Instr(20 downto 16),
									output => MUX5_output_signal);
									

MUX02 : MUX_32x2_1 port map ( sel => SIGNAL_RF_B_sel,
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
							  WrEn=> SIGNAL_RF_WrEn,
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
if(Instr(31 downto 30) =  "10") then
    SIGNAL_IMMED <= '0';
    cloud_enable <= "00";
    SIGNAL_PC_SEL <= '0';
    SIGNAL_RF_WrEn <= '1';
    SIGNAL_RF_B_sel <= '0';                                 -- Write from ALU    
else
    SIGNAL_IMMED <= '1';
    SIGNAL_RF_B_sel <= '0';
    
    if(Instr(31 downto 26) =  "111000") then                -- li
        cloud_enable <= "01";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_WrEn <= '1';
        SIGNAL_RF_B_sel <= '-';                     -- dont care
    elsif(Instr(31 downto 26) =  "111001") then             -- lui
        cloud_enable <= "00";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_WrEn <= '1';
        SIGNAL_RF_B_sel <= '-';                     -- dont care
    elsif(Instr(31 downto 26) =  "110000") then             -- addi
        cloud_enable <= "01";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_WrEn <= '1';
        SIGNAL_RF_B_sel <= '-';                     -- dont care
    elsif(Instr(31 downto 26) =  "110010") then             --andi
        cloud_enable <= "00";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_WrEn <= '1'; 
        SIGNAL_RF_B_sel <= '-';                     -- dont care     
    elsif(Instr(31 downto 26) =  "110011") then             -- ori
        cloud_enable <= "00";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_WrEn <= '1';
        SIGNAL_RF_B_sel <= '-';                     -- dont care
    elsif(Instr(31 downto 26) =  "111111") then             -- B
        cloud_enable <= "11";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_WrEn <= '0';
        SIGNAL_RF_B_sel <= '-';                    -- dont care
    elsif(Instr(31 downto 26) =  "010000") then             -- beq
        if(RF_A_signal = RF_B_signal) then
            cloud_enable <= "11";
            SIGNAL_PC_SEL <= '1';
        else
            SIGNAL_PC_SEL <= '0';
        end if;
        SIGNAL_RF_WrEn <= '0';
        SIGNAL_RF_B_sel <= '-';                    -- dont care
    elsif(Instr(31 downto 26) =  "010001") then             -- bne
        if(RF_A_signal = RF_B_signal) then
            SIGNAL_PC_SEL <= '0';
        else
            cloud_enable <= "11";
            SIGNAL_PC_SEL <= '1';
        end if;    
        SIGNAL_RF_WrEn <= '0';
        SIGNAL_RF_B_sel <= '-';                    -- dont care
    elsif(Instr(31 downto 26) =  "000011") then             -- Lb
        SIGNAL_RF_WrEn <= '1';     
        cloud_enable <= "01";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_B_sel <= '0';                    -- Write from ALU
    elsif(Instr(31 downto 26) =  "001111") then             -- Lw
        SIGNAL_RF_WrEn <= '1';     
        cloud_enable <= "01";
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_B_sel <= '1';                    -- Write from MEM
    else
        SIGNAL_RF_WrEn <= '1';     
        cloud_enable <= "01";                               -- Sb or Sw
        SIGNAL_PC_SEL <= '0';
        SIGNAL_RF_B_sel <= '-';                    -- dont care @TODO ???
    end if;
end if;   
           
end process;    

DEC_PC_SEL <= SIGNAL_PC_SEL;

end Behavioral;