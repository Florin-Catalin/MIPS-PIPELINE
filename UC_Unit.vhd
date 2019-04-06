library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UC_Unit is
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
end UC_Unit;

architecture Behavioral of UC_Unit is

begin

process (Instr)
begin

case Instr is
when "000" => RegDst <= '1';  -- R-Type
				  RegWrite <= '1';
				  AluSrc <= '0';
				  Branch <= '0';
				  Jump <= '0';
				  ExtOp <= '0';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 				   
				  AluOp <= "000";				 
				  
when "001" => RegDst <= '0';  -- addi
				  RegWrite <= '1';
				  AluSrc <= '1';
				  Branch <= '0';
				  Jump <= '0';
				  ExtOp <= '1';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 				   
				  AluOp <= "001";

when "010" => RegDst <= '0';  -- andi
				  RegWrite <= '1';
				  AluSrc <= '1';
				  Branch <= '0';
				  Jump <= '0';
				  ExtOp <= '0';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 				   
				  AluOp <= "010";

when "011" => RegDst <= '0';  -- ori
				  RegWrite <= '1';
				  AluSrc <= '1';
				  Branch <= '0';
				  Jump <= '0';
				  ExtOp <= '0';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 				   
				  AluOp <= "011";

when "100" => RegDst <= '0'; -- sw
				  RegWrite <= '0';
				  AluSrc <= '1';
				  Branch <= '0';
				  Jump <= '0';
				  ExtOp <= '1';
				  MemWrite <= '1';
				  MemtoReg <= '0'; 				   
				  AluOp <= "001";	

when "101" => RegDst <= '0';  -- lw
				  RegWrite <= '1';
				  AluSrc <= '1';
				  Branch <= '0';
				  Jump <= '0';
				  ExtOp <= '1';
				  MemWrite <= '0';
				  MemtoReg <= '1'; 				   
				  AluOp <= "001";

when "110" => RegDst <= '0'; -- beq
				  RegWrite <= '0';
				  AluSrc <= '0';
				  Branch <= '1';
				  Jump <= '0';
				  ExtOp <= '1';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 				   
				  AluOp <= "100";

when "111" => RegDst <= '0';  -- jump
				  RegWrite <= '0';
				  AluSrc <= '0';
				  Branch <= '0';
				  Jump <= '1';
				  ExtOp <= '0';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 				   
				  AluOp <= "111";				  

when others => null;
end case;
end process;

end Behavioral;

