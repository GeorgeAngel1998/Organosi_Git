LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EX_STAGE_tb IS
END EX_STAGE_tb;
 
ARCHITECTURE behavior OF EX_STAGE_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT EX_STAGE is
     PORT ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
            RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
            Immed : in  STD_LOGIC_VECTOR (31 downto 0);
            ALU_Bin_sel : in STD_LOGIC;
            ALU_func : in STD_LOGIC_VECTOR (3 downto 0);
            ALU_out : out STD_LOGIC_VECTOR (31 downto 0)
     );
end COMPONENT;
    

   --Inputs
   SIGNAL RF_A : std_logic_vector(31 downto 0) := (others => '0');
   SIGNAL RF_B : std_logic_vector(31 downto 0) := (others => '0');
   SIGNAL Immed : std_logic_vector(31 downto 0) := (others => '0');
   SIGNAL ALU_Bin_sel : std_logic;
   SIGNAL ALU_func : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   SIGNAL ALU_out : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EX_STAGE PORT MAP (
          RF_A => RF_A,
          RF_B => RF_B,
          Immed => Immed,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          ALU_out => ALU_out
        );
 
   -- Stimulus process
   stim_proc: process
   begin
   		
      -- bin = 0 pairnei RF_B
		RF_A <= "00000000000000000000000000000011";
		RF_B <= "00000000000000000000000000000100";
		Immed <= "00000000000000000000000000000111";
		ALU_Bin_sel <= '0';
		ALU_func <= "0000";
      wait for 200 ns;
      
      
       -- bin = 0 pairnei RF_B
		RF_A <= "00000000000000000000000001100011";
		RF_B <= "00000000000000000000000110000100";
		Immed <= "00000000000000000000000000000111";
		ALU_Bin_sel <= '0';
		ALU_func <= "0011";
      wait for 200 ns;
      
       -- bin = 1 pairnei Immed
		RF_A <= "00000000000000000000000000000011";
		RF_B <= "00000000000000000000000000000100";
		Immed <= "00000000000000000000000000000111";
		ALU_Bin_sel <= '1';
		ALU_func <= "0000";
      wait for 200 ns;

      wait;
   end process;

END;