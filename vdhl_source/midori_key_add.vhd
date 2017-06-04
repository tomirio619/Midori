library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This is where we describe the ports of the new entity we are creating
-- IMPORTANT know the difference between "to" and "downto" when creating a vector. 
-- Read this: http://stackoverflow.com/questions/7642000/downto-vs-to-in-vhdl 
entity midori_keyadd is
	Port(
		a : in STD_LOGIC_VECTOR(127 downto 0);
		key : in STD_LOGIC_VECTOR(127 downto 0);		
		o : out STD_LOGIC_VECTOR(127 downto 0)
	);
end midori_keyadd;

architecture behavior of midori_keyadd is

begin

o <= a xor key;

end;