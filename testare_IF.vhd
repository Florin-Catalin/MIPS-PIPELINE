library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity testare is
Port ( sw : in  STD_LOGIC_VECTOR (7 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0);
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
			  dp: out STD_LOGIC;
           clk : in  STD_LOGIC);
end testare;

 architecture Behavioral of testare is

component SSG is
    Port ( Digit : in  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in std_logic;
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0));
end component;


component MPG is
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC;
           en : out  STD_LOGIC);
end component;


component IF_unit is
    Port  (clk : in STD_LOGIC;
			  en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           next_PC : out  STD_LOGIC_VECTOR (15 downto 0);
           Instruction : out  STD_LOGIC_VECTOR (15 downto 0);
           J_Address : in  STD_LOGIC_VECTOR (15 downto 0);
           B_Address : in  STD_LOGIC_VECTOR (15 downto 0);
           Jump : in  STD_LOGIC;
           Branch : in  STD_LOGIC);
end component IF_unit;



component ID_Unit is
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
end component ID_Unit;


component UC_Unit is
    Port ( Instr : in  STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out  STD_LOGIC;
           ExtOp : out  STD_LOGIC;
           AluSrc : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
           Jump : out  STD_LOGIC;
           AluOp : out  STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC);
end component UC_Unit;




component EX_Unit is
    Port ( nextPc : in  STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in  STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in  STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in  STD_LOGIC_VECTOR (15 downto 0);
           sa : in  STD_LOGIC;
           func : in  STD_LOGIC_VECTOR (2 downto 0);
           AluSrc : in  STD_LOGIC;
           AluOp : in  STD_LOGIC_VECTOR (2 downto 0);
           BranchAdress : out  STD_LOGIC_VECTOR (15 downto 0);
           Zero : out  STD_LOGIC;
           AluRes : out  STD_LOGIC_VECTOR (15 downto 0);
			  RT: in STD_LOGIC_VECTOR (2 downto 0);
			  RD: in STD_LOGIC_VECTOR (2 downto 0);
			  RegDst: in STD_LOGIC;
			  WA: out STD_LOGIC_VECTOR (2 downto 0));
end component EX_Unit;



component MEM_Unit is
    Port ( MemWrite : in  STD_LOGIC;
           Adress : in  STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in  STD_LOGIC_VECTOR (15 downto 0);
           MemData : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  en : in STD_LOGIC);
end component MEM_Unit;

signal en,rst, Zero: std_logic;
signal afisare: std_logic_vector(15 downto 0):=(others =>'0');
signal next_PC: std_logic_vector(15 downto 0):=(others =>'0');
signal Instr, Ext_Imm, RD1, RD2, WD, AluRes, BranchAddress, JumpAddress, MemData: std_logic_vector(15 downto 0):=(others =>'0');
signal RegDst, ExtOp, AluSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, sa, PCSrc: std_logic;
signal AluOp: std_logic_vector(2 downto 0);
signal Func: std_logic_vector (2 downto 0);
signal WA: std_logic_vector (2 downto 0);


signal RegIF_ID: std_logic_vector(31 downto 0):=(others =>'0');
signal RegID_EX: std_logic_vector(82 downto 0):=(others =>'0');
signal RegEX_MEM: std_logic_vector(55 downto 0):=(others =>'0');
signal RegMEM_WB: std_logic_vector(36 downto 0):=(others =>'0');



begin
MPG1: MPG port map(clk,btn(0),en);
MPG2: MPG port map(clk,btn(1),rst);
SSG1: SSG port map(afisare,clk,an,cat);
IF1: IF_unit port map(clk, en, rst, next_PC, Instr, JumpAddress, RegEX_MEM (51 downto 36), Jump, PCSrc);
ID1: ID_Unit port map(clk, RegMEM_WB (35), ExtOp, RegIF_ID (15 downto 0), WD, RegMEM_WB (2 downto 0), RD1, RD2, Ext_Imm, Func, sa, en);
UC1: UC_Unit port map(RegIF_ID(15 downto 13), RegDst, ExtOp, AluSrc, Branch, Jump, AluOp, MemWrite, MemtoReg, RegWrite);
EX: EX_Unit port map(RegID_EX (72 downto 57), RegID_EX (56 downto 41), RegID_EX (40 downto 25), 
RegID_EX (24 downto 9), RegID_EX (82), RegID_EX (8 downto 6), RegID_EX (74), RegID_EX (77 downto 75), BranchAddress, Zero, AluRes, 
RegID_EX (5 downto 3), RegID_EX (2 downto 0), RegID_EX (73), WA);
MEM: MEM_Unit port map(RegEX_MEM (53), RegEX_MEM (35 downto 20), RegEX_MEM (18 downto 3), MemData, clk, en);




