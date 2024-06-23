library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIP_REG_DEC_EX is
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
    RT_OUT          : out STD_LOGIC_VECTOR(31 downto 0)
        
  );
end PIP_REG_DEC_EX;

architecture Behavioral of PIP_REG_DEC_EX is

SIGNAL SIGNAL_PC4   : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_RF_A         : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_RF_B         : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_IMMED        : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SIGNAL_RD           : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL SIGNAL_RT           : STD_LOGIC_VECTOR(4 downto 0);


begin
process
begin
    wait until CLK'event and CLK='1';	
    
    SIGNAL_PC4      <= INST_PC4_IN;
    SIGNAL_RF_A     <= RF_A_IN;
    SIGNAL_RF_B     <= RF_B_IN;
    SIGNAL_IMMED    <= IMMED_IN;
    SIGNAL_RD       <= RD_IN;
    SIGNAL_RT       <= RT_IN;
            
end process;

    INST_PC4_OUT    <= SIGNAL_PC4;
    RF_A_OUT        <= SIGNAL_RF_A;
    RF_B_OUT        <= SIGNAL_RF_B;
    IMMED_OUT       <= SIGNAL_IMMED;
    RD_OUT          <= SIGNAL_RD;
    RT_OUT          <= SIGNAL_RT;
    

end Behavioral;
