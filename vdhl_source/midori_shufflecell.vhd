library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midori_shufflecell is
	Port(
		a : in STD_LOGIC_VECTOR(127 downto 0);		
		enc_dec: in STD_LOGIC;
		o : out STD_LOGIC_VECTOR(127 downto 0)
	);
end midori_shufflecell;

architecture behavior of midori_shufflecell is

begin

o(127 downto 120) 	<= a(127 downto 120); 	-- s0 (gets s0 on encryption and s0 on decryption)
o(119 downto 112) 	<= a(47 downto 40) when enc_dec = '1' else a(71 downto 64); 		-- s1 (gets s10 on encryption and s7 on decryption))
o(111 downto 104) 	<= a(87 downto 80) when enc_dec = '1' else a(15 downto 8);		-- s2 (gets s5 on encryption and s14 on decryption))
o(103 downto 96) 	<= a(7 downto 0) when enc_dec = '1' else a(55 downto 48); 		-- s3 (gets s15 on encryption and s9 on decryption))

o(95 downto 88) 	<= a(15 downto 8) when enc_dec = '1' else a(87 downto 80); 		-- s4 (gets s14 on encryption and s5 on decryption))
o(87 downto 80) 	<= a(95 downto 88) when enc_dec = '1' else a(111 downto 104); 	-- s5 (gets s4 on encryption and s2 on decryption))
o(79 downto 72) 	<= a(39 downto 32); 											-- s6 (gets s11 on encryption and s11 on decryption))
o(71 downto 64) 	<= a(119 downto 112) when enc_dec = '1' else a(31 downto 24);		-- s7 (gets s1 on encryption and s12 on decryption))

o(63 downto 56) 	<= 	a(55 downto 48) when enc_dec = '1' else a(7 downto 0); 		-- s8 (gets s9 on encryption and s15 on decryption))
o(55 downto 48) 	<= 	a(103 downto 96) when enc_dec = '1' else a(63 downto 56) ;	-- s9 (gets s3 on encryption and s8 on decryption))
o(47 downto 40) 	<= 	a(31 downto 24) when enc_dec = '1' else a(119 downto 112);  	-- s10 (gets s12 on encryption and s1 on decryption))
o(39 downto 32) 	<= 	a(79 downto 72);											-- s11 (gets s6 on encryption and s6 on decryption))

o(31 downto 24) 	<= 	a(71 downto 64) when enc_dec = '1' else a(47 downto 40); 		-- s12 (gets s7 on encryption and s10 on decryption))
o(23 downto 16) 	<= 	a(23 downto 16);										 	-- s13 (gets s13 on encryption and s13 on decryption))
o(15 downto 8) 		<=  a(111 downto 104) when enc_dec = '1' else a(95 downto 88) ;	-- s14 (gets s2 on encryption and s4 on decryption))
o(7 downto 0) 		<= 	a(63 downto 56) when enc_dec = '1' else a(103 downto 96);		-- s15 (gets s8 on encryption and s3 on decryption))

end;