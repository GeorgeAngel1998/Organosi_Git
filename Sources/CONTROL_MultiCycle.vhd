library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_MultiCycle is
    Port ( Instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           Control_Clk : in  STD_LOGIC;
           Control_Reset : in  STD_LOGIC;
          
           PC_sel : out  STD_LOGIC;
           PC_LdEn : out  STD_LOGIC;
           RF_WrEn : out STD_LOGIC;
           RF_WrData_sel : out  STD_LOGIC;
           RF_B_sel : out  STD_LOGIC;
           cloud_enable : out STD_LOGIC_VECTOR(1 downto 0);
           ALU_func : out STD_LOGIC_VECTOR(3 downto 0);
           ALU_Bin_sel : out STD_LOGIC;       
           Mem_WrEn : out STD_LOGIC;       
           Instr_REG_WE : out STD_LOGIC;
           RF_A_REG_WE : out STD_LOGIC;
           RF_B_REG_WE : out STD_LOGIC;      
           Immed_Reg_WE : out STD_LOGIC;
           ALU_out_Reg_WE : out STD_LOGIC;
           MEM_Dataout_REG_WE : out STD_LOGIC         
           );
end CONTROL_MultiCycle;

architecture Behavioral of CONTROL_MultiCycle is

type state is(S0_Fetch, S1_Decode, S5_Execute_Li_Lui, S6_Execute_ALU, S7_WriteBack_ALU, S8_Execute_Addi, S9_Execute_Andi, S10_Execute_Ori);

--Signals
SIGNAL current_State ,next_State: state;

SIGNAL PC_sel_signal : STD_LOGIC := '0';
SIGNAL PC_LdEn_signal : STD_LOGIC:= '0';
SIGNAL RF_WrEn_signal : STD_LOGIC:= '0';
SIGNAL RF_WrData_sel_signal : STD_LOGIC:= '0';
SIGNAL RF_B_sel_signal : STD_LOGIC:= '0';
SIGNAL cloud_enable_signal : STD_LOGIC_VECTOR(1 downto 0):= "00";
SIGNAL ALU_func_signal : STD_LOGIC_VECTOR(3 downto 0):= "0000";
SIGNAL ALU_Bin_sel_signal : STD_LOGIC:= '0';       
SIGNAL Mem_WrEn_signal : STD_LOGIC:= '0';        
SIGNAL Instr_REG_WE_signal : STD_LOGIC:= '0';
SIGNAL RF_A_REG_WE_signal : STD_LOGIC:= '0';
SIGNAL RF_B_REG_WE_signal : STD_LOGIC:= '0';      
SIGNAL Immed_Reg_WE_signal : STD_LOGIC:= '0';
SIGNAL ALU_out_Reg_WE_signal : STD_LOGIC:= '0';
SIGNAL MEM_Dataout_REG_WE_signal : STD_LOGIC:= '0';

begin

--OPCODE <= Instruction(31 downto 26);

process(current_State, Instruction)
begin
case current_State is

   when S0_Fetch => 
        
        PC_sel_signal <= '0';
        PC_LdEn_signal <= '0';
        RF_WrEn_signal <= '0';
        RF_WrData_sel_signal <= '0';
        RF_B_sel_signal <= '0';
        cloud_enable_signal <= "00";
        ALU_func_signal <= "1111";
        ALU_Bin_sel_signal <= '0';       
        Mem_WrEn_signal <= '0';        
        Instr_REG_WE_signal <= '0';
        RF_A_REG_WE_signal <= '0';
        RF_B_REG_WE_signal <= '0';      
        Immed_Reg_WE_signal <= '0';
        ALU_out_Reg_WE_signal <= '0';
        MEM_Dataout_REG_WE_signal <= '0';
        
        --next_State <= Fetch;
        next_State <= S1_Decode;
      
   when S1_Decode =>   
        
        Instr_REG_WE_signal <= '0';
        RF_A_REG_WE_signal <= '1';
        RF_B_REG_WE_signal <= '1';      
        Immed_Reg_WE_signal <= '1';
        
        if Instruction(31 downto 26) = "100000" then --ALU R-Types
        
           RF_WrEn_signal <= '0';       -- We dont write the reg yet
           RF_B_sel_signal <= '0';      -- no Immed
           cloud_enable_signal <= "00"; -- dontcare , no Immed                 
           next_State <= S6_Execute_ALU;
        
        elsif Instruction(31 downto 26) ="111000" then --li
           
           RF_WrEn_signal <='0';        -- We dont write the reg yet
           RF_B_sel_signal <='1';       -- We have Immed
		   cloud_enable_signal <= "01"; -- SignExtend
		   next_State <= S5_Execute_Li_Lui;
        
        elsif Instruction(31 downto 26) ="111001" then --lui
        
           RF_WrEn_signal <='0';        -- We dont write the reg yet
           RF_B_sel_signal <='1';       -- We have Immed
		   cloud_enable_signal <= "10"; -- Shift/ZeroFill
		   next_State <= S5_Execute_Li_Lui;
        
        elsif Instruction(31 downto 26) = "110000" then --addi
        
           RF_WrEn_signal <='0';        -- We dont write the reg yet
           RF_B_sel_signal <='1';       -- We have Immed
		   cloud_enable_signal <= "01"; -- SignExtend
           next_State <= S8_Execute_Addi;
        
        elsif Instruction(31 downto 26) = "110010" then --andi
        
           RF_WrEn_signal <='0';        -- We dont write the reg yet
           RF_B_sel_signal <='1';       -- We have Immed
		   cloud_enable_signal <= "00"; -- ZeroFill
           next_State <= S9_Execute_Andi;
        
        elsif Instruction(31 downto 26) = "110011" then --ori
        
           RF_WrEn_signal <='0';        -- We dont write the reg yet
           RF_B_sel_signal <='1';       -- We have Immed
		   cloud_enable_signal <= "00"; -- ZeroFill
           next_State <= S10_Execute_Ori;
                             
