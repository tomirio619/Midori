library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This is where we describe the ports of the new entity we are creating
-- IMPORTANT know the difference between "to" and "downto" when creating a vector. 
-- Read this: http://stackoverflow.com/questions/7642000/downto-vs-to-in-vhdl 
entity midori_ssbi is
	Port(
		a : in STD_LOGIC_VECTOR(7 downto 0);		
		i : in STD_LOGIC_VECTOR (3 downto 0);
		o : out STD_LOGIC_VECTOR(7 downto 0)
	);
end midori_ssbi;

architecture behavior of midori_ssbi is

-- An entity can reuse other entities. We do this by creating a component of this entity
-- and specify which ports this component uses.
component midori_sb1
	Port(
		a : in STD_LOGIC_VECTOR(3 downto 0);
		o : out STD_LOGIC_VECTOR(3 downto 0)
	);
end component;

-- The signals used within this new entity.

signal input_sb10 : STD_LOGIC_VECTOR (3 downto 0);
signal output_sb10 : STD_LOGIC_VECTOR (3 downto 0);
signal input_sb11 : STD_LOGIC_VECTOR (3 downto 0);
signal output_sb11 : STD_LOGIC_VECTOR (3 downto 0);

begin
-- The actual "implementation" of this entity
-- Not et
input_sb10 <= 	a(3) & a(6) & a(1) & a(4) when to_integer(unsigned(i)) mod 4 = 0 else
			  	a(6) & a(1) & a(0) & a(7) when to_integer(unsigned(i)) mod 4 = 1 else
			  	a(5) & a(4) & a(3) & a(6) when to_integer(unsigned(i)) mod 4 = 2 else
			  	a(0) & a(3) & a(6) & a(5); -- when ctr = 3


input_sb11 <= 	a(7) & a(2) & a(5) & a(0) when to_integer(unsigned(i)) mod 4 = 0 else
			  	a(2) & a(5) & a(4) & a(3) when to_integer(unsigned(i)) mod 4 = 1 else
			  	a(1) & a(0) & a(7) & a(2) when to_integer(unsigned(i)) mod 4 = 2 else
			  	a(4) & a(7) & a(2) & a(1); -- when ctr = 3

-- Port maps explained: http://vhdlguru.blogspot.nl/2010/03/usage-of-components-and-port-mapping.html
-- We can read the statement "a => b" as "a refers to b", linking a and b together
sb10 : midori_sb1
	Port Map(
		a => input_sb10,
		o => output_sb10
	);


sb11 : midori_sb1
	Port Map(
		a => input_sb11,
		o => output_sb11
	);

o <= 	output_sb11(3) & output_sb10(2) & output_sb11(1) & output_sb10(0) & output_sb10(3) & output_sb11(2) & output_sb10(1) & output_sb11(0) when to_integer(unsigned(i)) mod 4 = 0 else
		output_sb10(0) & output_sb10(3) & output_sb11(2) & output_sb11(1) & output_sb11(0) & output_sb11(3) & output_sb10(2) & output_sb10(1) when to_integer(unsigned(i)) mod 4 = 1 else
		output_sb11(1) & output_sb10(0) & output_sb10(3) & output_sb10(2) & output_sb10(1) & output_sb11(0) & output_sb11(3) & output_sb11(2) when to_integer(unsigned(i)) mod 4 = 2 else	
		output_sb11(2) & output_sb10(1) & output_sb10(0) & output_sb11(3) & output_sb10(2) & output_sb11(1) & output_sb11(0) & output_sb10(3);

end;