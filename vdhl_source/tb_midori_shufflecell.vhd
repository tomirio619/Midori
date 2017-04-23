library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity tb_midori_shufflecell is
    Generic(
        PERIOD : time := 100 ns;
        number_of_tests : integer := 10
    );
end tb_midori_shufflecell;

architecture behavior of tb_midori_shufflecell is

component midori_shufflecell
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
X"2be0f788e2b3e9b3368fde52d5cb9fe8",
X"6c96257aed91e28844b7ae33a5da01d3",
X"946a9d4a27b6cfc27ff5f2ee900b7efd",
X"8735224c9a7245aae4391cd4d2c3176c",
X"45e57b387a3e5744953193023b6e44e1",
X"b5275e38b1676c8e38d60a803e8937ce",
X"c5f6fc641d8e3fe0218d5637a24831e6",
X"f6697d06cbe06cfcd18ade9eb94f404c",
X"1be7d771107f0ce7f856ef518c3aeef3",
X"19506ed19f5d667bb96c77833974e780"
);

constant test_output : test_array(1 to number_of_tests) := (
X"2bdeb3e89fe252e08f88d5e9b3cbf736",
X"6cae91d301ed3396b77aa5e288da2544",
X"94f2b6fd7e27ee6af54a90cfc20b9d7f",
X"871c726c179ad435394cd245aac322e4",
X"45933ee1447a02e531383b57446e7b95",
X"b50a67ce37b18027d6383e6c8e895e38",
X"c5568ee6311d37f68d64a23fe048fc21",
X"f6dee04c40cb9e698a06b96cfc4f7dd1",
X"1bef7ff3ee1051e756718c0ce73ad7f8",
X"19775d80e79f83506cd139667b746eb9"
);

begin

test : midori_shufflecell
    Port Map(
        a => test_a,
        enc_dec => enc_dec,
        o => test_o
    );

process
    begin
        report "Start shuffle cell test." severity note;
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