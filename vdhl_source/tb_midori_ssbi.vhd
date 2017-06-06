library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity tb_midori_ssbi is
	Generic(
		PERIOD : time := 100 ns;
		number_of_tests : integer := 16
	);
end tb_midori_ssbi;

architecture behavior of tb_midori_ssbi is

component midori_ssbi
	Port(
		a : in STD_LOGIC_VECTOR(7 downto 0);		
		i : in STD_LOGIC_VECTOR (3 downto 0);
		o : out STD_LOGIC_VECTOR(7 downto 0) 
	);
end component;

signal test_a : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal test_i : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal test_o : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal true_o : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

signal test_error : STD_LOGIC := '0';

type test_array is array (integer range <>) of STD_LOGIC_VECTOR(7 downto 0);

constant test_input : test_array(1 to number_of_tests) := (
X"39",
X"75",
X"a1",
X"dd",
X"db",
X"bf",
X"ef",
X"51",
X"b7",
X"97",
X"de",
X"3c",
X"82",
X"03",
X"f9",
X"fc"
);

constant test_output : test_array(1 to number_of_tests) := (
X"2b",
X"e0",
X"f7",
X"88",
X"e2",
X"b3",
X"e9",
X"b3",
X"36",
X"8f",
X"de",
X"52",
X"d5",
X"cb",
X"9f",
X"e8"
);

begin

test : midori_ssbi
	Port Map(
		a => test_a,
		i => test_i,
		o => test_o
	);

process
	begin
		report "Start sbox test." severity note;
		test_error <= '0';
		wait for PERIOD;
		for I in 1 to number_of_tests loop
			test_error <= '0';
			test_i <= STD_LOGIC_VECTOR(to_unsigned((I - 1), 4));
			test_a <= test_input(I);
			true_o <= test_output(I);
			wait for PERIOD;
			if (true_o = test_o) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Computed values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            wait for PERIOD;
        end loop;
        report "End of the test." severity note;
        wait;
end process;

end;