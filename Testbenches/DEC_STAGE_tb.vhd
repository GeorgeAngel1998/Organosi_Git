LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DEC_STAGE_tb IS
END DEC_STAGE_tb;
 
ARCHITECTURE behavior OF DEC_STAGE_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT DEC_STAGE is
    Port ( Clk : in  STD_LOGIC;
           Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
--           RF_B_sel : in  STD_LOGIC;
--           cloud_enable : in  STD_LOGIC_VECTOR (1 downto 0);
           Reset : in STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);     
           
           DEC_IMMED : out STD_LOGIC;
           DEC_PC_SEL : out STD_LOGIC;      
           
           --Testing Outputs
           TEST_Ard1_out : out STD_LOGIC_VECTOR(4 downto 0);
           TEST_Ard2_out : out STD_LOGIC_VECTOR(4 downto 0);
           TEST_Awr_out : out STD_LOGIC_VECTOR(4 downto 0)
       );
end COMPONENT;
    
   --Inputs
   SIGNAL Clk : std_logic;
   SIGNAL Instr : std_logic_vector(31 downto 0) := (others => '0');
   SIGNAL RF_WrEn : std_logic;
   SIGNAL ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   SIGNAL MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   SIGNAL RF_WrData_sel : std_logic;
--   SIGNAL RF_B_sel : std_logic;
--   SIGNAL cloud_enable : std_logic_vector(1 downto 0) := (others => '0');
   SIGNAL Reset : std_logic;
   
   SIGNAL SIGNAL_DEC_IMMED : std_logic;
   SIGNAL SIGNAL_DEC_PC_SEL : std_logic;

   --Outputs
    SIGNAL TEST_Ard1_out : STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL TEST_Ard2_out : STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL TEST_Awr_out : STD_LOGIC_VECTOR(4 downto 0);
   
   SIGNAL Immed : std_logic_vector(31 downto 0);
   SIGNAL RF_A : std_logic_vector(31 downto 0);
   SIGNAL RF_B : std_logic_vector(31 downto 0);
   
   CONSTANT CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DEC_STAGE PORT MAP (
          Clk => Clk,
          Instr => Instr,
--          RF_B_sel => RF_B_sel,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,       
--          cloud_enable => cloud_enable,       
          Reset => Reset,
          
          TEST_Ard1_out => TEST_Ard1_out,
          TEST_Ard2_out => TEST_Ard2_out,
          TEST_Awr_out => TEST_Awr_out,
          
            DEC_IMMED => SIGNAL_DEC_IMMED,
            DEC_PC_SEL => SIGNAL_DEC_PC_SEL,     
          
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B
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
   		
   		--
		Instr <= "11100000000000010000000000000011";              -- li R1 3
		RF_WrEn <= '1';
		ALU_out <= "11111111000000000000000011111111";
		MEM_out <= "00000000111111111111111100000000";
		RF_WrData_sel <= '1';
--		RF_B_sel <= '0';
--		cloud_enable <= "00";
		Reset <= '0';
      wait for CLK_period;
      
      	Instr <= "11100000000000100000000000000010";             -- Li R2 2
		RF_WrEn <= '0';
		ALU_out <= "11111111000000000000000011111111";
		MEM_out <= "00000000111111111111111100000000";
		RF_WrData_sel <= '1';
--		RF_B_sel <= '0';
--		cloud_enable <= "11";
		Reset <= '0';
        wait for CLK_period;
      
        Instr <= "11100000000001100000000000000011";             -- Li R3 3
        RF_WrEn <= '0';
        ALU_out <= "11111111000000000000000011111111";
        MEM_out <= "00000000111111111111111100000000";
        RF_WrData_sel <= '1';
        --        RF_B_sel <= '0';
        --        cloud_enable <= "11";
        Reset <= '0';
        wait for CLK_period;
      
        Instr <= "10000000001000110001000000000000";            -- add R1 R2
		RF_WrEn <= '1';
		ALU_out <= "11111111000000000000000011111111";
		MEM_out <= "00000000111111111111111100000000";
		RF_WrData_sel <= '0';
--		RF_B_sel <= '0';
--		cloud_enable <= "11";
		Reset <= '0';
      wait for CLK_period;
      
      Instr <= "01000100011000110000000000000000";              -- Beq
      RF_WrEn <= '1';
      ALU_out <= "11111111000000000000000011111111";
      MEM_out <= "00000000111111111111111100000000";
      RF_WrData_sel <= '0';
--      RF_B_sel <= '0';
--      cloud_enable <= "11";
      Reset <= '0';
    wait for CLK_period;
      
      wait;
   end process;

END;