---------------------------------- IF/ID Register ---------------------------------------------
process (clk, en, Instr, next_PC)
begin
if clk = '1' and clk'event then
	if en = '1' then
		RegIF_ID (31 downto 16) <= next_PC;
		RegIF_ID (15 downto 0) <= Instr;
	end if;
end if;
end process;
	

---------------------------------- ID/EX Register ---------------------------------------------
process (clk, en, sa, MemtoReg, RegWrite, MemWrite, Branch, AluOp, RegDst, RegIF_ID, RD1, RD2, Ext_Imm, Func)
begin
if clk = '1' and clk'event then
	if en = '1' then
		RegID_EX (82) <= sa;
		RegID_EX (81) <= MemtoReg;
		RegID_EX (80) <= RegWrite;
		RegID_EX (79) <= MemWrite;
		RegID_EX (78) <= Branch;
		RegID_EX (77 downto 75) <= AluOp;
		RegID_EX (74) <= AluSrc;
		RegID_EX (73) <= RegDst;
		RegID_EX (72 downto 57) <= RegIF_ID (31 downto 16); -- ID_next_PC
		RegID_EX (56 downto 41) <= RD1;
		RegID_EX (40 downto 25) <= RD2;
		RegID_EX (24 downto 9) <= Ext_Imm;
		RegID_EX (8 downto 6) <= Func;
		RegID_EX (5 downto 3) <= RegIF_ID (9 downto 7);  --RT
		RegID_EX (2 downto 0) <= RegIF_ID (6 downto 4);  --RD
	end if;
end if;
end process;



---------------------------------- EX/MEM Register ---------------------------------------------
process (clk, en, RegID_EX, BranchAddress, AluRes, Zero, WA)
begin
if clk = '1' and clk'event then
	if en = '1' then
		RegEX_MEM (55) <= RegID_EX (81); --MemtoReg
		RegEX_MEM (54) <= RegID_EX (80); --RegWrite
		RegEX_MEM (53) <= RegID_EX (79); --MemWrite
		RegEX_MEM (52) <= RegID_EX (78); --Branch
		RegEX_MEM (51 downto 36) <= BranchAddress;
		RegEX_MEM (35 downto 20) <= AluRes;
		RegEX_MEM (19) <= Zero;
		RegEX_MEM (18 downto 3) <= RegID_EX (40 downto 25); --RD2
		RegEX_MEM (2 downto 0) <= WA;
	end if;
end if;
end process;


---------------------------------- MEM/WB Register ---------------------------------------------
process (clk, en, RegEX_MEM, MemData)
begin
if clk = '1' and clk'event then
	if en = '1' then
		RegMEM_WB (36) <= RegEX_MEM (55); --MemtoReg
		RegMEM_WB (35) <= RegEX_MEM (54); --RegWrite
		RegMEM_WB (34 downto 19) <= MemData;
		RegMEM_WB (18 downto 3) <= RegEX_MEM (35 downto 20); -- ALuRes
		RegMEM_WB (2 downto 0) <= RegEX_MEM (2 downto 0); -- WA

	end if;
end if;
end process;



WD <= RegMEM_WB (34 downto 19) when RegMEM_WB (36) = '1' else RegMEM_WB (18 downto 3);
JumpAddress <= RegIF_ID (31 downto 29) & RegIF_ID(12 downto 0);
PCSrc <= RegEX_MEM (19) and RegEX_MEM (52);

with sw (7 downto 4) select
afisare <=  RegIF_ID (15 downto 0) when "0000",
				RegIF_ID (31 downto 16) when "0010",
				RD1 when "0100",
				RD2 when "0110",
				RegID_EX (24 downto 9) when "1000",
				AluRes when "1010",
				MemData when "1100",
				WD when "1110",				
				
				Instr when "0001",
				next_PC when "0011",
				RD1 when "0101",
				RD2 when "0111",
				RegID_EX (24 downto 9) when "1001",
				AluRes when "1011",
				MemData when "1101",
				WD when "1111",				
				x"0000" when others;
	



process (sw(0))
begin

if sw(0) = '0' then
led(0) <= RegDst;
led(1) <= ExtOp;
led(2) <= AluSrc;
led(3) <= Branch;
led(4) <= Jump;
led(5) <= MemWrite;
led(6) <= MemtoReg;
led(7) <= RegWrite;

else
led <= AluOp & "00000";
end if;

end process;


dp <= '0';
end Behavioral;

