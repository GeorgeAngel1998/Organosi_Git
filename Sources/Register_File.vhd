library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
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
		
--		-- Testing Outputs
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
end Register_File;

architecture Structural of Register_File is

Component Registers is
    Port (
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        WE : in  STD_LOGIC;
        Data : in  STD_LOGIC_VECTOR (31 downto 0);
        Dout : out  STD_LOGIC_VECTOR (31 downto 0)
	 );
end Component;

Component Decoder_5_32
    Port( 
        Dec_Awr: in  STD_LOGIC_VECTOR (4 downto 0);
        Dec_Output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Component;

Component Compare_Module is
    Port (
        Ard     : in STD_LOGIC_VECTOR (4 downto 0);
        Awr     : in STD_LOGIC_VECTOR (4 downto 0);
        WrEn    : in STD_LOGIC;
        Output  : out STD_LOGIC 
    );
end Component;

Component MUX_32x32_1 is
    Port ( 
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
		output : out  STD_LOGIC_VECTOR (31 downto 0)
	);
end Component;

Component MUX_32x2_1 is
    Port ( in_A   : in  STD_LOGIC_VECTOR (31 downto 0);
           in_B   : in  STD_LOGIC_VECTOR (31 downto 0);        
           sel    : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

-- ALL THE SIGNAL HERE ------------------------------------------------

signal Dec_Output_signal : STD_LOGIC_VECTOR (31 downto 0);

signal And_out_0_signal : STD_LOGIC;
signal And_out_1_signal : STD_LOGIC;
signal And_out_2_signal : STD_LOGIC;
signal And_out_3_signal : STD_LOGIC;
signal And_out_4_signal : STD_LOGIC;
signal And_out_5_signal : STD_LOGIC;
signal And_out_6_signal : STD_LOGIC;
signal And_out_7_signal : STD_LOGIC;
signal And_out_8_signal : STD_LOGIC;
signal And_out_9_signal : STD_LOGIC;
signal And_out_10_signal : STD_LOGIC;
signal And_out_11_signal : STD_LOGIC;
signal And_out_12_signal : STD_LOGIC;
signal And_out_13_signal : STD_LOGIC;
signal And_out_14_signal : STD_LOGIC;
signal And_out_15_signal : STD_LOGIC;
signal And_out_16_signal : STD_LOGIC;
signal And_out_17_signal : STD_LOGIC;
signal And_out_18_signal : STD_LOGIC;
signal And_out_19_signal : STD_LOGIC;
signal And_out_20_signal : STD_LOGIC;
signal And_out_21_signal : STD_LOGIC;
signal And_out_22_signal : STD_LOGIC;
signal And_out_23_signal : STD_LOGIC;
signal And_out_24_signal : STD_LOGIC;
signal And_out_25_signal : STD_LOGIC;
signal And_out_26_signal : STD_LOGIC;
signal And_out_27_signal : STD_LOGIC;
signal And_out_28_signal : STD_LOGIC;
signal And_out_29_signal : STD_LOGIC;
signal And_out_30_signal : STD_LOGIC;
signal And_out_31_signal : STD_LOGIC;

signal R0_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R1_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R2_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R3_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R4_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R5_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R6_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R7_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R8_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R9_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R10_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R11_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R12_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R13_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R14_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R15_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R16_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R17_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R18_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R19_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R20_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R21_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R22_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R23_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R24_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R25_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R26_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R27_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R28_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R29_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R30_signal : STD_LOGIC_VECTOR (31 downto 0);
signal R31_signal : STD_LOGIC_VECTOR (31 downto 0);

signal MUX01_Output_signal   : STD_LOGIC_VECTOR (31 downto 0);
signal MUX02_Output_signal   : STD_LOGIC_VECTOR (31 downto 0);
signal Compare_Module_1_Output_signal : STD_LOGIC;
signal Compare_Module_2_Output_signal : STD_LOGIC;
signal Dout1_signal : STD_LOGIC_VECTOR (31 downto 0);
signal Dout2_signal : STD_LOGIC_VECTOR (31 downto 0);

-- END OF SIGNALS ---------------------------------------------------------------

begin

Decoder : Decoder_5_32 
    Port Map(
        Dec_Awr => Awr,
        Dec_Output => Dec_Output_signal 
    );
    
And_out_0_signal <= '0';	
And_out_1_signal <= Dec_Output_signal(1) AND WrEn ;	
And_out_2_signal <= Dec_Output_signal(2) AND WrEn ;	
And_out_3_signal <= Dec_Output_signal(3) AND WrEn ;	
And_out_4_signal <= Dec_Output_signal(4) AND WrEn ;	
And_out_5_signal <= Dec_Output_signal(5) AND WrEn ;	
And_out_6_signal <= Dec_Output_signal(6) AND WrEn ;	
And_out_7_signal <= Dec_Output_signal(7) AND WrEn ;	
And_out_8_signal <= Dec_Output_signal(8) AND WrEn ;	
And_out_9_signal <= Dec_Output_signal(9) AND WrEn ;	
And_out_10_signal<= Dec_Output_signal(10) AND WrEn ;	
And_out_11_signal<= Dec_Output_signal(11) AND WrEn ;	
And_out_12_signal<= Dec_Output_signal(12) AND WrEn ;	
And_out_13_signal<= Dec_Output_signal(13) AND WrEn ;	
And_out_14_signal<= Dec_Output_signal(14) AND WrEn ;	
And_out_15_signal<= Dec_Output_signal(15) AND WrEn ;	
And_out_16_signal<= Dec_Output_signal(16) AND WrEn ;	
And_out_17_signal<= Dec_Output_signal(17) AND WrEn ;	
And_out_18_signal<= Dec_Output_signal(18) AND WrEn ;	
And_out_19_signal<= Dec_Output_signal(19) AND WrEn ;	
And_out_20_signal<= Dec_Output_signal(20) AND WrEn ;	
And_out_21_signal<= Dec_Output_signal(21) AND WrEn ;	
And_out_22_signal<= Dec_Output_signal(22) AND WrEn ;	
And_out_23_signal<= Dec_Output_signal(23) AND WrEn ;	
And_out_24_signal<= Dec_Output_signal(24) AND WrEn ;	
And_out_25_signal<= Dec_Output_signal(25) AND WrEn ;	
And_out_26_signal<= Dec_Output_signal(26) AND WrEn ;	
And_out_27_signal<= Dec_Output_signal(27) AND WrEn ;	
And_out_28_signal<= Dec_Output_signal(28) AND WrEn ;	
And_out_29_signal<= Dec_Output_signal(29) AND WrEn ;	
And_out_30_signal<= Dec_Output_signal(30) AND WrEn ;	
And_out_31_signal<= Dec_Output_signal(31) AND WrEn ;	

R0: Registers port map (
            CLK => CLK,
            RST => '1',
            WE => And_out_0_signal,
            Data =>"00000000000000000000000000000000",
            Dout => R0_signal
        );
        
R1: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_1_signal,
            Data =>Din,
            Dout => R1_signal
        );
        
R2: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_2_signal,
            Data =>Din,
            Dout => R2_signal
        );
        
