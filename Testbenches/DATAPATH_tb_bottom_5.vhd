LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DATAPATH_tb_bottom_5 IS
END DATAPATH_tb_bottom_5;
 
ARCHITECTURE behavior OF DATAPATH_tb_bottom_5 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT DATAPATH is
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
end COMPONENT;
    
   --Inputs
   SIGNAL Datapath_Clk : std_logic;
   SIGNAL Datapath_Reset : std_logic;
   SIGNAL PC_sel : std_logic;
   SIGNAL PC_LdEn : std_logic;
   SIGNAL RF_WrEn : std_logic;
   SIGNAL RF_WrData_sel : std_logic;
   SIGNAL RF_B_sel : std_logic;
   SIGNAL cloud_enable : std_logic_vector(1 downto 0);
   SIGNAL ALU_Bin_sel : std_logic;
   SIGNAL ALU_func : STD_LOGIC_VECTOR(3 downto 0);
   SIGNAL Mem_WrEn : std_logic;
   SIGNAL Instruction_BYPASS_IF : STD_LOGIC_VECTOR(31 downto 0);

   --Outputs            
    SIGNAL   TEST_INSTR   : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL   TEST_IMMED   : STD_LOGIC_VECTOR(31 downto 0);  
    
    SIGNAL   TEST_RFA     : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL   TEST_RFB     : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL   TEST_ALU_OUT : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL   TEST_MEM_OUT : STD_LOGIC_VECTOR(31 downto 0);
    
   CONSTANT CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH PORT MAP (
          Datapath_Clk => Datapath_Clk,
          Datapath_Reset => Datapath_Reset,
          Instruction_BYPASS_IF => Instruction_BYPASS_IF,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          cloud_enable => cloud_enable,       
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,       
          Mem_WrEn => Mem_WrEn,
        
          TEST_INSTR => TEST_INSTR, 
          TEST_IMMED => TEST_IMMED,
          TEST_RFA   => TEST_RFA,
          TEST_RFB  => TEST_RFB,
          TEST_ALU_OUT => TEST_ALU_OUT,
          TEST_MEM_OUT => TEST_MEM_OUT
        );
 
 -- Clock process
CLK_process: process
begin
  Datapath_Clk <= '0';
  wait for CLK_period/2;
  Datapath_Clk <= '1';
  wait for CLK_period/2;
end process;
 
   -- Stimulus process
   stim_proc: process
   begin
   	
   	Datapath_Reset <= '0';  
    PC_sel       <= '0';                      -- no branch
    PC_LdEn      <= '1';                      -- enabling PC
    RF_WrEn     <= '1';                       -- We write to a register in RF
    RF_WrData_sel<= '0';                      -- We write from ALU_out
    RF_B_sel   <= '1';                        -- We use Immed
    ALU_func    <= "0000";                    -- We add the Immed to zero => Immed
    ALU_Bin_sel  <= '1';                      -- We use Immed                    
    Mem_WrEn  <= '0';                         -- We dont use the MEM
    cloud_enable <= "01";                     -- SignExtend 
    Instruction_BYPASS_IF <= "11100000000000010000000000000111";    --li R1,6      R1 = 6
    wait for CLK_period;
    
    Datapath_Reset <= '0';  
    PC_sel       <= '0';                      -- no branch
    PC_LdEn      <= '1';                      -- enabling PC
    RF_WrEn     <= '1';                       -- We write to a register in RF
    RF_WrData_sel<= '0';                      -- We write from ALU_out
    RF_B_sel   <= '0';                        -- We dont use Immed
    ALU_func    <= "1000";                    -- sra 
    ALU_Bin_sel  <= '0';                      -- We dont use Immed                    
    Mem_WrEn  <= '0';                         -- We dont use the MEM
    cloud_enable <= "01";                     -- dc 
    Instruction_BYPASS_IF <= "11100000001000100000000000001000";    --sra R2,R1      
    wait for CLK_period;
    
    Datapath_Reset <= '0';  
    PC_sel       <= '0';                      -- no branch
    PC_LdEn      <= '1';                      -- enabling PC
    RF_WrEn     <= '1';                       -- We write to a register in RF
    RF_WrData_sel<= '0';                      -- We write from ALU_out
    RF_B_sel   <= '0';                        -- We dont use Immed
    ALU_func    <= "1001";                    -- srl
    ALU_Bin_sel  <= '0';                      -- We dont use Immed                    
    Mem_WrEn  <= '0';                         -- We dont use the MEM
    cloud_enable <= "01";                     -- dc
    Instruction_BYPASS_IF <= "11100000001000110000000000001001";    --srl R3,R1      
    wait for CLK_period;
    
    Datapath_Reset <= '0';  
    PC_sel       <= '0';                      -- no branch
    PC_LdEn      <= '1';                      -- enabling PC
    RF_WrEn     <= '1';                       -- We write to a register in RF
    RF_WrData_sel<= '0';                      -- We write from ALU_out
    RF_B_sel   <= '0';                        -- We dont use Immed
    ALU_func    <= "1010";                    -- sll 
    ALU_Bin_sel  <= '0';                      -- We dont use Immed                    
    Mem_WrEn  <= '0';                         -- We dont use the MEM
    cloud_enable <= "01";                     -- dc 
    Instruction_BYPASS_IF <= "11100000001001000000000000001010";    --sll R4,R1      
    wait for CLK_period;
    
    Datapath_Reset <= '0';  
    PC_sel       <= '0';                      -- no branch
    PC_LdEn      <= '1';                      -- enabling PC
    RF_WrEn     <= '1';                       -- We write to a register in RF
    RF_WrData_sel<= '0';                      -- We write from ALU_out
    RF_B_sel   <= '0';                        -- We dont use Immed
    ALU_func    <= "1100";                    -- rol 
    ALU_Bin_sel  <= '0';                      -- We dont use Immed                    
    Mem_WrEn  <= '0';                         -- We dont use the MEM
    cloud_enable <= "01";                     -- dc 
    Instruction_BYPASS_IF <= "11100000001001010000000000001100";    --rol R5,R1      
    wait for CLK_period;
    
    Datapath_Reset <= '0';  
    PC_sel       <= '0';                      -- no branch
    PC_LdEn      <= '1';                      -- enabling PC
    RF_WrEn     <= '1';                       -- We write to a register in RF
    RF_WrData_sel<= '0';                      -- We write from ALU_out
    RF_B_sel   <= '0';                        -- We dont use Immed
    ALU_func    <= "1101";                    -- ror 
    ALU_Bin_sel  <= '0';                      -- We dont use Immed                    
    Mem_WrEn  <= '0';                         -- We dont use the MEM
    cloud_enable <= "01";                     -- dc 
    Instruction_BYPASS_IF <= "11100000001001100000000000001101";    --ror R6,R1      
    wait for CLK_period;     
            
    wait;
   end process;

END;