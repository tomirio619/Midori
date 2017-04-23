library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This is where we describe the ports of the new entity we are creating
-- IMPORTANT know the difference between "to" and "downto" when creating a vector. 
-- Read this: http://stackoverflow.com/questions/7642000/downto-vs-to-in-vhdl 
entity midori_mixcolumn is
	Port(
		a : in STD_LOGIC_VECTOR(127 downto 0);		
		o : out STD_LOGIC_VECTOR(127 downto 0)
	);
end midori_mixcolumn;

architecture behavior of midori_mixcolumn is

begin
-- The actual "implementation" of this entity

-- Updating s0, s1, s2 and s3
o(127 downto 120) <= a(119 downto 112) xor a(111 downto 104) xor a(103 downto 96);
o(119 downto 112) <= a(127 downto 120) xor a(111 downto 104) xor a(103 downto 96);
o(111 downto 104) <= a(127 downto 120) xor a(119 downto 112) xor a(103 downto 96);
o(103 downto 96) <= a(127 downto 120) xor a(119 downto 112) xor a(111 downto 104);

-- updating s4, s5, s6 and s7
o(95 downto 88) <= a(87 downto 80) xor a(79 downto 72) xor a(71 downto 64);
o(87 downto 80) <= a(95 downto 88) xor a(79 downto 72) xor a(71 downto 64);
o(79 downto 72) <= a(95 downto 88) xor a(87 downto 80) xor a(71 downto 64);
o(71 downto 64) <= a(95 downto 88) xor a(87 downto 80) xor a(79 downto 72);

-- updating s8, s9, s10 and s11
o(63 downto 56) <= a(55 downto 48) xor a(47 downto 40) xor a(39 downto 32);
o(55 downto 48) <= a(63 downto 56) xor a(47 downto 40) xor a(39 downto 32);
o(47 downto 40) <= a(63 downto 56) xor a(55 downto 48) xor a(39 downto 32);
o(39 downto 32) <= a(63 downto 56) xor a(55 downto 48) xor a(47 downto 40);

--updating s12, s13, s14 and s15
o(31 downto 24) <= a(23 downto 16) xor a(15 downto 8) xor a(7 downto 0);
o(23 downto 16) <= a(31 downto 24) xor a(15 downto 8) xor a(7 downto 0);
o(15 downto 8) <= a(31 downto 24) xor a(23 downto 16) xor a(7 downto 0);
o(7 downto 0) <= a(31 downto 24) xor a(23 downto 16) xor a(15 downto 8);

end;