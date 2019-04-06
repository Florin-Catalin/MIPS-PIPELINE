
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity MEM_Unit is
    Port ( MemWrite : in  STD_LOGIC;
           Adress : in  STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in  STD_LOGIC_VECTOR (15 downto 0);
           MemData : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  en : in STD_LOGIC);
end MEM_Unit;

architecture Behavioral of MEM_Unit is

type memorie is array (0 to 63) of std_logic_vector(15 downto 0);
signal var_mem: memorie:=
(x"0000",
x"0001",
x"0002",
x"0003",
x"0004",
x"0005",
x"0006",
x"0007",
others => x"0000");

begin
process (clk)
begin
   if clk'event and clk = '1' then
         if MemWrite = '1' then
				if en = '1' then
					var_mem(conv_integer(Adress(5 downto 0))) <= WriteData;		
			end if;
      end if;
   end if;
end process;

	
MemData <= var_mem(conv_integer(Adress(5 downto 0)));

end;


