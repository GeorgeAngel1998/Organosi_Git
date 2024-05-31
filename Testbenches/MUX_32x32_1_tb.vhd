LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_32x32_1_tb IS
END MUX_32x32_1_tb;
 
ARCHITECTURE behavior OF MUX_32x32_1_tb IS 
 
COMPONENT MUX_32x32_1
    PORT ( 
		MUX_in_0: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_1: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_2: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_3: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_4: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_5: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_6: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_7: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_8: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_9: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_10: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_11: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_12: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_13: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_14: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_15: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_16: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_17: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_18: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_19: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_20: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_21: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_22: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_23: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_24: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_25: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_26: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_27: in STD_LOGIC_VECTOR (31 downto 0);
		MUX_in_28: in STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_29: in STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_30: in STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_31: in STD_LOGIC_VECTOR (31 downto 0);                                                  
		sel	: in  STD_LOGIC_VECTOR (4 downto 0);
		output 		: out  STD_LOGIC_VECTOR (31 downto 0)
	);
END COMPONENT;
    

   --Inputs
   signal MUX_in_0 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_2 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_3 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_4 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_5 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_6 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_7 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_8 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_9 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_10 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_11 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_12 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_13 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_14 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_15 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_16 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_17 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_18 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_19 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_20 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_21 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_22 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_23 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_24 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_25 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_26 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_27 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_28 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_29 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_30 : std_logic_vector(31 downto 0) := (others => '0');
   signal MUX_in_31 : std_logic_vector(31 downto 0) := (others => '0');
   signal sel : std_logic_vector(4 downto 0) := (others => '0');
   
 	--Outputs
   signal output : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MUX_32x32_1 PORT MAP (
          MUX_in_0 => MUX_in_0,
          MUX_in_1 => MUX_in_1,          
          MUX_in_2 => MUX_in_2,
          MUX_in_3 => MUX_in_3,
          MUX_in_4 => MUX_in_4,
          MUX_in_5 => MUX_in_5,
          MUX_in_6 => MUX_in_6,
          MUX_in_7 => MUX_in_7,
          MUX_in_8 => MUX_in_8,
          MUX_in_9 => MUX_in_9,
          MUX_in_10 => MUX_in_10,
          MUX_in_11 => MUX_in_11,
          MUX_in_12 => MUX_in_12,
          MUX_in_13 => MUX_in_13,
          MUX_in_14 => MUX_in_14,
          MUX_in_15 => MUX_in_15,
          MUX_in_16 => MUX_in_16,
          MUX_in_17 => MUX_in_17,
          MUX_in_18 => MUX_in_18,
          MUX_in_19 => MUX_in_19,
          MUX_in_20 => MUX_in_20,
          MUX_in_21 => MUX_in_21,
          MUX_in_22 => MUX_in_22,
          MUX_in_23 => MUX_in_23,
          MUX_in_24 => MUX_in_24,
          MUX_in_25 => MUX_in_25,
          MUX_in_26 => MUX_in_26,
          MUX_in_27 => MUX_in_27,
          MUX_in_28 => MUX_in_28,
          MUX_in_29 => MUX_in_29,
          MUX_in_30 => MUX_in_30,
          MUX_in_31 => MUX_in_31,
          sel => sel,
          output => output                                 
        );
 

   -- Stimulus process
   stim_proc: process
   begin
   		
		MUX_in_3 <= "00000000000000001111100000000001";
		sel <= "00011";
      wait for 200 ns;
      
		
      wait;
   end process;

END;