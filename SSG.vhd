library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity SSG is
    Port ( Digit : in  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in std_logic;
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0));
end SSG;


architecture Behavioral of SSG is
signal count: std_logic_vector(15 downto 0):=(others =>'0');
signal mux1,mux2:std_logic_vector(3 downto 0);
begin


process(clk)
begin
if clk='1' and clk'event then
count <= count + '1';
end if;
end process;

process (count)
begin

case count(15 downto 14) is
when "00" => mux1 <= Digit(15 downto 12);
when "01" => mux1 <= Digit(11 downto 8);
when "10" => mux1 <= Digit(7 downto 4);
when "11" => mux1 <= Digit(3 downto 0);
when others => mux1 <= "0000";

end case;
end process;



process (count)
begin

case count(15 downto 14) is
when "00" => mux2 <= "0111";
when "01" => mux2 <= "1011";
when "10" => mux2 <= "1101";
when "11" => mux2 <= "1110";
when others => mux2 <= "0000";

end case;
end process;

   
    with mux1 select
   cat <= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0
    
	an <= mux2;		


end Behavioral;

