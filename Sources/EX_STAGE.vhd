library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_STAGE is
     Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
            RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
            Immed : in  STD_LOGIC_VECTOR (31 downto 0);
            ALU_Bin_sel : in STD_LOGIC;
            ALU_func : in STD_LOGIC_VECTOR (3 downto 0);
            ALU_out : out STD_LOGIC_VECTOR (31 downto 0)
     );
end EX_STAGE;

architecture Behavioral of EX_STAGE is

component MUX_32x2_1 is
    Port ( in_A   : in  STD_LOGIC_VECTOR (31 downto 0);
           in_B   : in  STD_LOGIC_VECTOR (31 downto 0);        
           sel    : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           OutALU : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end component;

signal MUX_Out_signal : STD_LOGIC_VECTOR (31 downto 0);

begin

ALU1: ALU port map ( A => RF_A,
                     B => MUX_Out_signal,
                     Op => ALU_func,
                     OutALU => ALU_out,
                     Zero => open,
                     Cout => open,
                     Ovf => open
                    );
                    
MUX1: MUX_32x2_1 port map ( in_A => RF_B,
                            in_B => Immed,
                            sel => ALU_Bin_sel,
                            output => MUX_Out_signal
                            );
                                      
end Behavioral;
