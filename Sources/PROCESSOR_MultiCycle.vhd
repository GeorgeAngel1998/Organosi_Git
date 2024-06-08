
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROCESSOR_MultiCycle is
    Port ( CLK : in  STD_LOGIC;
           Reset : in STD_LOGIC;
           
           --Testing Inputs
           Instruction_BYPASS_IF : in STD_LOGIC_VECTOR(31 downto 0);          
           );
end PROCESSOR_MultiCycle;

architecture Structural of PROCESSOR_MultiCycle is

-- Signals
SIGNAL Instruction_signal: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL PC_sel_signal :   STD_LOGIC;
SIGNAL PC_LdEn_signal :   STD_LOGIC;
SIGNAL RF_WrEn_signal :  STD_LOGIC;
SIGNAL RF_WrData_sel_signal :   STD_LOGIC;
SIGNAL RF_B_sel_signal :   STD_LOGIC;
SIGNAL cloud_enable_signal :  STD_LOGIC_VECTOR(1 downto 0);
SIGNAL ALU_func_signal :  STD_LOGIC_VECTOR(3 downto 0);
SIGNAL ALU_Bin_sel_signal :  STD_LOGIC;       
SIGNAL Mem_WrEn_signal :  STD_LOGIC;       
SIGNAL Instr_REG_WE_signal : STD_LOGIC;
SIGNAL RF_A_REG_WE_signal : STD_LOGIC;
SIGNAL RF_B_REG_WE_signal : STD_LOGIC;      
SIGNAL Immed_Reg_WE_signal : STD_LOGIC;
SIGNAL ALU_out_Reg_WE_signal : STD_LOGIC;
SIGNAL MEM_Dataout_REG_WE_signal : STD_LOGIC;

component CONTROL_MultiCycle is
    Port ( Instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           Control_Clk : in  STD_LOGIC;
           Control_Reset : in  STD_LOGIC;
          
           PC_sel : out  STD_LOGIC;
           PC_LdEn : out  STD_LOGIC;
           RF_WrEn : out STD_LOGIC;
           RF_WrData_sel : out  STD_LOGIC;
           RF_B_sel : out  STD_LOGIC;
           cloud_enable : out STD_LOGIC_VECTOR(1 downto 0);
           ALU_func : out STD_LOGIC_VECTOR(3 downto 0);
           ALU_Bin_sel : out STD_LOGIC;       
           Mem_WrEn : out STD_LOGIC;        
           Instr_REG_WE : out STD_LOGIC;
           RF_A_REG_WE : out STD_LOGIC;
           RF_B_REG_WE : out STD_LOGIC;      
           Immed_Reg_WE : out STD_LOGIC;
           ALU_out_Reg_WE : out STD_LOGIC;
           MEM_Dataout_REG_WE : out STD_LOGIC
           );
end component;

component DATAPATH_MultiCycle is
  Port ( Datapath_Clk : in STD_LOGIC;
         Datapath_Reset : in STD_LOGIC;
         PC_sel : in  STD_LOGIC;
         PC_LdEn : in  STD_LOGIC;
         RF_WrEn : in STD_LOGIC;
         RF_WrData_sel : in  STD_LOGIC;
         RF_B_sel : in  STD_LOGIC;
         cloud_enable : in STD_LOGIC_VECTOR(1 downto 0);
         ALU_func : in STD_LOGIC_VECTOR(3 downto 0);
         ALU_Bin_sel : in STD_LOGIC;       
         Mem_WrEn : in STD_LOGIC;
         Instruction_BYPASS_IF : in STD_LOGIC_VECTOR(31 downto 0);
         
         Instr_REG_WE : in STD_LOGIC;
         RF_A_REG_WE : in STD_LOGIC;
         RF_B_REG_WE : in STD_LOGIC;      
         Immed_Reg_WE : in STD_LOGIC;
         ALU_out_Reg_WE : in STD_LOGIC;
         MEM_Dataout_REG_WE : in STD_LOGIC;
         
         -- Testing Outputs
         TEST_INSTR   : out STD_LOGIC_VECTOR(31 downto 0);
         TEST_IMMED   : out STD_LOGIC_VECTOR(31 downto 0);      
         TEST_RFA     : out STD_LOGIC_VECTOR(31 downto 0);
         TEST_RFB     : out STD_LOGIC_VECTOR(31 downto 0);
         TEST_ALU_OUT : out STD_LOGIC_VECTOR(31 downto 0);     
         TEST_MEM_OUT : out STD_LOGIC_VECTOR(31 downto 0)                         
  );
end component;
			
begin

FSM: CONTROL_MultiCycle port map (  Instruction => Instruction_BYPASS_IF,
                                    Control_Clk => CLK,
                                    Control_Reset => Reset,        
                                    PC_sel => PC_sel_signal,
                                    PC_LdEn => PC_LdEn_signal,
                                    RF_WrEn => RF_WrEn_signal,
                                    RF_WrData_sel => RF_WrData_sel_signal, 
                                    RF_B_sel => RF_B_sel_signal, 
                                    cloud_enable => cloud_enable_signal,
                                    ALU_func => ALU_func_signal,
                                    ALU_Bin_sel => ALU_Bin_sel_signal,
                                    Mem_WrEn => Mem_WrEn_signal,      
                                    Instr_REG_WE => Instr_REG_WE_signal,
                                    RF_A_REG_WE => RF_A_REG_WE_signal,
                                    RF_B_REG_WE => RF_B_REG_WE_signal,      
                                    Immed_Reg_WE => Immed_Reg_WE_signal,
                                    ALU_out_Reg_WE => ALU_out_Reg_WE_signal,
                                    MEM_Dataout_REG_WE => MEM_Dataout_REG_WE_signal
                                  );
                                  
Datapath: DATAPATH_MultiCycle port map ( Datapath_Clk => CLK,
                                         Datapath_Reset => Reset,        
                                         PC_sel => PC_sel_signal,
                                         PC_LdEn => PC_LdEn_signal,
                                         RF_WrEn => RF_WrEn_signal,
                                         RF_WrData_sel => RF_WrData_sel_signal, 
                                         RF_B_sel => RF_B_sel_signal, 
                                         cloud_enable => cloud_enable_signal,
                                         ALU_func => ALU_func_signal,
                                         ALU_Bin_sel => ALU_Bin_sel_signal,
                                         Mem_WrEn => Mem_WrEn_signal,
                                         
                                         --Instruction_BYPASS_IF => Instruction_signal,
                                         Instruction_BYPASS_IF => Instruction_BYPASS_IF,
                                               
                                         Instr_REG_WE => Instr_REG_WE_signal,
                                         RF_A_REG_WE => RF_A_REG_WE_signal,
                                         RF_B_REG_WE => RF_B_REG_WE_signal,      
                                         Immed_Reg_WE => Immed_Reg_WE_signal,
                                         ALU_out_Reg_WE => ALU_out_Reg_WE_signal,
                                         MEM_Dataout_REG_WE => MEM_Dataout_REG_WE_signal
                                       );                                

end Structural;
