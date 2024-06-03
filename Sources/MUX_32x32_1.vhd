library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_32x32_1 is
    Port ( 
        MUX_in_0 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_1 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_2 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_3 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_4 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_5 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_6 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_7 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_8 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_9 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_10 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_11 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_12 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_13 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_14 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_15 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_16 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_17 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_18 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_19 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_20 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_21 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_22 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_23 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_24 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_25 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_26 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_27 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_28 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_29 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_30 : in  STD_LOGIC_VECTOR (31 downto 0);
        MUX_in_31 : in  STD_LOGIC_VECTOR (31 downto 0);
        sel      : in  STD_LOGIC_VECTOR (4 downto 0);
        output   : out STD_LOGIC_VECTOR (31 downto 0)
    );
end MUX_32x32_1;

architecture Behavioral of MUX_32x32_1 is
begin
    with sel select
        output <= MUX_in_0 when "00000",
                  MUX_in_1 when "00001",
                  MUX_in_2 when "00010",
                  MUX_in_3 when "00011",
                  MUX_in_4 when "00100",
                  MUX_in_5 when "00101",
                  MUX_in_6 when "00110",
                  MUX_in_7 when "00111",
                  MUX_in_8 when "01000",
                  MUX_in_9 when "01001",
                  MUX_in_10 when "01010",
                  MUX_in_11 when "01011",
                  MUX_in_12 when "01100",
                  MUX_in_13 when "01101",
                  MUX_in_14 when "01110",
                  MUX_in_15 when "01111",
                  MUX_in_16 when "10000",
                  MUX_in_17 when "10001",
                  MUX_in_18 when "10010",
                  MUX_in_19 when "10011",
                  MUX_in_20 when "10100",
                  MUX_in_21 when "10101",
                  MUX_in_22 when "10110",
                  MUX_in_23 when "10111",
                  MUX_in_24 when "11000",
                  MUX_in_25 when "11001",
                  MUX_in_26 when "11010",
                  MUX_in_27 when "11011",
                  MUX_in_28 when "11100",
                  MUX_in_29 when "11101",
                  MUX_in_30 when "11110",
                  MUX_in_31 when "11111",
                  (others => 'X') when others;
end Behavioral;
