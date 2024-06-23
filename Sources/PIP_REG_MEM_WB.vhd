library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIP_REG_MEM_WB is
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
end PIP_REG_MEM_WB;

architecture Behavioral of PIP_REG_MEM_WB is

SIGNAL SIGNAL_MEM_ADDR      : STD_LOGIC_VECTOR(31 downto 0)     := "00000000000000000000000000000000";
SIGNAL SIGNAL_MEM_DATA      : STD_LOGIC_VECTOR(31 downto 0)     := "00000000000000000000000000000000";
SIGNAL SIGNAL_DEST          : STD_LOGIC_VECTOR(4 downto 0)      := "00000";

-- Control Signals
SIGNAL SIGNAL_CTRL_EX   : STD_LOGIC := '0';

begin
process
begin
    wait until CLK'event and CLK='1';	
    
    SIGNAL_MEM_ADDR <= MEM_ADDERSS_IN;
    SIGNAL_MEM_DATA <= MEM_DATA_IN;
    SIGNAL_DEST     <= DESTINATION_IN;
    
       -- Control Signals     
     SIGNAL_CTRL_EX  <= EX_IN;
            
end process;

    MEM_ADDERSS_OUT <= SIGNAL_MEM_ADDR;
    MEM_DATA_OUT    <= SIGNAL_MEM_DATA;
    DESTINATION_OUT <= SIGNAL_DEST;
    
    -- Control Signals
    EX_OUT      <= SIGNAL_CTRL_EX;

end Behavioral;
