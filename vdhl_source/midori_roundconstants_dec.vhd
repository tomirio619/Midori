library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midori_roundconstants_dec is
	Port(
		a : in STD_LOGIC_VECTOR(127 downto 0);
		i : in STD_LOGIC_VECTOR(4 downto 0); 
		o : out STD_LOGIC_VECTOR(127 downto 0)
	);
end midori_roundconstants_dec ;

architecture behavior of midori_roundconstants_dec is

type table is array (0 to 18) of STD_LOGIC_VECTOR(127 downto 0);

-- These are the round constants that should be used in decryption.
-- Note that in decryption, you apply the round constants in reverse order.
-- The round constants are placed at the index indicated by the round number.
-- Therefore, in decryption you should fed this component with an index starting from 18 downto 0.
constant round_constants_dec : table := (
X"01010101010100000100010000000000",
X"01010001010000000001000100000000",
X"01010000000101000100000101010100",
X"00010101010100000101010001000100",
X"01000100000101010101010001010000",
X"00000000010100000001000100000100",
X"00010101010000000000000001010100",
X"00000001010000010001000000010000",
X"01010101000001010000000101010101",
X"01000101000100000100000000010001",
X"01000000010001010001000100000100",
X"01010001010001000100010001000101",
X"00000000010001000000010101000101",
X"01010101010100010001010100000001",
X"00010000010101000001000100000100",
X"01000101010001010000000001010100",
X"01000101010101010101010000000100",
X"01010101000000010100010100000001",
X"00010101010101010000010001000100"
);

begin 

o <= round_constants_dec(to_integer(unsigned(i))) xor a;

end;

