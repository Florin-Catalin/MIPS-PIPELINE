----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
entity RF is
port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0);
en : in STD_LOGIC);
end RF;
architecture Behavioral of RF is
type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array:=(x"0001",
x"0002",
x"0003",
x"0004",
x"0005",
x"0006",
x"0007",
x"0008",
others => x"0000");
begin
process(clk)
begin
if clk = '0' and clk'event then
if wen = '1' then
if en = '1' then
reg_file(conv_integer(wa)) <= wd;
end if;
end if;
end if;
end process;
rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));
end Behavioral;
