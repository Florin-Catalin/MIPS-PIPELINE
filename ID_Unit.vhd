library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity ID_Unit is
    Port ( clk : in STD_LOGIC;
			  RegWrite : in  STD_LOGIC;
           ExtOp : in  STD_LOGIC;
           Instr : in  STD_LOGIC_VECTOR (15 downto 0);
           WD : in  STD_LOGIC_VECTOR (15 downto 0);
			  WA: in STD_LOGIC_VECTOR (2 downto 0);
           RD1 : out  STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out  STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out  STD_LOGIC_VECTOR (15 downto 0);
           Func : out  STD_LOGIC_VECTOR (2 downto 0);
           sa : out  STD_LOGIC;
			  en : in STD_LOGIC);
end ID_Unit;

architecture Behavioral of ID_Unit is

component RF is
	Port (clk : in std_logic;
			ra1 : in std_logic_vector (2 downto 0);
			ra2 : in std_logic_vector (2 downto 0);
			wa : in std_logic_vector (2 downto 0);
			wd : in std_logic_vector (15 downto 0);
			wen : in std_logic;
			rd1 : out std_logic_vector (15 downto 0);
			rd2 : out std_logic_vector (15 downto 0);
			en : in STD_LOGIC);
end component RF;

begin

RF1: RF port map (clk, Instr(12 downto 10), Instr(9 downto 7), WA, WD, RegWrite, RD1, RD2, en);
sa <= Instr(3);
Func <= Instr(2 downto 0);

Ext_Imm <= "000000000" & Instr(6 downto 0) when ExtOp = '0' else (15 downto 7 => Instr(6)) & Instr(6 downto 0);

end Behavioral;

