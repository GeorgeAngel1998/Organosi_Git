LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Registers_tb IS
END Registers_tb;
 
ARCHITECTURE behavior OF Registers_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT Registers is
    PORT ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           WE : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0)
          );
end COMPONENT;
    

   --Inputs
   SIGNAL CLK_SIG : std_logic;
   SIGNAL RST_SIG : std_logic;
   SIGNAL WE_SIG : std_logic;
   SIGNAL DATA_SIG : std_logic_vector(31 downto 0);

     --Outputs
   SIGNAL DOUT_SIG : std_logic_vector(31 downto 0);
   
   CONSTANT CLK_period : time := 100 ns;
   
BEGIN
 
 
CLK_process: process
begin
  CLK_SIG <= '1';
  wait for CLK_period/2;
  CLK_SIG <= '0';
  wait for CLK_period/2;
end process;

    -- Instantiate the Unit Under Test (UUT)
   uut: Registers PORT MAP (
          CLK => CLK_SIG,
          RST => RST_SIG,
          WE => WE_SIG,
          Data => DATA_SIG,
          Dout => DOUT_SIG
        );
 
   -- Stimulus process
   stim_proc: process
   begin
           
      -- WRITE ENABLED
        RST_SIG <= '0';
        WE_SIG <= '1';
        DATA_SIG <= "00000000000000001111111111111111";
      wait for CLK_period;
      
      -- RESET
        RST_SIG <= '1';
        WE_SIG <= '0';
        DATA_SIG <= "00000000000000001111111111111111";
      wait for CLK_period;
      
      -- WRITE ENABLED AGAIN
        RST_SIG <= '0';
        WE_SIG <= '1';
        DATA_SIG <= "11111111111111110000000000000000";
      wait for CLK_period;
      
      -- WRITE DISABLED
        RST_SIG <= '0';
        WE_SIG <= '0';
        DATA_SIG<= "00000000000000001111111111111111";
      wait for CLK_period;
      
            -- WRITE ENABLED AGAIN
        RST_SIG <= '0';
        WE_SIG <= '1';
        DATA_SIG <= "11111000001111100000111110000000";
      wait for CLK_period;
      
            -- WRITE ENABLED AGAIN
        RST_SIG <= '0';
        WE_SIG <= '1';
        DATA_SIG <= "10101010101010101010101010101010";
      wait for CLK_period;
      
      wait;
   end process;

END;