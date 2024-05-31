library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_STAGE is
    Port ( clk : in STD_LOGIC;
           Mem_WrEn : in STD_LOGIC;
           ALU_MEM_Addr : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out STD_LOGIC_VECTOR (31 downto 0));
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

signal WREN_SIGNAL : STD_LOGIC;

begin

WREN_SIGNAL <= '1' when Mem_WrEn = '1' else '0';

MEM : dist_mem_gen_1 port map ( a => ALU_MEM_Addr(11 downto 2),
                                d => MEM_DataIn,
                                we => WREN_SIGNAL,
                                spo => MEM_DataOut,
                                clk => clk
                                );
                                                               	                                                    
end Behavioral;
