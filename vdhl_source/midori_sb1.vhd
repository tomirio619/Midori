library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midori_sb1 is
	Port(
		a : in STD_LOGIC_VECTOR(3 downto 0);
		o : out STD_LOGIC_VECTOR(3 downto 0)
	);
end midori_sb1;

architecture behavior of midori_sb1 is

type table is array (0 to 15) of STD_LOGIC_VECTOR(127 downto 0);

constant sb1_table : table := (
X"1", 
X"0", 
X"5", 
X"3", 
X"e", 
X"2", 
X"f", 
X"7", 
X"d", 
X"a", 
X"9", 
X"b", 
X"c", 
X"8", 
X"4", 
X"6"
);

begin 

o <= sb1_table(to_integer(unsigned(a)));

end;

