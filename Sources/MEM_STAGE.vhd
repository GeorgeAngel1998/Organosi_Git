library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_STAGE is
    Port ( clk : in STD_LOGIC;        
           Mem_WrEn : in STD_LOGIC_VECTOR(2 downto 0);
           ALU_MEM_Addr : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out STD_LOGIC_VECTOR (31 downto 0)
           );
end MEM_STAGE;

architecture Behavioral of MEM_STAGE is

Component dist_mem_gen_1 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

signal WrEn_signal : STD_LOGIC;
signal MEM_Read_Data_signal : STD_LOGIC_VECTOR(31 downto 0);
signal MEM_Write_Addr_signal : STD_LOGIC_VECTOR(31 downto 0);

begin

MEM : dist_mem_gen_1 port map ( a => ALU_MEM_Addr(11 downto 2),
                                d => MEM_Write_Addr_signal,
                                we => WrEn_signal,
                                spo => MEM_Read_Data_signal,
                                clk => clk
                                );
                                                                
process
begin  
wait until clk'event and clk='1';
	
if(MEM_WrEn = "001") then       -- lb
     WrEn_signal <= '0';
     MEM_DataOut <= (others => '0');
     MEM_DataOut(7 downto 0) <= MEM_Read_Data_signal(7 downto 0);
     
elsif(MEM_WrEn = "010") then    -- sb
   WrEn_signal <= '1';
   MEM_Write_Addr_signal <= (others => '0');
   MEM_Write_Addr_signal(7 downto 0) <= MEM_DataIn(7 downto 0);
   
elsif(MEM_WrEn = "011") then    -- lw
   WrEn_signal <= '0';
   MEM_DataOut <= MEM_Read_Data_signal;
   
elsif(MEM_WrEn = "100") then    -- sw
   WrEn_signal <= '1';
   MEM_Write_Addr_signal <= MEM_DataIn;
   
else
   WrEn_signal <= '0';
   MEM_DataOut <= "00000000000000000000000000000000";	
end if;
end process;

end Behavioral;


