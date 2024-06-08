library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IFSTAGE is
    Port ( 
       PC_Immed     : in  STD_LOGIC_VECTOR (31 downto 0);
       PC_sel       : in  STD_LOGIC;
       PC_LdEn      : in  STD_LOGIC;
       Reset        : in  STD_LOGIC;
       Clk          : in  STD_LOGIC;
       Instr        : out  STD_LOGIC_VECTOR (31 downto 0);
       
              -- Testing
      memIn        : out  STD_LOGIC_VECTOR (31 downto 0); 
      muxOut       : out  STD_LOGIC_VECTOR (31 downto 0); 
      muxA         : out  STD_LOGIC_VECTOR (31 downto 0);
      muxB         : out  STD_LOGIC_VECTOR (31 downto 0)
       );       
end IFSTAGE;

architecture Behavioral of IFSTAGE is

Component MUX_32x2_1 is
    Port ( in_A   : in  STD_LOGIC_VECTOR (31 downto 0);
           in_B   : in  STD_LOGIC_VECTOR (31 downto 0);        
           sel    : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

component registers is
    Port (
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        WE : in  STD_LOGIC;
        Data : in  STD_LOGIC_VECTOR (31 downto 0);
        Dout : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end component;

component Adder IS
    Port ( 
        adder1 : in  STD_LOGIC_VECTOR (31 downto 0);
        adderOut : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component dist_mem_gen_0 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

signal MUX_output_signal: std_logic_vector(31 downto 0)     := "00000000000000000000000000000000";
signal MUX_input_A_signal: std_logic_vector(31 downto 0)    := "00000000000000000000000000000000";
signal MUX_input_B_signal: std_logic_vector(31 downto 0)    := "00000000000000000000000000000000";
signal register_out_signal: std_logic_vector(31 downto 0)   := "00000000000000000000000000000000";
signal memory_out_signal: std_logic_vector(31 downto 0)     := "00000000000000000000000000000000";

begin

    PC: registers port map (
        CLK => Clk, 
        RST => RESET ,
        WE => PC_LdEn,
        Data => MUX_output_signal,
        Dout => register_out_signal);
									 
	ADD01: Adder port map(
        adder1=>register_out_signal,
        adderOut=>MUX_input_A_signal);
	
	MUX01: MUX_32x2_1 port map ( 
        in_A => MUX_input_A_signal,
        in_B => MUX_input_B_signal,
        sel => PC_sel,
        output => MUX_output_signal);
        
    IMEM1: dist_mem_gen_0 port map (
       a => register_out_signal(11 downto 2), -- change to 11 downto 2
       spo => memory_out_signal
       );
    
    process (PC_Immed, MUX_input_A_signal)
       begin
           MUX_input_B_signal <= PC_Immed + MUX_input_A_signal;
           MUX_input_A_signal <= register_out_signal + 4;
       end process;		
    	
    Instr   <= memory_out_signal;
    memIn   <= register_out_signal;
    muxOut  <= MUX_output_signal;
    muxA    <= MUX_input_A_signal;
    muxB    <= MUX_input_B_signal;

end Behavioral;