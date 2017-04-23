library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midori_shufflecell is
	Port(
		a : in STD_LOGIC_VECTOR(127 downto 0);		
		o : out STD_LOGIC_VECTOR(127 downto 0)
	);
end midori_shufflecell;

architecture behavior of midori_shufflecell is

begin

o(127 downto 120) 	<= a(127 downto 120); 	-- s0 (gets s0)
o(119 downto 112) 	<= a(47 downto 40); 	-- s1 (gets s10)
o(111 downto 104) 	<= a(87 downto 80);		-- s2 (gets s5)
o(103 downto 96) 	<= a(7 downto 0); 		-- s3 (gets s15)

o(95 downto 88) 	<= a(15 downto 8); 		-- s4 (gets s14)
o(87 downto 80) 	<= a(95 downto 88); 	-- s5 (gets s4)
o(79 downto 72) 	<= a(39 downto 32); 	-- s6 (gets s11)
o(71 downto 64) 	<= a(119 downto 112) ;	-- s7 (gets s1)

o(63 downto 56) 	<= 	a(55 downto 48); 	-- s8 (gets s9)
o(55 downto 48) 	<= 	a(103 downto 96);	-- s9 (gets s3)
o(47 downto 40) 	<= 	a(31 downto 24);  	-- s10 (gets s12)
o(39 downto 32) 	<= 	a(79 downto 72);	-- s11 (gets s6)

o(31 downto 24) 	<= 	a(71 downto 64); 	-- s12 (gets s7)
o(23 downto 16) 	<= 	a(23 downto 16); 	-- s13 (gets s13)
o(15 downto 8) 		<=  a(111 downto 104);	-- s14 (gets s2)
o(7 downto 0) 		<= 	a(63 downto 56);	-- s15 (gets s8)

end;