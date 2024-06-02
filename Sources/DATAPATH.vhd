library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH is
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
       
       -- Testomg Outputs
       
       TEST_INSTR   : out STD_LOGIC_VECTOR(31 downto 0);
       TEST_IMMED   : out STD_LOGIC_VECTOR(31 downto 0);      
       TEST_RFA     : out STD_LOGIC_VECTOR(31 downto 0);
       TEST_RFB     : out STD_LOGIC_VECTOR(31 downto 0);
       TEST_ALU_OUT : out STD_LOGIC_VECTOR(31 downto 0);     
       TEST_MEM_OUT : out STD_LOGIC_VECTOR(31 downto 0)
  );
end DATAPATH;

architecture Behavioral of DATAPATH is

component IFSTAGE is
    Port ( 
       PC_Immed     : in  STD_LOGIC_VECTOR (31 downto 0);
       PC_sel       : in  STD_LOGIC;
       PC_LdEn      : in  STD_LOGIC;
       Reset        : in  STD_LOGIC;
       Clk          : in  STD_LOGIC;
       Instr        : out  STD_LOGIC_VECTOR (31 downto 0)
   );
end component;

component DEC_STAGE is
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
end component;

component EX_STAGE is
     Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
            RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
            Immed : in  STD_LOGIC_VECTOR (31 downto 0);
            ALU_Bin_sel : in STD_LOGIC;
            ALU_func : in STD_LOGIC_VECTOR (3 downto 0);
            ALU_out : out STD_LOGIC_VECTOR (31 downto 0)
     );
end component;

component MEM_STAGE is
    Port ( clk : in STD_LOGIC;
           Mem_WrEn : in STD_LOGIC;
           ALU_MEM_Addr : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

-- SIGNALS

-- Exec_stage related signals
signal ALU_out_signal : std_logic_vector(31 downto 0);
signal ALU_func_signal : std_logic_vector(3 downto 0);

-- Mem_stage related signals
signal MEM_Dataout_signal : std_logic_vector(31 downto 0);

-- Dec_stage related signals
signal Instr_signal : std_logic_vector(31 downto 0);
signal RF_A_signal : std_logic_vector(31 downto 0);
signal RF_B_signal : std_logic_vector(31 downto 0);
signal Immed_signal : std_logic_vector(31 downto 0);

begin

IFS : IFSTAGE PORT MAP(
      PC_Immed => Immed_signal,
      PC_sel => PC_sel,
      PC_LdEn => PC_LdEn,
      Reset => Datapath_Reset,
      Clk => Datapath_Clk,
      Instr => Instr_signal
--    Instr => INSTR_TRPL_BYPASS
);

DECS : DEC_STAGE PORT MAP (
    Clk => Datapath_Clk,
   -- Instr => Instr_signal,
    Instr => Instruction_BYPASS_IF,  --SSSSSS
--    RF_WrEn => RF_WrEn,              --SSSSSS           
    ALU_out => ALU_out_signal,
    MEM_out => MEM_Dataout_signal,
--    RF_WrData_sel => RF_WrData_sel,  --SSSSSS
--    RF_B_sel => RF_B_sel,            --SSSSSSS
--    cloud_enable => cloud_enable,    --SSSSSS
    Reset => Datapath_Reset,         --SSSSSS
    Immed => Immed_signal,           --SSSSSS 
    RF_A => RF_A_signal,
    RF_B => RF_B_signal   
);

EXECS : EX_STAGE PORT MAP (
    RF_A => RF_A_signal,
    RF_B => RF_B_signal,
    Immed => Immed_signal,
    ALU_Bin_sel => ALU_Bin_sel,
    ALU_func => ALU_func,
    ALU_out => ALU_out_signal
);

MEMS : MEM_STAGE PORT MAP (
   clk => Datapath_Clk,
   Mem_WrEn => Mem_WrEn,
   ALU_MEM_Addr => ALU_out_signal,
   MEM_DataIn => RF_B_signal,                       
   MEM_DataOut => MEM_Dataout_signal
);

TEST_INSTR   <= Instruction_BYPASS_IF;
--TEST_INSTR   <= Instr_signal;
TEST_IMMED   <= Immed_signal;
TEST_RFA     <= RF_A_signal;
TEST_RFB     <= RF_B_signal;
TEST_ALU_OUT <= ALU_OUT_SIGNAL;
TEST_MEM_OUT <= MEM_Dataout_signal;

end Behavioral;