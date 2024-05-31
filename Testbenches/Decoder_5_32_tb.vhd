library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Decoder_5_32_tb is
END Decoder_5_32_tb;

ARCHITECTURE Behavioral OF Decoder_5_32_tb IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT Decoder_5_32 is
    Port ( 
        Dec_Awr: in  STD_LOGIC_VECTOR (4 downto 0);
        Dec_Output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end COMPONENT;

   --Inputs
   SIGNAL Dec_Awr : std_logic_vector(4 downto 0);

   --Outputs
   SIGNAL Dec_Output :  std_logic_vector(31 downto 0) := (others => '0');
   
begin

	-- Instantiate the Unit Under Test (UUT)
   uut: Decoder_5_32 PORT MAP (
          Dec_Awr => Dec_Awr,
          Dec_Output => Dec_Output              
        );

-- Stimulus process
   stim_proc: process
   begin
   	
	  Dec_Awr <= "00000";
      wait for 200 ns;
      Dec_Awr <= "00001";
      wait for 200 ns;
      Dec_Awr <= "00010";
      wait for 200 ns;
      Dec_Awr <= "00011";
      wait for 200 ns;
      Dec_Awr <= "00100";
      wait for 200 ns;
      Dec_Awr <= "00101";
      wait for 200 ns;
      
      wait;
   end process;

END;