R3: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_3_signal,
            Data =>Din,
            Dout => R3_Signal
        );
        
R4: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_4_signal,
            Data =>Din,
            Dout => R4_signal
        );

R5: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_5_signal,
            Data =>Din,
            Dout => R5_signal
        );
        
R6: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_6_signal,
            Data =>Din,
            Dout => R6_signal
        );
        
R7: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_7_signal,
            Data =>Din,
            Dout => R7_signal
        );
        
R8: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_8_signal,
            Data =>Din,
            Dout => R8_Signal
        );
        
R9: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_9_signal,
            Data =>Din,
            Dout => R9_signal
        );
        
R10: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_10_signal,
            Data =>Din,
            Dout => R10_signal
        );

R11: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_11_signal,
            Data =>Din,
            Dout => R11_signal
        );
        
R12: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_12_signal,
            Data =>Din,
            Dout => R12_signal
        );
        
R13: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_13_signal,
            Data =>Din,
            Dout => R13_signal
        );
        
R14: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_14_signal,
            Data =>Din,
            Dout => R14_signal
        );
        
R15: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_15_signal,
            Data =>Din,
            Dout => R15_signal
        );
        
R16: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_16_signal,
            Data =>Din,
            Dout => R16_signal
        );

R17: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_17_signal,
            Data =>Din,
            Dout => R17_signal
        );
        
R18: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_18_signal,
            Data =>Din,
            Dout => R18_signal
        );
        
R19: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_19_signal,
            Data =>Din,
            Dout => R19_signal
        );
        
R20: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_20_signal,
            Data =>Din,
            Dout => R20_signal
        );
        
R21: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_21_signal,
            Data =>Din,
            Dout => R21_signal
        );
        
R22: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_22_signal,
            Data =>Din,
            Dout => R22_signal
        );

R23: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_23_signal,
            Data =>Din,
            Dout => R23_signal
        );
        
R24: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_24_signal,
            Data =>Din,
            Dout => R24_signal
        );
        
R25: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_25_signal,
            Data =>Din,
            Dout => R25_signal
        );
        
R26: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_26_signal,
            Data =>Din,
            Dout => R26_signal
        );
        
R27: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_27_signal,
            Data =>Din,
            Dout => R27_signal
        );
        
R28: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_28_signal,
            Data =>Din,
            Dout => R28_signal
        );

R29: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_29_signal,
            Data =>Din,
            Dout => R29_signal
        ); 
        
