LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IFSTAGE_tb IS
END IFSTAGE_tb;
 
ARCHITECTURE behavior OF IFSTAGE_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT IFSTAGE is
    Port ( 
       PC_Immed     : in  STD_LOGIC_VECTOR (31 downto 0);
       PC_sel       : in  STD_LOGIC;
       PC_LdEn      : in  STD_LOGIC;
       Reset        : in  STD_LOGIC;
       Clk          : in  STD_LOGIC;
       Instr        : out STD_LOGIC_VECTOR (31 downto 0);
       
       -- Testing
      memIn        : out  STD_LOGIC_VECTOR (31 downto 0); 
      muxOut       : out  STD_LOGIC_VECTOR (31 downto 0); 
      muxA         : out  STD_LOGIC_VECTOR (31 downto 0);
      muxB         : out  STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;
    

   --Inputs
   SIGNAL PC_Immed : std_logic_vector(31 downto 0) := (others => '0');
   SIGNAL PC_sel : std_logic;
   SIGNAL PC_LdEn : std_logic;
   SIGNAL RESET : std_logic;
   SIGNAL Clk : std_logic;
   
   
 	--Outputs
   SIGNAL Instr : std_logic_vector(31 downto 0);
   
   -- Testing
   SIGNAL memIn : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL muxOut : STD_LOGIC_VECTOR (31 downto 0); 
   SIGNAL muxA  : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL muxB  : STD_LOGIC_VECTOR (31 downto 0);
   
   CONSTANT CLK_period : time := 100 ns;
 
BEGIN
 
-- Instantiate the Unit Under Test (UUT)
uut: IFSTAGE PORT MAP (
      PC_Immed      => PC_Immed,
      PC_sel        => PC_sel,
      PC_LdEn       => PC_LdEn,
      RESET         => RESET,
      Clk           => Clk,
      Instr         => Instr,
      
      -- Testing
      memIn         => memIn,
      muxOut        => muxOut,
      muxA          => muxA,
      muxb          => muxb
    );
 
-- Clock process
CLK_process: process
begin
  CLK <= '0';
  wait for CLK_period/2;
  CLK <= '1';
  wait for CLK_period/2;
end process;
 
	
 

-- Stimulus process
stim_proc: process
begin		
    -- Init
    PC_Immed <= "00000000000000000000000000001111";
    PC_sel <= '0';
    PC_LdEn <= '0';
    RESET <= '1';
    wait for CLK_period;
    
    -- PC_Lden = 1 && PC_sel = 1 -- PC+4+PC_Immed option
    PC_Immed <= "00000000000000000000000000001111";
    PC_sel <= '1';
    PC_LdEn <= '1';
    RESET <= '0';
    wait for CLK_period;
    wait for CLK_period;

    
    -- PC_Lden = 1 && PC_sel = 1 -- PC+4+PC_Immed option
    PC_Immed <= "00000000000000000000000011110000";
    PC_sel <= '1';
    PC_LdEn <= '0';
    RESET <= '0';
    wait for CLK_period;
    wait for CLK_period;
    
    -- PC_LdEn = 0 should take previous PC+4+Immed
    PC_Immed <= "00000000000000000000000000001111";
    PC_sel <= '0';
    PC_LdEn <= '1';
    RESET <= '0';
    wait for CLK_period;
    wait for CLK_period;
--    wait for CLK_period;
    
    -- PC_Lden = 1 && PC_sel = 0 -- PC+4 option
    PC_Immed <= "00000000000000000000000000001111";
    PC_sel <= '0';
    PC_LdEn <= '1';
    RESET <= '1';
    wait for CLK_period;
--    wait for CLK_period;
--    wait for CLK_period;

    -- PC_Lden = 1 && PC_sel = 0 -- PC+4 option
PC_Immed <= "00000000000000000000000000000000";
PC_sel <= '0';
PC_LdEn <= '1';
RESET <= '0';
wait for CLK_period;
    wait for CLK_period;
    wait for CLK_period;

    
    wait;
end process;

END;
