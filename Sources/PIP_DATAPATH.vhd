library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIP_DATAPATH is
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
                  
         Instruction_control : out STD_LOGIC_VECTOR(31 downto 0)                         
  );
end PIP_DATAPATH;

architecture Behavioral of PIP_DATAPATH is

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

component PIP_REG_IF_DEC is
  Port (
    CLK             : in STD_LOGIC;
  
    INST_PC_IN      : in STD_LOGIC_VECTOR(31 downto 0);
    INST_PC4_IN     : in STD_LOGIC_VECTOR(31 downto 0);
    
    INST_PC_OUT     : out STD_LOGIC_VECTOR(31 downto 0);
    INST_PC4_OUT    : out STD_LOGIC_VECTOR(31 downto 0)
  );
end component;

component PIP_REG_DEC_EX is
  Port (
    CLK             : in STD_LOGIC;
  
    INST_PC4_IN     : in STD_LOGIC_VECTOR(31 downto 0);
    INST_PC4_OUT    : out STD_LOGIC_VECTOR(31 downto 0);
    
    RF_A_IN         : in STD_LOGIC_VECTOR(31 downto 0);
    RF_A_OUT        : out STD_LOGIC_VECTOR(31 downto 0);
    
    RF_B_IN         : in STD_LOGIC_VECTOR(31 downto 0);
    RF_B_OUT        : out STD_LOGIC_VECTOR(31 downto 0);
    
    IMMED_IN        : in STD_LOGIC_VECTOR(31 downto 0);
    IMMED_OUT       : out STD_LOGIC_VECTOR(31 downto 0);
    
    RD_IN           : in STD_LOGIC_VECTOR(15 downto 0);
    RD_OUT          : out STD_LOGIC_VECTOR(15 downto 0);
    
    RT_IN           : in STD_LOGIC_VECTOR(31 downto 0);
    RT_OUT          : out STD_LOGIC_VECTOR(31 downto 0);
    
    -- Control Signals
    
    WB_IN       : in STD_LOGIC;
    WB_OUT      : out STD_LOGIC;
    
    M_IN        : in STD_LOGIC;
    M_OUT       : out STD_LOGIC; 
    
    EX_IN       : in STD_LOGIC;
    EX_OUT      : out STD_LOGIC
        
  );
end component;

component PIP_REG_EX_MEM is
  Port (
    CLK             : in STD_LOGIC;
  
    ALU_RES_IN      : in STD_LOGIC_VECTOR(31 downto 0);
    ALU_RES_OUT     : out STD_LOGIC_VECTOR(31 downto 0);
    
    ALU_ZERO_IN     : in STD_LOGIC_VECTOR(31 downto 0);
    ALU_ZERO_OUT    : out STD_LOGIC_VECTOR(31 downto 0);
    
    RF_B_IN         : in STD_LOGIC_VECTOR(31 downto 0);
    RF_B_OUT        : out STD_LOGIC_VECTOR(31 downto 0);
    
    BRANCH_PLCH_IN  : in STD_LOGIC_VECTOR(31 downto 0);         -- For Branch
    BRANCH_PLCH_OUT : out STD_LOGIC_VECTOR(31 downto 0);        -- For Branch
    
    RD_IN           : in STD_LOGIC_VECTOR(4 downto 0);
    RD_OUT          : out STD_LOGIC_VECTOR(4 downto 0);
    
    RT_IN           : in STD_LOGIC_VECTOR(4 downto 0);
    RT_OUT          : out STD_LOGIC_VECTOR(4 downto 0);
    
    -- Control Signals
    
    WB_IN       : in STD_LOGIC;
    WB_OUT      : out STD_LOGIC;
    
    M_IN        : in STD_LOGIC;
    M_OUT       : out STD_LOGIC
    
  );
end component;

