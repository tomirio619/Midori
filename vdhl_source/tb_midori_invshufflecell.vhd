library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity tb_midori_invshufflecell is
    Generic(
        PERIOD : time := 100 ns;
        number_of_tests : integer := 10
    );
end tb_midori_invshufflecell;

architecture behavior of tb_midori_invshufflecell is

component midori_invshufflecell
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);      
        enc_dec: in STD_LOGIC;
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

signal test_a : STD_LOGIC_VECTOR(127 downto 0);
signal test_i : STD_LOGIC_VECTOR (3 downto 0);
signal test_o : STD_LOGIC_VECTOR(127 downto 0);
signal true_o : STD_LOGIC_VECTOR(127 downto 0);

signal test_error : STD_LOGIC;
signal enc_dec: STD_LOGIC;

type test_array is array (integer range <>) of STD_LOGIC_VECTOR(127 downto 0);

constant test_input : test_array(1 to number_of_tests) := (
X"6fba7b369e1b00e0ec1c206689e34e6a",
X"abbf2ff8c47d4a0b9fd5cc43180daa98",
X"23fe417187b688c1977a842df4fce757",
X"aabf2ef9c57c4b0b9fd5cd42180daa99",
X"0fb73f7092513da9266261c7279268b2",
X"aabf2ff8c47d4a0a9ed5cd43180daa99",
X"74f746857b2e42911b1a7655c80b1e49",
X"aabe2ef8c47d4a0a9fd5cc43180caa98",
X"a1fcd3e9d050383aac22c54524502ee5",
X"abbe2ff8c47d4b0b9ed4cd43190dab98"
);

constant test_output : test_array(1 to number_of_tests) := (
X"6fe04e1c1b7b66896aecba0020e39e36",
X"ab0baad57d2f4318989fbf4acc0dc4f8",
X"23c1e77ab6412df45797fe8884fc8771",
X"aa0baad57c2e4218999fbf4bcd0dc5f9",
X"0fa96862513fc727b226b73d61929270",
X"aa0aaad57d2f4318999ebf4acd0dc4f8",
X"74911e1a2e4655c8491bf742760b7b85",
X"aa0aaad57d2e4318989fbe4acc0cc4f8",
X"a13a2e2250d34524e5acfc38c550d0e9",
X"ab0babd47d2f4319989ebe4bcd0dc4f8"
);

begin

test : midori_invshufflecell
    Port Map(
        a => test_a,
        enc_dec => enc_dec,
        o => test_o
    );

process
    begin
        report "Start inverse shuffle cell test." severity note;
        test_error <= '0';
        enc_dec <= '1';
        wait for PERIOD;
        for I in 1 to number_of_tests loop
            test_error <= '0';
            test_i <= STD_LOGIC_VECTOR(to_unsigned(I - 1, 4));
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