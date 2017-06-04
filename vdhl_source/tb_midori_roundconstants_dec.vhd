library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity tb_midori_roundconstants_dec is
    Generic(
        PERIOD : time := 100 ns;
        number_of_tests : integer := 19
    );
end tb_midori_roundconstants_dec;

architecture behavior of tb_midori_roundconstants_dec is

component midori_roundconstants_dec
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);    
        i : in STD_LOGIC_VECTOR(4 downto 0);
        o : out STD_LOGIC_VECTOR(127 downto 0) 
    );
end component;


component midori_inv_shufflecell
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

component midori_mixcolumn
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

signal test_a : STD_LOGIC_VECTOR(127 downto 0);
signal test_i : STD_LOGIC_VECTOR (4 downto 0);
signal test_o : STD_LOGIC_VECTOR(127 downto 0);
signal true_o : STD_LOGIC_VECTOR(127 downto 0);


signal round_constant : STD_LOGIC_VECTOR(127 downto 0);
signal mixcolumn_a : STD_LOGIC_VECTOR(127 downto 0);
signal mixcolumn_o : STD_LOGIC_VECTOR(127 downto 0);
signal linear_inverse : STD_LOGIC_VECTOR(127 downto 0);

signal test_error : STD_LOGIC;

type test_array is array (integer range <>) of STD_LOGIC_VECTOR(127 downto 0);

-- The original round constants
constant test_input : test_array(1 to number_of_tests) := (
X"00000001000100010100010100000101",
X"00010101010000000101000000000000",
X"01000100000100000000010100010001",
X"00010100000001000000000100000101",
X"00000001000000000001000001010101",
X"01010001000000010001010100000000",
X"00000000000001000001010000010100",
X"00000000010001010101000001010000",
X"01000001000100000100000000000001",
X"00010000000000000100010101000000",
X"00010101000000010100000100010101",
X"00000100000001000100000001010100",
X"00010001000000010000010100000000",
X"01010101010000000101000001000100",
X"01010001010101010100000100000000",
X"00010101010100000100000000000001",
X"00000001010100000000010000010000",
X"00000100000001010100010100010000",
X"00010100000001000100000001000100"
);

-- The round constants after they passed through the inverse of the linear layer
constant test_output : test_array(1 to number_of_tests) := (
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

test : midori_roundconstants_dec
    Port Map(
        a => test_a,
        i => test_i,
        o => test_o
    );

mixcolumn : midori_mixcolumn    
    Port Map(
        a => round_constant,
        o => mixcolumn_o
    );

inv_shufflecell : midori_inv_shufflecell
    Port Map(
        a => mixcolumn_o,
        o => linear_inverse
    );


process
    begin
        report "Start roundconstants during decryption test." severity note;
        test_error <= '0';
        -- The test_a is being XORd with the with the round constant that is selected by the round number (I in this case).
        -- As this XOR is trivial to perform, we set the value of test_a to 0.
        test_a <= (others => '0');
        wait for PERIOD;
        for I in 1 to number_of_tests loop
            wait for PERIOD;
            test_error <= '0';
            test_i <= STD_LOGIC_VECTOR(to_unsigned(I - 1, 5));
            round_constant <= test_input(I);
            true_o <= test_output(I);
            wait for PERIOD;
            -- Check if both the precomputed value and the "realtime" computed value of the inverse of the round constant match
            -- with the correct output.
            if (true_o = test_o and linear_inverse = test_o) then
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