--      elsif Instruction(31 downto 26) ="111111" then --b					
--	    elsif Instruction(31 downto 26) ="010000" then --beq					
--		elsif Instruction(31 downto 26) ="010001" then --bne			
--	    elsif Instruction(31 downto 26) = "000011" or Instruction(31 downto 26) ="001111" then   --load
--		elsif	Instruction(31 downto 26) = "000111" or Instruction(31 downto 26) = "011111" then    --save
        end if;
        
    when S5_Execute_Li_Lui =>
    
         RF_A_REG_WE_signal <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE_signal <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE_signal <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE_signal <='1';        -- We hold the value
		 Alu_Bin_Sel_signal <='1';           -- We have Immed
		 ALU_func_signal <= "0000";          -- Add the immediate to zero = Immed
		 next_State <= S7_WriteBack_ALU;
         
    when S6_Execute_ALU =>  
    
         RF_A_REG_WE_signal <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE_signal <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE_signal <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE_signal <='1';        -- We hold the value 
		 Alu_Bin_Sel_signal <='0';           -- No Immed
		 ALU_func_signal <= Instruction(3 downto 0);
		 next_State <= S7_WriteBack_ALU;
		 
    when S7_WriteBack_ALU =>      
         
         RF_WrData_sel_signal <= '0';        -- We want from ALU_out
	     RF_WrEn_signal <= '1';              -- We write to the reg 
		 Immed_Reg_WE_signal <= '1';         -- We hold the value 
		 next_State <= S0_Fetch;
		 
    when S8_Execute_Addi =>
      
         RF_A_REG_WE_signal <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE_signal <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE_signal <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE_signal <='1';        -- We hold the value 
		 Alu_Bin_Sel_signal <='1';           -- We have Immed
		 ALU_func_signal <= "0000";          -- add
		 next_State <= S7_WriteBack_ALU;
    
    when S9_Execute_Andi =>   
    
         RF_A_REG_WE_signal <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE_signal <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE_signal <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE_signal <='1';        -- We hold the value 
		 Alu_Bin_Sel_signal <='1';           -- We have Immed
		 ALU_func_signal <= "0010";          -- and
		 next_State <= S7_WriteBack_ALU;
    
    when S10_Execute_Ori =>
    
         RF_A_REG_WE_signal <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE_signal <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE_signal <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE_signal <='1';        -- We hold the value 
		 Alu_Bin_Sel_signal <='1';           -- We have Immed
		 ALU_func_signal <= "0011";          -- or
		 next_State <= S7_WriteBack_ALU;
    
end case;
end process;

------------------------------------------------------------

process
begin  
wait until Control_Clk'event and Control_Clk='1';	
if(Control_Reset = '1') then
   current_State <= S0_Fetch;
else
   current_State <= next_State;
end if;

PC_sel         <= PC_sel_signal;
PC_LdEn        <= PC_LdEn_signal;
RF_WrEn        <= RF_WrEn_signal;
RF_WrData_sel  <= RF_WrData_sel_signal;
RF_B_sel       <= RF_B_sel_signal;
cloud_enable   <= cloud_enable_signal;
ALU_func       <= ALU_func_signal;
ALU_Bin_sel    <= ALU_Bin_sel_signal;       
Mem_WrEn       <= Mem_WrEn_signal;
Instr_REG_WE   <= Instr_REG_WE_signal;
RF_A_REG_WE    <= RF_A_REG_WE_signal;
RF_B_REG_WE    <= RF_B_REG_WE_signal;
Immed_Reg_WE   <= Immed_Reg_WE_signal;
ALU_out_Reg_WE <= ALU_out_Reg_WE_signal;
MEM_Dataout_REG_WE <= MEM_Dataout_REG_WE_signal;

end process;
	 
end Behavioral;
