library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIP_REG_EX_MEM is
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
    RT_OUT          : out STD_LOGIC_VECTOR(4 downto 0)
        
  );
end PIP_REG_EX_MEM;

architecture Behavioral of PIP_REG_EX_MEM is

SIGNAL SIGNAL_PLCH          : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_ALU_RES       : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_ALU_ZER       : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_RF_B          : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_RD            : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL SIGNAL_RT            : STD_LOGIC_VECTOR(4 downto 0);


begin
process
begin
    wait until CLK'event and CLK='1';	
    
    SIGNAL_PLCH     <= BRANCH_PLCH_IN;
    SIGNAL_ALU_RES  <= ALU_RES_IN;
    SIGNAL_ALU_ZER  <= ALU_ZERO_IN;
    SIGNAL_RD       <= RD_IN;
    SIGNAL_RT       <= RT_IN;
            
end process;

    BRANCH_PLCH_OUT <= SIGNAL_PLCH;
    ALU_RES_OUT     <= SIGNAL_ALU_RES;
    ALU_ZERO_OUT    <= SIGNAL_ALU_ZER;
    RF_B_OUT        <= SIGNAL_RF_B;
    RD_OUT          <= SIGNAL_RD;
    RT_OUT          <= SIGNAL_RT;
    
end Behavioral;
