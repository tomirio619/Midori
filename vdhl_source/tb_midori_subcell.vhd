library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity tb_midori_subcell is
    Generic(
        PERIOD : time := 100 ns;
        number_of_tests : integer := 10
    );
end tb_midori_subcell;

architecture behavior of tb_midori_subcell is

component midori_subcell
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);        
        o : out STD_LOGIC_VECTOR(127 downto 0) 
    );
end component;

signal test_a : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
signal test_i : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal test_o : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
signal true_o : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');

signal test_error : STD_LOGIC;

type test_array is array (integer range <>) of STD_LOGIC_VECTOR(127 downto 0);

constant test_input : test_array(1 to number_of_tests) := (
X"3975a1dddbbfef51b797de3c8203f9fc",
X"ed0df07c6ca92eddeea3e6553458c331",
X"8452fd697521c92c67e126ee85c39ac8",
X"d0a277eb9f7e80444eba78a8d70b3aea",
X"6ae51bd247730aaa80be39203b4600f5",
X"24e7dad2a12668cf0f4c57b4bf8132ef",
X"ca609ce22a1512f431958a57d1c2b3e6",
X"56d09826e07568e8a201decdab1604eb",
X"1a2789f3013250e7894ee9b3dc7bee71",
X"0aeaeab19adcaa5cabc6222d2be2a9b4"
);

constant test_output : test_array(1 to number_of_tests) := (
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

begin

test : midori_subcell
    Port Map(
        a => test_a,
        o => test_o
    );

process
    begin
        report "Start subcell test." severity note;
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