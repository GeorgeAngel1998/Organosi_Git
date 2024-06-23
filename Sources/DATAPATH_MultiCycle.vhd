library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH_MultiCycle is
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
         Mem_WrEn : in STD_LOGIC_VECTOR(2 downto 0);
         
         Instr_REG_WE : in STD_LOGIC;
         RF_A_REG_WE : in STD_LOGIC;
         RF_B_REG_WE : in STD_LOGIC;      
         Immed_Reg_WE : in STD_LOGIC;
         ALU_out_Reg_WE : in STD_LOGIC;
         MEM_Dataout_REG_WE : in STD_LOGIC;
         
         Instruction_control : out STD_LOGIC_VECTOR(31 downto 0)                         
  );
end DATAPATH_MultiCycle;

architecture Behavioral of DATAPATH_MultiCycle is

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
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           cloud_enable : in  STD_LOGIC_VECTOR(1 downto 0);
           Reset : in STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0)
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
           Mem_WrEn : in STD_LOGIC_VECTOR(2 downto 0);
           ALU_MEM_Addr : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Registers is
    Port (
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        WE : in  STD_LOGIC;
        Data : in  STD_LOGIC_VECTOR (31 downto 0);
        Dout : out  STD_LOGIC_VECTOR (31 downto 0)
    );
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

-- Registers MultiCycle related signals
signal Instr_REG_signal : std_logic_vector(31 downto 0);
signal ALU_out_REG_signal : std_logic_vector(31 downto 0);
signal Immed_REG_signal : std_logic_vector(31 downto 0);
signal RF_A_REG_signal : std_logic_vector(31 downto 0);
signal RF_B_REG_signal : std_logic_vector(31 downto 0);
signal MEM_Dataout_REG_signal : std_logic_vector(31 downto 0);

begin

IFS : IFSTAGE PORT MAP(
      PC_Immed => Immed_REG_signal,
      PC_sel => PC_sel,
      PC_LdEn => PC_LdEn,
      Reset => Datapath_Reset,
      Clk => Datapath_Clk,
      Instr => Instr_signal
);
-------------------------------------------------------------

Reg_Instr: Registers PORT MAP(
	CLK => Datapath_Clk,
	WE => Instr_REG_WE,
	Data => Instr_signal,
	RST => Datapath_Reset,
	Dout => Instr_REG_signal
);

-------------------------------------------------------------
DECS : DEC_STAGE PORT MAP (
    Clk => Datapath_Clk,
    Instr => Instr_REG_signal,
    --Instr => Instruction_BYPASS_IF, 
    RF_WrEn => RF_WrEn,                         
    ALU_out => ALU_out_signal,
    MEM_out => MEM_Dataout_REG_signal,
    RF_WrData_sel => RF_WrData_sel,  
    RF_B_sel => RF_B_sel,            
    cloud_enable => cloud_enable,    
    Reset => Datapath_Reset,         
    Immed => Immed_signal,           
    RF_A => RF_A_signal,
    RF_B => RF_B_signal   
);
-------------------------------------------------------------

Reg_RF_A: Registers PORT MAP(
	CLK => Datapath_Clk,
	WE => RF_A_REG_WE,
	Data => RF_A_signal,
	RST => Datapath_Reset,
	Dout => RF_A_REG_signal
);

Reg_RF_B: Registers PORT MAP(
	CLK => Datapath_Clk,
	WE => RF_B_REG_WE,
	Data => RF_B_signal,
	RST => Datapath_Reset,
	Dout => RF_B_REG_signal
);

Reg_Immed: Registers PORT MAP(
	CLK => Datapath_Clk,
	WE => Immed_Reg_WE,
	Data => Immed_signal,
	RST => Datapath_Reset,
	Dout => Immed_REG_signal
);

-------------------------------------------------------------
EXECS : EX_STAGE PORT MAP (
    RF_A => RF_A_REG_signal,
    RF_B => RF_B_REG_signal,
    Immed => Immed_REG_signal,
    ALU_Bin_sel => ALU_Bin_sel,
    ALU_func => ALU_func,
    ALU_out => ALU_out_signal
);
-------------------------------------------------------------

Reg_ALU_out: Registers PORT MAP(
	CLK => Datapath_Clk,
	WE => ALU_out_Reg_WE,
	Data => ALU_out_signal,
	RST => Datapath_Reset,
	Dout => ALU_out_REG_signal
);

-------------------------------------------------------------
MEMS : MEM_STAGE PORT MAP (
   clk => Datapath_Clk,
   Mem_WrEn => Mem_WrEn,
   ALU_MEM_Addr => ALU_out_REG_signal,
   MEM_DataIn => RF_B_REG_signal,                       
   MEM_DataOut => MEM_Dataout_signal
);
-------------------------------------------------------------

Reg_MEM_Dataout: Registers PORT MAP(
	CLK => Datapath_Clk,
	WE => MEM_Dataout_REG_WE,
	Data => MEM_Dataout_signal,
	RST => Datapath_Reset,
	Dout => MEM_Dataout_REG_signal
);

--Outputs
Instruction_control <= Instr_REG_signal;
end Behavioral;
