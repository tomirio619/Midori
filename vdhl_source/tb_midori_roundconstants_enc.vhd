library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity tb_midori_roundconstants_enc is
    Generic(
        PERIOD : time := 100 ns;
        number_of_tests : integer := 19
    );
end tb_midori_roundconstants_enc;

architecture behavior of tb_midori_roundconstants_enc is

component midori_roundconstants_enc
    Port(
        i : in STD_LOGIC_VECTOR(4 downto 0);
        o : out STD_LOGIC_VECTOR(127 downto 0) 
    );
end component;

signal test_a : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
signal test_i : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal test_o : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
signal true_o : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');

signal test_error : STD_LOGIC;

type test_array is array (integer range <>) of STD_LOGIC_VECTOR(127 downto 0);

-- We only have one key
constant test_input : STD_LOGIC_VECTOR (127 downto 0) := X"687ded3b3c85b3f35b1009863e2a8cbf";

-- The resulting keys after the round constants have been applied
constant test_output : test_array(1 to number_of_tests) := (
X"687ded3a3c84b3f25a1008873e2a8dbe",
X"687cec3a3d85b3f35a1109863e2a8cbf",
X"697dec3b3c84b3f35b1008873e2b8cbe",
X"687cec3b3c85b2f35b1009873e2a8dbe",
X"687ded3a3c85b3f35b1109863f2b8dbe",
X"697ced3a3c85b3f25b1108873e2a8cbf",
X"687ded3b3c85b2f35b1108863e2b8dbf",
X"687ded3b3d85b2f25a1109863f2b8cbf",
X"697ded3a3c84b3f35a1009863e2a8cbe",
X"687ced3b3c85b3f35a1008873f2a8cbf",
X"687cec3a3c85b3f25a1009873e2b8dbe",
X"687dec3b3c85b2f35a1009863f2b8dbf",
X"687ced3a3c85b3f25b1008873e2a8cbf",
X"697cec3a3d85b3f35a1109863f2a8dbf",
X"697ced3a3d84b2f25a1009873e2a8cbf",
X"687cec3a3d84b3f35a1009863e2a8cbe",
X"687ded3a3d84b3f35b1008863e2b8cbf",
X"687dec3b3c85b2f25a1008873e2b8cbf",
X"687cec3b3c85b2f35a1009863f2a8dbf"
);

begin

test : midori_roundconstants_enc
    Port Map(
        i => test_i,
        o => test_o
    );

process
    begin
        report "Start roundconstants during encryption test." severity note;
        test_error <= '0';
        test_a <= test_input;
        wait for PERIOD;
        for I in 1 to number_of_tests loop
            wait for PERIOD;
            test_error <= '0';
            test_i <= STD_LOGIC_VECTOR(to_unsigned(I - 1, 5));
            true_o <= test_output(I);
            wait for PERIOD;
            if (true_o = (test_o xor test_a)) then
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