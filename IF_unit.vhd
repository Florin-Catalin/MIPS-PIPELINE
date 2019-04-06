library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IF_unit is
    Port  (clk : in STD_LOGIC;
			  en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           next_PC : out  STD_LOGIC_VECTOR (15 downto 0);
           Instruction : out  STD_LOGIC_VECTOR (15 downto 0);
           J_Address : in  STD_LOGIC_VECTOR (15 downto 0);
           B_Address : in  STD_LOGIC_VECTOR (15 downto 0);
           Jump : in  STD_LOGIC;
           Branch: in  STD_LOGIC);
end IF_unit;

architecture Behavioral of IF_unit is
type memorie is array (0 to 255) of std_logic_vector(15 downto 0);
signal var_mem: memorie:=(
-- initilizare registri
B"000_000_000_000_0_110", --0-- xor $0, $0, $0 -- RF[$0] = 0
B"000_111_111_111_0_100", --1-- noOp
B"000_111_111_111_0_100", --2-- noOp
B"011_000_001_0000001", --3-- ori $1, $0, "0000001"  -- RF[$1] = 1
B"011_000_010_0000110", --4-- ori $2, $0, "0000110"  -- RF[$2] = 6  -- se va salva nr de elemente a vectorului

B"000_000_000_000_0_100", --5-- noOp
B"000_000_000_000_0_100", --6-- noOp
-- scrierea in memoria a numerlor de la 1 -> 5
B"110_010_001_0000111", --7-- beq $1, $2, "0000111"  -- se compara reg $1 cu reg $2 (1 ? 6), se sare dupa bucla, var_mem(7)
B"000_000_000_000_0_100", --8-- noOp
B"000_000_000_000_0_100", --9-- noOp
B"000_000_000_000_0_100", --10-- noOp
B"100_001_001_0000000", --11-- sw $1, "0000000"($1)  -- se salveaza in memorie val din reg $1
B"001_001_001_0000001", --12-- addi $1, $1, "0000001"  -- se incrementeaza reg $1
B"111_0000000000111",  	--13-- j "0000000000111"  -- se sare la comparatie, var_mem(3)
B"000_000_000_000_0_100", --14-- noOp

-- initializare registrii
B"011_000_001_0000001",  --15-- ori $1, $0, "0000001"  -- RF[$1] = 1
B"000_100_100_100_0_110",  --16-- xor $4, $4, $4 -- RF[$4] = 0  -- $4 -> SUMA

B"000_000_000_000_0_100", --17-- noOp
-- citirea numerelor din memorie si calcularea sumei lor
B"110_010_001_0001001",  --18-- beq $1, $2, "00001000"  -- se compara val din reg $1 cu val din reg $2 se sare la var_mem(14)
B"000_000_000_000_0_100", --19-- noOp
B"000_000_000_000_0_100", --20-- noOp
B"000_000_000_000_0_100", --21-- noOp
B"101_001_011_0000000", --22-- lw $3, "0000000"($1)  -- se incarca in reg $3 val din memorie (introdusa anterior)	
B"000_000_000_000_0_100", --23-- noOp
B"000_000_000_000_0_100", --24-- noOp
B"000_100_011_100_0_000",  --25-- add $4, $4, $3  -- se adauga acel element la suma
B"001_001_001_0000001",  --26-- addi $1, $1, "0000001"  -- se incrementeaza reg $1
B"111_0000000010001", --27-- j "0000000010001"  -- se sare la comparatie var_mem(9)
B"000_000_000_000_0_100", --28-- noOp

-- calcularea mediei aritmetice: 
-- se calculeaza catul(salvat in reg $1) din val din reg $4 (suma tuturor) si val din reg $2 (numarul de numere adunate)

B"000_001_001_001_0_110",  --29-- xor $1, $1, $1  -- RF[$1] = 0, se initializeaza catul cu 0
B"001_010_010_1111111",  --30-- add $2, $2, "1111111" -- adunare cu -1
B"000_000_000_000_0_100", --31-- noOp
B"000_000_000_000_0_100", --32-- noOp
B"000_010_100_101_0_111",  --33-- slt $5, $4, $2  -- daca RF[$4] < RF[$2] => RF[$5] = 1 else RF[$5] = 0
									-- daca impartitorul e mai mic decat deimpartitul se seteaaza $5 la val 1, daca nu RF[$5] = 0
B"000_000_000_000_0_100", --34-- noOp
B"000_000_000_000_0_100", --35-- noOp
B"110_000_101_0001100",  --36-- beq $5, $0, "0000100"  -- daca val din $4 va fi mai mica decat $2 se va sari la instructiunea din eticheta, iar daca nu se vor 	
								 -- efectua scaderi repetate pentru a afla catul, var_mem(21)
B"000_000_000_000_0_100", --37-- noOp
B"000_000_000_000_0_100", --38-- noOp
B"000_000_000_000_0_100", --39-- noOp
B"000_100_010_100_0_001",  --40-- sub $4, $4, $2  -- se scade deimpartitul
B"001_001_001_0000001",  --41-- addi $1, $1, "0000001"  -- se incrementeaza reg $1 (la iesirea din bucla RF[$1] = catul)
B"000_000_000_000_0_100", --42-- noOp
B"110_100_010_1111000",  --43-- beq &4, &0 "1111000"
B"000_000_000_000_0_100", --44-- noOp
B"000_000_000_000_0_100", --45-- noOp
B"000_000_000_000_0_100", --46-- noOp
B"111_0000000100001",  --47-- j "0000000100001"
B"000_000_000_000_0_100", --48-- noOp

B"100_000_001_0000111",  --46-- sw $1, "0000111"($0)  -- se salveaza catul(media numerelor) in memorie
B"000_001_001_001_0_100", --47-- noOp 
B"000_001_001_001_0_100", --48-- noOp 
B"111_0000000000000", --49-- j inceput
B"000_001_001_001_0_100", --50-- noOp 
-------------------------------------------------------------------------------------------------

-- inmultirea cu 2 prin 2 metode(adunare repetata si << 1) si verificarea acesteia
B"011_000_001_0000101",  -- ori $1, $0, "0000101"  -- se pune val 5 in reg $1 => RF[$1] = 5
B"000_001_001_001_0_000", -- add $1, $1, $1  -- in reg $1 se pune 2* $1 =. RF[$1] = RF[$1] + RF[$1] = 2 * RF[$1] = "A"
B"011_000_010_0000101",  -- ori $2, $0, "0000101"  -- se pune val 5 in reg $2 => RF[$2] = 5
B"000_010_000_010_1_100",  -- sll $2, $2, 1  -- se shifteaza reg $2 la stanga, cu o pozitie = RF[$2] = "A"
B"110_001_010_0000001",  -- beq $1, $2, "0000001" -- compara reg $1 si $2. Daca sunt egale se sare la 
								-- instructiunea var_mem(29) =" ori $3, $0, "0000001", daca nu se sare la instructiunea urmatoare
B"000_010_010_010_0_110",  -- xor $2, $2, $2  -- rezultatul se scrie in reg $2 (daca rezultatele obtinute nu sunt egale RF[$3] = 0)
B"100_000_010_0001000",  -- sw $2, $0, "0001000"  -- se salveaza in memorie rezultatul comparatiei(M(8) = 'A')  


-- inmultirea a doua numere
B"011_000_001_0000011", -- ori $1, $0, "0000011"  -- in reg $1 avem val 3 => RF[$1] = 3
B"011_000_010_0000111", -- ori $2, $0, "0000111"  -- in reg $2 avem val 7 = > RF[$2] = 7
B"000_011_011_011_0_110",  -- xor $3, $3, $3  -- golim reg $3 => RF[$3] = 0, folosit pt contor
B"000_100_100_100_0_110",  -- xor $4, $4, $4  -- golim reg $4 => RF[$4] = 0, folosit pt produs
B"110_001_011_0000011",  -- beq $3, $1 "0000011"  -- sarim la final cand am terminat adunarea repetata => var_mem(39) = sw $4, $0, "0001111" 
B"000_100_010_100_0_000", -- add $4, $4, $2  -- RF[$4] = RF[$4] + RF[$2]
B"001_011_011_0000001", -- addi $3, $3, "0000001"  -- incrementam reg $3 => RF[$3]++
B"111_0000000100010", -- j "0000000100010"  -- sarim la comparatie var_mem(35) = beq $3, $1 ""
B"100_000_100_0001001", -- sw $4, $0, "0001001"  -- salvam rzultatul produsului la adresa M[9] = (3 * 7)d = (21)d = (15)x 

others => x"0000");

signal PC: std_logic_vector(15 downto 0):=x"0000";
signal branch_mux: std_logic_vector(15 downto 0):=x"0000";
signal jump_mux: std_logic_vector(15 downto 0):=x"0000";

begin

next_PC <= PC + 1;
Instruction <= var_mem( conv_integer(PC(7 downto 0)));
branch_mux <= PC + 1 when Branch = '0' else B_address;
jump_mux <= branch_mux when Jump = '0' else J_address;

process(clk)
begin
if rst='1' then PC<=x"0000";
else 
if clk='1' and clk'event then
if en='1' then
PC <= jump_mux;
end if;
end if;
end if;
end process;


end Behavioral;

