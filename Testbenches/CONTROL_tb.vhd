LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CONTROL_tb IS
END CONTROL_tb;
 
ARCHITECTURE behavior OF CONTROL_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT CONTROL is
    Port ( Instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           Control_CLK : in  STD_LOGIC;
           Control_Reset : in  STD_LOGIC;

           PC_sel : out  STD_LOGIC;
           PC_LdEn : out  STD_LOGIC;
           RF_WrEn : out  STD_LOGIC;
           RF_WrData_sel : out  STD_LOGIC;
           RF_B_sel : out  STD_LOGIC;        
           cloud_enable : out  STD_LOGIC_VECTOR (1 downto 0);
           ALU_func : out  STD_LOGIC_VECTOR (3 downto 0);
           ALU_bin_sel : out  STD_LOGIC;
           Mem_WrEn : out  STD_LOGIC;
           
           testing_Opcode : out STD_LOGIC_VECTOR(5 downto 0);
           testing_Rs : out STD_LOGIC_VECTOR(4 downto 0);
           testing_Rd : out STD_LOGIC_VECTOR(4 downto 0);
           testing_Rt : out STD_LOGIC_VECTOR(4 downto 0);
           testing_Immediate : out STD_LOGIC_VECTOR(15 downto 0)
		 --  Mem_ReadEn : out STD_LOGIC_VECTOR(3 downto 0);
           );
end COMPONENT;
    
   --Inputs
   SIGNAL Control_CLK : std_logic;
   SIGNAL Control_Reset : std_logic;
   SIGNAL Instruction : STD_LOGIC_VECTOR(31 downto 0);

   --Outputs
   SIGNAL PC_sel : STD_LOGIC;
   SIGNAL PC_LdEn : STD_LOGIC;
   SIGNAL RF_WrEn : STD_LOGIC;
   SIGNAL RF_WrData_sel : STD_LOGIC;
   SIGNAL RF_B_sel : STD_LOGIC;        
   SIGNAL cloud_enable : STD_LOGIC_VECTOR (1 downto 0);
   SIGNAL ALU_func : STD_LOGIC_VECTOR (3 downto 0);
   SIGNAL ALU_bin_sel : STD_LOGIC;
   SIGNAL Mem_WrEn : STD_LOGIC;
           
   SIGNAL testing_Opcode : STD_LOGIC_VECTOR(5 downto 0);
   SIGNAL testing_Rs : STD_LOGIC_VECTOR(4 downto 0);
   SIGNAL testing_Rd : STD_LOGIC_VECTOR(4 downto 0);
   SIGNAL testing_Rt : STD_LOGIC_VECTOR(4 downto 0);
   SIGNAL testing_Immediate : STD_LOGIC_VECTOR(15 downto 0);   

    
   CONSTANT CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL PORT MAP (
     Control_CLK => Control_CLK,
     Control_Reset => Control_Reset,
     Instruction => Instruction,
     PC_sel => PC_sel,
     PC_LdEn => PC_LdEn,
     RF_WrEn => RF_WrEn,
     RF_WrData_sel => RF_WrData_sel,
     RF_B_sel => RF_B_sel,    
     cloud_enable => cloud_enable,
     ALU_func => ALU_func,
     ALU_bin_sel => ALU_bin_sel,
     Mem_WrEn => Mem_WrEn,    
     testing_Opcode => testing_Opcode,
     testing_Rs => testing_Rs,
     testing_Rd => testing_Rd,
     testing_Rt => testing_Rt,
     testing_Immediate => testing_Immediate
     );
 
 -- Clock process
CLK_process: process
begin
  CONTROL_Clk <= '0';
  wait for CLK_period/2;
  CONTROL_Clk <= '1';
  wait for CLK_period/2;
end process;
 
   -- Stimulus process
   stim_proc: process
   begin
      
      Control_Reset <= '0';
      Instruction <= "11100000000000010000000000000110";  --li r1 = 6
      wait for CLK_period;
      
      Control_Reset <= '0';
      Instruction <= "11100000000000100000000000000110"; --li r2 = 6
      wait for CLK_period;
       
      Control_Reset <= '0';
      Instruction <= "10000000001000110001000000110000"; --add r3 = r1 + r2
      wait for CLK_period;
      
      wait;
   end process;

END;