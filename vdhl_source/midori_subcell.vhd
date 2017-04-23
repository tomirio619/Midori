library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This is where we describe the ports of the new entity we are creating
-- IMPORTANT know the difference between "to" and "downto" when creating a vector. 
-- Read this: http://stackoverflow.com/questions/7642000/downto-vs-to-in-vhdl 
entity midori_subcell is
	Port(
		a : in STD_LOGIC_VECTOR(127 downto 0);		
		o : out STD_LOGIC_VECTOR(127 downto 0)
	);
end midori_subcell;

architecture behavior of midori_subcell is

-- An entity can reuse other entities. We do this by creating a component of this entity
-- and specify which ports this component uses.
component midori_ssbi
	Port(
		a : in STD_LOGIC_VECTOR(7 downto 0);		
		i : in STD_LOGIC_VECTOR (3 downto 0);
		o : out STD_LOGIC_VECTOR(7 downto 0)
	);
end component;

begin
-- The actual "implementation" of this entity

sbox0 : midori_ssbi
    Port Map(
        a => a(127 downto 120),
        i => STD_LOGIC_VECTOR(to_unsigned(0, 4)),
        o => o(127 downto 120)
    );
    
sbox1 : midori_ssbi
    Port Map(
        a => a(119 downto 112),
        i => STD_LOGIC_VECTOR(to_unsigned(1, 4)),
        o => o(119 downto 112)
    );
    
sbox2 : midori_ssbi
    Port Map(
        a => a(111 downto 104),
        i => STD_LOGIC_VECTOR(to_unsigned(2, 4)),
        o => o(111 downto 104)
    );

sbox3 : midori_ssbi
    Port Map(
        a => a(103 downto 96),
        i => STD_LOGIC_VECTOR(to_unsigned(3, 4)),
        o => o(103 downto 96)
    );

sbox4 : midori_ssbi
    Port Map(
        a => a(95 downto 88),
        i => STD_LOGIC_VECTOR(to_unsigned(0, 4)),
        o => o(95 downto 88)
    );

sbox5 : midori_ssbi
    Port Map(
        a => a(87 downto 80),
        i => STD_LOGIC_VECTOR(to_unsigned(1, 4)),
        o => o(87 downto 80)
    );

sbox6 : midori_ssbi
    Port Map(
        a => a(79 downto 72),
        i => STD_LOGIC_VECTOR(to_unsigned(2, 4)),
        o => o(79 downto 72)
    );

sbox7 : midori_ssbi
    Port Map(
        a => a(71 downto 64),
        i => STD_LOGIC_VECTOR(to_unsigned(3, 4)),
        o => o(71 downto 64)
    );

sbox8 : midori_ssbi
    Port Map(
        a => a(63 downto 56),
        i => STD_LOGIC_VECTOR(to_unsigned(0, 4)),
        o => o(63 downto 56)
    );

sbox9 : midori_ssbi
    Port Map(
        a => a(55 downto 48),
        i => STD_LOGIC_VECTOR(to_unsigned(1, 4)),
        o => o(55 downto 48)
    );

sbox10 : midori_ssbi
    Port Map(
        a => a(47 downto 40),
        i => STD_LOGIC_VECTOR(to_unsigned(2, 4)),
        o => o(47 downto 40)
    );

sbox11 : midori_ssbi
    Port Map(
        a => a(39 downto 32),
        i => STD_LOGIC_VECTOR(to_unsigned(3, 4)),
        o => o(39 downto 32)
    );

sbox12 : midori_ssbi
    Port Map(
        a => a(31 downto 24),
        i => STD_LOGIC_VECTOR(to_unsigned(0, 4)),
        o => o(31 downto 24)
    );

sbox13 : midori_ssbi
    Port Map(
        a => a(23 downto 16),
        i => STD_LOGIC_VECTOR(to_unsigned(1, 4)),
        o => o(23 downto 16)
    );

sbox14 : midori_ssbi
    Port Map(
        a => a(15 downto 8),
        i => STD_LOGIC_VECTOR(to_unsigned(2, 4)),
        o => o(15 downto 8)
    );

sbox15 : midori_ssbi
    Port Map(
        a => a(7 downto 0),
        i => STD_LOGIC_VECTOR(to_unsigned(3, 4)),
        o => o(7 downto 0)
    );    


end;