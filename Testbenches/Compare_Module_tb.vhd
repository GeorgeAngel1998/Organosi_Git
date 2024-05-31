library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Compare_Module_tb is
END Compare_Module_tb;

ARCHITECTURE Behavioral OF Compare_Module_tb IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT Compare_Module is
    Port ( 
        Ard: in  STD_LOGIC_VECTOR (4 downto 0);
        Awr: in  STD_LOGIC_VECTOR (4 downto 0);
        WrEn: in STD_LOGIC;
        Output : out STD_LOGIC
    );
end COMPONENT;

   --Inputs
   SIGNAL Ard : std_logic_vector(4 downto 0);
   SIGNAL Awr : std_logic_vector(4 downto 0);
   SIGNAL WrEn : std_logic;
   
   --Outputs
   SIGNAL Output : std_logic;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: Compare_Module PORT MAP (
          Ard => Ard,
          Awr => Awr,
          WrEn => WrEn,
          Output => Output
        );

-- Stimulus process
   stim_proc: process
   begin
   	
	  Ard <= "00000";
	  Awr <= "00000";
	  WrEn <= '0';
      wait for 200 ns;
      
      Ard <= "00000";
	  Awr <= "00000";
	  WrEn <= '1';
      wait for 200 ns;
      
      Ard <= "00000";
	  Awr <= "00000";
	  WrEn <= '0';
      wait for 200 ns;
      
      Ard <= "11111";
	  Awr <= "00000";
	  WrEn <= '1';
      wait for 200 ns;

      wait;
   end process;

END;
