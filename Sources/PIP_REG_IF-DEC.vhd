library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIP_REG_IF_DEC is
  Port (
    CLK             : in STD_LOGIC;
  
    INST_PC_IN      : in STD_LOGIC_VECTOR(31 downto 0);
    INST_PC4_IN     : in STD_LOGIC_VECTOR(31 downto 0);
    
    INST_PC_OUT     : out STD_LOGIC_VECTOR(31 downto 0);
    INST_PC4_OUT    : out STD_LOGIC_VECTOR(31 downto 0)
  );
end PIP_REG_IF_DEC;

architecture Behavioral of PIP_REG_IF_DEC is

SIGNAL SIGNAL_PC    : STD_LOGIC_VECTOR(31 downto 0)     := "00000000000000000000000000000000";
SIGNAL SIGNAL_PC4   : STD_LOGIC_VECTOR(31 downto 0)     := "00000000000000000000000000000000";

begin
process
begin
    wait until CLK'event and CLK='1';	
    
    SIGNAL_PC <= INST_PC_IN;
    SIGNAL_PC4 <= INST_PC4_IN;
end process;

    INST_PC_OUT     <= SIGNAL_PC;
    INST_PC4_OUT    <= SIGNAL_PC4;

end Behavioral;
