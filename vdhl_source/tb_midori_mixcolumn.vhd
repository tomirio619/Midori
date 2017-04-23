library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity tb_midori_mixcolumn is
    Generic(
        PERIOD : time := 100 ns;
        number_of_tests : integer := 10
    );
end tb_midori_mixcolumn;

architecture behavior of tb_midori_mixcolumn is

component midori_mixcolumn
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);        
        o : out STD_LOGIC_VECTOR(127 downto 0) 
    );
end component;

signal test_a : STD_LOGIC_VECTOR(127 downto 0);
signal test_i : STD_LOGIC_VECTOR (3 downto 0);
signal test_o : STD_LOGIC_VECTOR(127 downto 0);
signal true_o : STD_LOGIC_VECTOR(127 downto 0);

signal test_error : STD_LOGIC;

type test_array is array (integer range <>) of STD_LOGIC_VECTOR(127 downto 0);

constant test_input : test_array(1 to number_of_tests) := (
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

constant test_output : test_array(1 to number_of_tests) := (
X"85701d46502d9d2fb4b3eed20a724e8f",
X"ec2e115348a47adf3df02f68bbe91677",
X"b9df9bd0a3fa33b715aa702fe920b654",
X"0299f7e97bf6b859dbae30a7056c8d4b",
X"4c9a37e89da3db3c545d5e3280aabf51",
X"a31c71d81690a1066a8482d0efe83f59",
X"3ead751ddcf0da1bf910d64b953d8954",
X"725a64c83cb7e215d35fe035e35062ce",
X"6397078ba65819aff1d62bab15c8250a",
X"aac4ee334c3428fb8e33db84a3acb661"
);

begin

test : midori_mixcolumn
    Port Map(
        a => test_a,
        o => test_o
    );

process
    begin
        report "Start mixcolumns test." severity note;
        test_error <= '0';
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