R30: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_30_signal,
            Data =>Din,
            Dout => R30_signal
        );

R31: Registers port map (
            CLK => CLK,
            RST => RST,
            WE => And_out_31_signal,
            Data =>Din,
            Dout => R31_signal
        );        
 
CompareModule1 : Compare_Module port map (
    Ard     => Ard1,
    Awr     => Awr,
    WrEn    => WrEn,
    Output  => Compare_Module_1_Output_signal
);
      
CompareModule2 : Compare_Module port map (
    Ard     => Ard2,
    Awr     => Awr,
    WrEn    => WrEn,
    Output  => Compare_Module_2_Output_signal
);

MUX01: MUX_32x32_1 port map(
	MUX_in_0 => R0_signal,
	MUX_in_1 => R1_signal,
	MUX_in_2 => R2_signal,
	MUX_in_3 => R3_signal,
	MUX_in_4 => R4_signal,
	MUX_in_5 => R5_signal,
	MUX_in_6 => R6_signal,
	MUX_in_7 => R7_signal,
	MUX_in_8 => R8_signal,
	MUX_in_9 => R9_signal,
	MUX_in_10 => R10_signal,
	MUX_in_11 => R11_signal,
	MUX_in_12 => R12_signal,
	MUX_in_13 => R13_signal,
	MUX_in_14 => R14_signal,
	MUX_in_15 => R15_signal,
	MUX_in_16 => R16_signal,
	MUX_in_17 => R17_signal,
	MUX_in_18 => R18_signal,
	MUX_in_19 => R19_signal,
	MUX_in_20 => R20_signal,
	MUX_in_21 => R21_signal,
	MUX_in_22 => R22_signal,
	MUX_in_23 => R23_signal,
	MUX_in_24 => R24_signal,
	MUX_in_25 => R25_signal,
	MUX_in_26 => R26_signal,
	MUX_in_27 => R27_signal,
	MUX_in_28 => R28_signal,
	MUX_in_29 => R29_signal,
	MUX_in_30 => R30_signal,
	MUX_in_31 => R31_signal,
	sel => Ard1,
	output => MUX01_Output_signal
);

MUX02: MUX_32x32_1 port map(
	MUX_in_0 => R0_signal,
	MUX_in_1 => R1_signal,
	MUX_in_2 => R2_signal,
	MUX_in_3 => R3_signal,
	MUX_in_4 => R4_signal,
	MUX_in_5 => R5_signal,
	MUX_in_6 => R6_signal,
	MUX_in_7 => R7_signal,
	MUX_in_8 => R8_signal,
	MUX_in_9 => R9_signal,
	MUX_in_10 => R10_signal,
	MUX_in_11 => R11_signal,
	MUX_in_12 => R12_signal,
	MUX_in_13 => R13_signal,
	MUX_in_14 => R14_signal,
	MUX_in_15 => R15_signal,
	MUX_in_16 => R16_signal,
	MUX_in_17 => R17_signal,
	MUX_in_18 => R18_signal,
	MUX_in_19 => R19_signal,
	MUX_in_20 => R20_signal,
	MUX_in_21 => R21_signal,
	MUX_in_22 => R22_signal,
	MUX_in_23 => R23_signal,
	MUX_in_24 => R24_signal,
	MUX_in_25 => R25_signal,
	MUX_in_26 => R26_signal,
	MUX_in_27 => R27_signal,
	MUX_in_28 => R28_signal,
	MUX_in_29 => R29_signal,
	MUX_in_30 => R30_signal,
	MUX_in_31 => R31_signal,
	sel => Ard2,
	output => MUX02_Output_signal
);

MUX11: MUX_32x2_1 port map(
    in_A        => MUX01_Output_signal,
    in_B        => Din,
    sel         => Compare_Module_1_Output_signal, 
    output 		=> Dout1_signal
);

MUX12: MUX_32x2_1 port map(
    in_A        => MUX02_Output_signal,
    in_B        => Din,
    sel         => Compare_Module_2_Output_signal, 
    output 		=> Dout2_signal
);

TEST_Decoder_out <= Dec_Output_signal;

TEST_AND_0 <= And_out_0_signal;
TEST_AND_2 <= And_out_2_signal;
TEST_32MUX_1_out <= MUX01_Output_signal;
TEST_32MUX_2_out <= MUX02_Output_signal;
TEST_compare_1_out <= Compare_Module_1_Output_signal;
TEST_compare_2_out <= Compare_Module_2_Output_signal;

TEST_R0_out <= R0_signal;
TEST_R1_out <= R1_signal;
TEST_R2_out <= R2_signal;
TEST_R3_out <= R3_signal;

Dout1 <= Dout1_signal;
Dout2 <= Dout2_signal;

end Structural;