component PIP_REG_MEM_WB is
  Port (
    CLK                 : in STD_LOGIC;
  
    MEM_ADDERSS_IN      : in STD_LOGIC_VECTOR(31 downto 0);
    MEM_ADDERSS_OUT     : out STD_LOGIC_VECTOR(31 downto 0);
    
    MEM_DATA_IN         : in STD_LOGIC_VECTOR(31 downto 0);
    MEM_DATA_OUT        : out STD_LOGIC_VECTOR(31 downto 0);
    
    DESTINATION_IN      : in STD_LOGIC_VECTOR(4 downto 0);
    DESTINATION_OUT     : out STD_LOGIC_VECTOR(4 downto 0);
    
    -- Control Signals
    
    EX_IN       : in STD_LOGIC;
    EX_OUT      : out STD_LOGIC
               
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

-- Pipeline Related Signals

SIGNAL SIG_PIP_IF_DEC_INSTR_OUT : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";

SIGNAL SIG_PIP_DEX_EXEC_ALU_OUT : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
SIGNAL SIG_PIP_DEC_EX_IMMED : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
SIGNAL SIG_PIP_DEC_EX_RF_A : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
SIGNAL SIG_PIP_DEC_EX_RF_B : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";

SIGNAL SIG_PIP_MEM_WB_DATA_OUT : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";

SIGNAL SIG_PIP_IF_DEC_INSTR_OUT2 : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";


begin

IFS : IFSTAGE PORT MAP(
      PC_Immed => Immed_signal,
      PC_sel => PC_sel,
      PC_LdEn => PC_LdEn,
      Reset => Datapath_Reset,
      Clk => Datapath_Clk,
      Instr => Instr_signal
);
-------------------------------------------------------------

IFDEC_REG : PIP_REG_IF_DEC PORT MAP(
    CLK             => Datapath_Clk,
  
    INST_PC_IN      => Instr_signal,
    INST_PC4_IN     => "00000000000000000000000000000000",            -- FIX DIS
    
    INST_PC_OUT     => SIG_PIP_IF_DEC_INSTR_OUT,
    INST_PC4_OUT    => "00000000000000000000000000000000"
);

DECS : DEC_STAGE PORT MAP (
    Clk => Datapath_Clk,
    Instr => SIG_PIP_IF_DEC_INSTR_OUT,
    RF_WrEn => RF_WrEn,                         
    ALU_out => SIG_PIP_DEX_EXEC_ALU_OUT,
    MEM_out => SIG_PIP_MEM_WB_DATA_OUT,
    RF_WrData_sel => RF_WrData_sel,  
    RF_B_sel => RF_B_sel,            
    cloud_enable => cloud_enable,    
    Reset => Datapath_Reset,         
    Immed => SIG_PIP_DEC_EX_IMMED,           
    RF_A => SIG_PIP_DEC_EX_RF_A,
    RF_B => SIG_PIP_DEC_EX_RF_B   
);

DECEX_REG : PIP_REG_DEX_EX PORT MAP (
    CLK          => Datapath_Clk,
  
    INST_PC4_IN     => "00000000000000000000000000000000",
    INST_PC4_OUT    => "00000000000000000000000000000000",
    
    RF_A_IN         : in STD_LOGIC_VECTOR(31 downto 0);
    RF_A_OUT        : out STD_LOGIC_VECTOR(31 downto 0);
    
    RF_B_IN         : in STD_LOGIC_VECTOR(31 downto 0);
    RF_B_OUT        : out STD_LOGIC_VECTOR(31 downto 0);
    
    IMMED_IN        : in STD_LOGIC_VECTOR(31 downto 0);
    IMMED_OUT       : out STD_LOGIC_VECTOR(31 downto 0);
    
    RD_IN           : in STD_LOGIC_VECTOR(15 downto 0);
    RD_OUT          : out STD_LOGIC_VECTOR(15 downto 0);
    
    RT_IN           : in STD_LOGIC_VECTOR(31 downto 0);
    RT_OUT          : out STD_LOGIC_VECTOR(31 downto 0);
    
    -- Control Signals
    
    WB_IN       : in STD_LOGIC;
    WB_OUT      : out STD_LOGIC;
    
    M_IN        : in STD_LOGIC;
    M_OUT       : out STD_LOGIC; 
    
    EX_IN       : in STD_LOGIC;
    EX_OUT      : out STD_LOGIC
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
MEMS : MEM_STAGE PORT MAP (
   clk => Datapath_Clk,
   Mem_WrEn => Mem_WrEn,
   ALU_MEM_Addr => ALU_out_REG_signal,
   MEM_DataIn => RF_B_REG_signal,                       
   MEM_DataOut => MEM_Dataout_signal
);

--Outputs
Instruction_control <= Instr_REG_signal;
end Behavioral;
