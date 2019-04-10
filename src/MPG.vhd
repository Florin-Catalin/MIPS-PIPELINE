
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity MPG is
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC;
           en : out  STD_LOGIC);
end MPG;

architecture Behavioral of MPG is

signal count: std_logic_vector(15 downto 0):= (others =>'0');
signal s1,s2,s3,s4: std_logic;
begin


process(clk)
begin
if clk='1' and clk'event then
	count <= count+'1';
end if;
end process ;

process (count)
begin

if count="1111111111111111" then s1<='1';
else s1<='0';
end if;

end process;

process(clk)
begin
if clk='1' and clk'event then
	if s1='1' then
	s2 <= btn;

	end if;
end if;
end process;


process(clk)
begin
if clk='1' and clk'event then
	s3 <= s2;
end if;
end process;


process(clk)
begin
if clk='1' and clk'event then
	s4 <= s3;
end if;
end process;


en<=not (s4) and s3;

end Behavioral;

