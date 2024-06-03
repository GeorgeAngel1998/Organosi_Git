library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Register_File_tb is
END Register_File_tb;

ARCHITECTURE Behavioral OF Register_File_tb IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT Register_File is
    Port (
    	CLK		: in STD_LOGIC;    
    	Ard1	: in STD_LOGIC_VECTOR (4 downto 0);
		Ard2	: in STD_LOGIC_VECTOR (4 downto 0);
		Awr		: in STD_LOGIC_VECTOR (4 downto 0);
		Dout1	: out STD_LOGIC_VECTOR (31 downto 0);
		Dout2	: out STD_LOGIC_VECTOR (31 downto 0);	
		Din		: in STD_LOGIC_VECTOR (31 downto 0);
		WrEn	: in STD_LOGIC;
		RST   : in STD_LOGIC;
		
		-- Testing Outputs
		TEST_Decoder_out: out std_logic_vector (31 downto 0);
		TEST_32MUX_1_out: out STD_LOGIC_VECTOR (31 downto 0); 
		TEST_32MUX_2_out: out STD_LOGIC_VECTOR (31 downto 0);
		TEST_AND_0: out STD_LOGIC;
        TEST_AND_2: out STD_LOGIC;
		TEST_R0_out: out STD_LOGIC_VECTOR (31 downto 0);
		TEST_R1_out: out STD_LOGIC_VECTOR (31 downto 0);
		TEST_R2_out: out STD_LOGIC_VECTOR (31 downto 0);
		TEST_R3_out: out STD_LOGIC_VECTOR (31 downto 0);
		TEST_compare_1_out: out STD_LOGIC;
		TEST_compare_2_out: out STD_LOGIC		 
	 );
end COMPONENT;

   --Inputs
   SIGNAL CLK : std_logic;
   SIGNAL Ard1 : std_logic_vector(4 downto 0);
   SIGNAL Ard2 : std_logic_vector(4 downto 0);
   SIGNAL Awr : std_logic_vector(4 downto 0);
   SIGNAL Din : std_logic_vector(31 downto 0);
   SIGNAL WrEn : std_logic;
   SIGNAL RST : std_logic;
   
   --Outputs
   SIGNAL Dout1 : std_logic_vector(31 downto 0);
   SIGNAL Dout2 : std_logic_vector(31 downto 0);
   
   SIGNAL TEST_Decoder_out: std_logic_vector (31 downto 0);
   SIGNAL TEST_32MUX_1_out : std_logic_vector(31 downto 0);
   SIGNAL TEST_32MUX_2_out : std_logic_vector(31 downto 0);
   SIGNAL TEST_AND_0: STD_LOGIC;
   SIGNAL TEST_AND_2: STD_LOGIC;
   SIGNAL TEST_R0_out : std_logic_vector(31 downto 0);
   SIGNAL TEST_R1_out : std_logic_vector(31 downto 0);
   SIGNAL TEST_R2_out : std_logic_vector(31 downto 0);
   SIGNAL TEST_R3_out : std_logic_vector(31 downto 0);      
   SIGNAL TEST_compare_1_out : std_logic;
   SIGNAL TEST_compare_2_out : std_logic;

   CONSTANT CLK_period : time := 100 ns;
   
begin

CLK_process: process
begin
  CLK <= '0';
  wait for CLK_period/2;
  CLK <= '1';
  wait for CLK_period/2;
end process;

	-- Instantiate the Unit Under Test (UUT)
   uut: Register_File PORT MAP (
          CLK => CLK,
          Ard1 => Ard1,
          Ard2 => Ard2,
          Awr => Awr,
          Dout1 => Dout1,
          Dout2 => Dout2,
          Din => Din,
          WrEn => WrEn,
          RST => RST,
          
          TEST_Decoder_out => TEST_Decoder_out,
          TEST_32MUX_1_out => TEST_32MUX_1_out,
          TEST_32MUX_2_out => TEST_32MUX_2_out,
          TEST_AND_0 => TEST_AND_0,
          TEST_AND_2 => TEST_AND_2, 
          TEST_R0_out => TEST_R0_out,
          TEST_R1_out => TEST_R1_out,
          TEST_R2_out => TEST_R2_out,
          TEST_R3_out => TEST_R3_out,
          TEST_compare_1_out => TEST_compare_1_out,
          TEST_compare_2_out => TEST_compare_2_out
        );

-- Stimulus process
   stim_proc: process
   begin
     
      -- Initialization
	  Ard1 <= "00000";
	  Ard2 <= "00000";
	  Awr <= "00000";
	  Din <= "00000000000000000000000000000000";
	  WrEn <= '0';
	  RST <= '1';
      wait for CLK_period;
     
   	  -- R1 R2 read , R2 write 
	  Ard1 <= "00000";
	  Ard2 <= "00010";
	  Awr <= "00010";
	  Din <= x"00000003";
	  WrEn <= '1';
	  RST <= '0';
      wait for CLK_period;
                 
      -- R2 R3 read , R0 writing
      Ard1 <= "00010";
	  Ard2 <= "00011";
	  Awr <= "00000";
	  Din <= x"00000001";
	  WrEn <= '1';
	  RST <= '0';
      wait for CLK_period;
          
      -- R3 R0 read , R1 no writing
      Ard1 <= "00011";
	  Ard2 <= "00000";
	  Awr <= "00001";
	  Din <= x"00000002";
	  WrEn <= '0';
	  RST <= '0';
      wait for CLK_period;
      
      -- Read R1, R2 both write and read
      Ard1 <= "00001";
	  Ard2 <= "00010";
	  Awr <= "00010";
	  Din <= x"afafafaf";
	  WrEn <= '1';
	  RST <= '0';
      wait for CLK_period;
      
      -- Conflict R1 both write and read
      Ard1 <= "00001";
	  Ard2 <= "00010";
	  Awr <= "00001";
	  Din <= x"fafafafa";
	  WrEn <= '1';
	  RST <= '0';
      wait for CLK_period;
      
      wait;
   end process;

END;
