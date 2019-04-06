
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity EX_Unit is
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
           AluRes : out  STD_LOGIC_VECTOR (15 downto 0));
end EX_Unit;

architecture Behavioral of EX_Unit is
signal AluCtrl: std_logic_vector(2 downto 0);
signal AluIn, rezultat: std_logic_vector(15 downto 0);

begin
-- ALU control
process(AluOp, func)
begin
case AluOp is
when "000" => -- R-type
	case func is
		when "000" => AluCtrl <= "000";  -- add
		when "001" => AluCtrl <= "001";  -- sub
		when "010" => AluCtrl <= "010";  -- and
		when "011" => AluCtrl <= "011";  -- or
		when "100" => AluCtrl <= "100";  -- sll
		when "101" => AluCtrl <= "101";  -- srl
		when "110" => AluCtrl <= "110";  -- xor
		when "111" => AluCtrl <= "111";  -- slt
		when others => null;
	end case;
when "001" => AluCtrl <= "000"; -- add -- addi, lw, sw
when "010" => AluCtrl <= "010"; -- and -- andi
when "011" => AluCtrl <= "011"; -- or -- ori
when "100" => AluCtrl <= "001"; -- sub -- beq
when others => null;
end case;
end process;

AluIn <= RD2 when AluSrc = '0' else Ext_Imm;


-- Unitatea Aritmetico Logica
process(AluCtrl)
begin

case AluCtrl is
when "000" => rezultat <= RD1 + AluIn;
when "001" => rezultat <= RD1 - AluIn;
when "010" => rezultat <= RD1 and AluIn;
when "011" => rezultat <= RD1 or AluIn;
when "100" => 
if sa = '1' then 
	rezultat <= RD1(14 downto 0) & '0';
else 
	rezultat <= RD1;
end if;

when "101" => 
if sa = '1' then 
	rezultat <= '0' & RD1(15 downto 1);
else 
	rezultat <= RD1;
end if;

when "110" => rezultat <= RD1 xor AluIn;
when "111" => 
	if (RD1 < AluIn) then rezultat <= x"0001";
	else rezultat <= x"0000";
	end if;
when others => null;
end case;

end process;

Zero <= '1' when rezultat = x"0000" else '0';
AluRes <= rezultat;
BranchAdress <= nextPc + Ext_Imm;

end Behavioral;

