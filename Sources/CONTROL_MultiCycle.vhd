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
           Mem_WrEn : out STD_LOGIC_VECTOR(2 downto 0);       
           Instr_REG_WE : out STD_LOGIC;
           RF_A_REG_WE : out STD_LOGIC;
           RF_B_REG_WE : out STD_LOGIC;      
           Immed_Reg_WE : out STD_LOGIC;
           ALU_out_Reg_WE : out STD_LOGIC;
           MEM_Dataout_REG_WE : out STD_LOGIC         
           );
end CONTROL_MultiCycle;

architecture Behavioral of CONTROL_MultiCycle is

type state is(S0_Reset, S1_Fetch, S2_Decode, S3_Execute_Li_Lui, S4_Execute_ALU, S5_WriteBack_ALU, S6_Execute_Addi, S7_Execute_Andi, S8_Execute_Ori,
S9_Execute_B, S10_Execute_Beq, S11_Execute_Bne, S12_Execute_MEM, S13_Execute_Lb, S14_Execute_Sb, S15_Execute_Lw, S16_Execute_Sw, S17_WriteBack_MEM,
S18_MEM_Reset);
--Signals
SIGNAL current_State ,next_State: state;

begin

process(current_State, Instruction)
begin
case current_State is

   when S0_Reset =>
        
        PC_sel <= '0';
        PC_LdEn <= '0';
        RF_WrEn <= '0';
        RF_WrData_sel <= '0';
        RF_B_sel <= '0';
        cloud_enable <= "00";
        ALU_func <= "1111";
        ALU_Bin_sel <= '0';       
        Mem_WrEn <= "000";        
        Instr_REG_WE <= '0';
        RF_A_REG_WE <= '0';
        RF_B_REG_WE <= '0';      
        Immed_Reg_WE <= '0';
        ALU_out_Reg_WE <= '0';
        MEM_Dataout_REG_WE <= '0';
        next_State <= S1_Fetch;
        
   when S1_Fetch => 
   
        PC_sel <= '0';
        PC_LdEn <= '1';
        Instr_REG_WE <= '1';
        next_State <= S2_Decode;
              
   when S2_Decode =>   
        
        PC_sel <= '0';
        PC_LdEn <= '0';
        Instr_REG_WE <= '0';
        RF_A_REG_WE <= '1';
        RF_B_REG_WE <= '1';      
        Immed_Reg_WE <= '1';
        
        if Instruction(31 downto 26) = "100000" then --ALU R-Types
        
           RF_WrEn <= '0';       -- We dont write the reg yet
           RF_B_sel <= '0';      -- no Immed
           cloud_enable <= "00"; -- dontcare , no Immed                 
           next_State <= S4_Execute_ALU;
        
        elsif Instruction(31 downto 26) ="111000" then --li
           
           RF_WrEn <='0';        -- We dont write the reg yet
           RF_B_sel <='1';       -- We have Immed
		   cloud_enable <= "01"; -- SignExtend
		   next_State <= S3_Execute_Li_Lui;
        
        elsif Instruction(31 downto 26) ="111001" then --lui
        
           RF_WrEn <='0';        -- We dont write the reg yet
           RF_B_sel <='1';       -- We have Immed
		   cloud_enable <= "10"; -- Shift/ZeroFill
		   next_State <= S3_Execute_Li_Lui;
        
        elsif Instruction(31 downto 26) = "110000" then --addi
        
           RF_WrEn <='0';        -- We dont write the reg yet
           RF_B_sel <='1';       -- We have Immed
		   cloud_enable <= "01"; -- SignExtend
           next_State <= S6_Execute_Addi;
        
        elsif Instruction(31 downto 26) = "110010" then --andi
        
           RF_WrEn <='0';        -- We dont write the reg yet
           RF_B_sel <='1';       -- We have Immed
		   cloud_enable <= "00"; -- ZeroFill
           next_State <= S7_Execute_Andi;
        
        elsif Instruction(31 downto 26) = "110011" then --ori
        
           RF_WrEn <='0';        -- We dont write the reg yet
           RF_B_sel <='1';       -- We have Immed
		   cloud_enable <= "00"; -- ZeroFill
           next_State <= S8_Execute_Ori;
                             
--        elsif Instruction(31 downto 26) = "111111" then --b	
           
--           RF_B_sel <= '1';        -- We have Immed
--		   RF_WrEn <= '0';         -- We dont write the reg
--		   cloud_enable <= "11";   -- Shift/SignExtend 
--           next_State <= S9_Execute_B;
                   				
--  	    elsif Instruction(31 downto 26) ="010000" then --beq
  	    
--           RF_B_sel <= '1';        -- We have Immed
--		   RF_WrEn <= '0';         -- We dont write the reg
--		   cloud_enable <= "11";   -- Shift/SignExtend  	       
--  	       next_State <= S10_Execute_Beq;
  	       				
--  		elsif Instruction(31 downto 26) ="010001" then --bne
  		
--           RF_B_sel <= '1';        -- We have Immed
--		   RF_WrEn <= '0';         -- We dont write the reg
--		   cloud_enable <= "11";   -- Shift/SignExtend  		
--  		   next_State <= S11_Execute_Bne;
			
	    elsif Instruction(31 downto 26) = "000011" or Instruction(31 downto 26) = "001111" or 
	    Instruction(31 downto 26) = "000111" or Instruction(31 downto 26) = "011111" then -- MEM-types
	    
	       cloud_enable <="01";    --SignExtend 
		   RF_WrEn<='0';           --We dont write the reg
		   RF_B_sel<='1';          -- We have Immed   	
	       next_State <= S12_Execute_MEM;
	       
	    	   			
		
        end if;
        
    when S3_Execute_Li_Lui =>
         
         RF_A_REG_WE <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE <='1';        -- We hold the value
		 Alu_Bin_Sel <='1';           -- We have Immed
		 ALU_func <= "0000";          -- Add the immediate to zero = Immed
		 next_State <= S5_WriteBack_ALU;
         
    when S4_Execute_ALU =>  
    
         RF_A_REG_WE <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE <='1';        -- We hold the value 
		 Alu_Bin_Sel <='0';           -- No Immed
		 ALU_func <= Instruction(3 downto 0);
		 next_State <= S5_WriteBack_ALU;
		 
    when S5_WriteBack_ALU =>      
               
         RF_WrData_sel <= '0';        -- We want from ALU_out
	     RF_WrEn <= '1';              -- We write to the reg 
		 Immed_Reg_WE <= '1';         -- We hold the value 
		 next_State <= S1_Fetch;
		 
    when S6_Execute_Addi =>
      
         RF_A_REG_WE <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE <='1';        -- We hold the value 
		 Alu_Bin_Sel <='1';           -- We have Immed
		 ALU_func <= "0000";          -- add
		 next_State <= S5_WriteBack_ALU;
    
    when S7_Execute_Andi =>   
    
         RF_A_REG_WE <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE <='1';        -- We hold the value 
		 Alu_Bin_Sel <='1';           -- We have Immed
		 ALU_func <= "0010";          -- and
		 next_State <= S5_WriteBack_ALU;
    
    when S8_Execute_Ori =>
    
         RF_A_REG_WE <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE <='0';          -- We dont hold the value anymore
		 ALU_out_Reg_WE <='1';        -- We hold the value 
		 Alu_Bin_Sel <='1';           -- We have Immed
		 ALU_func <= "0011";          -- or
		 next_State <= S5_WriteBack_ALU;
		 
--    when S9_Execute_B =>
               
--         PC_sel <= '1';               -- We do the jump
--		 PC_LdEn <= '1';              -- We fetch the next instruction in the jump
--		 Instr_REG_WE <= '1';         -- We hold the value 
--         next_State <= S1_Fetch;
         
--    when S10_Execute_Beq =>
         
--         if (Instruction(25 downto 21) = Instruction(20 downto 16)) then
--           PC_sel <= '1';
--         else
--           PC_sel <= '0';
--         end if;
--         Instr_REG_WE <= '1';         -- We hold the value
--         PC_LdEn <= '1';              -- We fetch the next instruction in the jump
--         next_State <= S1_Fetch;
         
--    when S11_Execute_Bne =>
    
--         if (Instruction(25 downto 21) /= Instruction(20 downto 16)) then
--           PC_sel <= '1';
--         else
--           PC_sel <= '0';
--         end if;
--         PC_LdEn <= '1';              -- We fetch the next instruction in the jump
--         Instr_REG_WE <= '1';         -- We hold the value
--         next_State <= S1_Fetch;
    
    when S12_Execute_MEM =>
            
         RF_A_REG_WE <='0';           -- We dont hold the value anymore
		 RF_B_REG_WE <='0';           -- We dont hold the value anymore
		 Immed_Reg_WE <='1';          -- We hold the value
		 ALU_out_Reg_WE <='1';        -- We hold the value
		 Alu_Bin_Sel <='1';           -- We have Immed
		 ALU_func <= "0000";          -- Add
         if Instruction(31 downto 26) = "000011" then -- lb              
            next_State <= S13_Execute_Lb;                        
         elsif Instruction(31 downto 26) = "000111" then -- sb           
            next_State <= S14_Execute_Sb;                             
         elsif Instruction(31 downto 26) = "001111" then -- lw           
            next_State <= S15_Execute_Lw;                         
         elsif Instruction(31 downto 26) = "011111" then -- sw           
            next_State <= S16_Execute_Sw;
         end if;
                   
    when S13_Execute_Lb =>         
         Mem_WrEn <= "001";  -- We don't write to the MEM
         MEM_Dataout_REG_WE <= '1';   -- We hold the value 
         next_State <= S17_WriteBack_MEM;
       
    when S14_Execute_Sb =>
         Mem_WrEn <= "010";  -- We write to the MEM
         MEM_Dataout_REG_WE <= '1';   -- We hold the value
         next_State <= S18_MEM_Reset;
       
    when S15_Execute_Lw =>
         Mem_WrEn <= "011";  -- We don't write to the MEM
         MEM_Dataout_REG_WE <= '1';   -- We hold the value
         next_State <= S17_WriteBack_MEM;
            
    when S16_Execute_Sw =>
         Mem_WrEn <= "100";  -- We write to the MEM
         MEM_Dataout_REG_WE <= '1';   -- We hold the value
         next_State <= S18_MEM_Reset;
            
    when S17_WriteBack_MEM =>
         
         RF_WrData_sel <= '1';        -- We want from MEM_out
	     RF_WrEn <= '1';              -- We write to the reg 
		 Immed_Reg_WE <= '0';         -- We dont hold the value		 
		 next_State <= S1_Fetch; 
		    
	when S18_MEM_Reset =>
	     
         Mem_WrEn <= "000";           -- Memory reset     
		 next_State <= S1_Fetch;
    
    when others =>
         
         next_State <= S0_Reset;
		    	                 
end case;
end process;

------------------------------------------------------------

process
begin  
wait until Control_Clk'event and Control_Clk='1';	
if(Control_Reset = '1') then
   current_State <= S0_Reset;
else
   current_State <= next_State;
end if;

end process;
	 
end Behavioral;
