library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity tb_midori_core is
Generic(
        PERIOD : time := 100 ns;
        
        test_memory_file_midori128 : string := "data_tests/midori128_enc.dat"
);
end tb_midori_core;

architecture Behavioral of tb_midori_core is

component midori_core
    Port(
        clk : in STD_LOGIC;
        rstn : in STD_LOGIC;
        input_text : in STD_LOGIC_VECTOR(127 downto 0);
        input_key : in STD_LOGIC_VECTOR(127 downto 0);
        enc_dec : in STD_LOGIC;
        start_operation : in STD_LOGIC_VECTOR(1 downto 0);
        output_text : out STD_LOGIC_VECTOR(127 downto 0);
        core_free : out STD_LOGIC;
        operation_finished : out STD_LOGIC
    );
end component;

signal test_rstn : STD_LOGIC;
signal test_input_text : STD_LOGIC_VECTOR(127 downto 0);
signal test_input_key : STD_LOGIC_VECTOR(127 downto 0);
signal test_enc_dec : STD_LOGIC;
signal test_start_operation : STD_LOGIC_VECTOR(1 downto 0);
signal test_output_text : STD_LOGIC_VECTOR(127 downto 0);
signal test_core_free : STD_LOGIC;
signal test_operation_finished : STD_LOGIC;

signal true_output_text : STD_LOGIC_VECTOR(127 downto 0);

signal test_error : STD_LOGIC := '0';
signal clk : STD_LOGIC := '1';
signal test_bench_finish : BOOLEAN := false;

constant tb_delay : time := (PERIOD/2);

begin

test : midori_core
    Port Map(
        clk => clk,
        rstn => test_rstn,
        input_text => test_input_text,
        input_key => test_input_key,
        enc_dec => test_enc_dec,
        start_operation => test_start_operation,
        output_text => test_output_text,
        core_free => test_core_free,
        operation_finished => test_operation_finished
    );
    
clock : process
begin
while (not test_bench_finish ) loop
    clk <= not clk;
    wait for PERIOD/2;
end loop;
wait;
end process;

                        
process
    FILE ram_file : text;
    variable line_n : line;                                 
    variable read_plaintext : STD_LOGIC_VECTOR(127 downto 0);
    variable read_key : STD_LOGIC_VECTOR(127 downto 0);
    variable read_ciphertext : STD_LOGIC_VECTOR(127 downto 0);
    variable before_time : time;
    variable after_time : time;    
    begin     
        report "Start Midori128 encryption test." severity note;    
        file_open(ram_file, test_memory_file_midori128, READ_MODE);
        test_rstn <= '0';
        wait for PERIOD;
        wait for tb_delay;
        test_rstn <= '1';
        wait for PERIOD;
        while not endfile(ram_file) loop
            test_error <= '0';
            readline (ram_file, line_n);                             
            read (line_n, read_plaintext); 
            readline (ram_file, line_n);                             
            read (line_n, read_key);
            readline (ram_file, line_n);                             
            read (line_n, read_ciphertext);        
            -- Encryption Test
            report "Reading plaintext, key and ciphertext" severity note;
            test_input_text <= read_plaintext;
            test_input_key <= read_key;
            true_output_text <= read_ciphertext;
            report "Finished reading" severity note;
            test_enc_dec <= '1';
            test_start_operation <= "01";   -- init_key_schedule
            wait for PERIOD;
            test_start_operation <= "11";   -- wait_command
            wait until test_core_free = '1';
            wait for tb_delay;    
            test_start_operation <= "10";   -- init_enc_dec
            wait for PERIOD;    
            before_time := now;
            test_start_operation <= "11";   -- wait_command
            wait until test_core_free = '1';
            wait for tb_delay;
            after_time := now;
            report "Encryption time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            if (true_output_text = test_output_text) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Computed values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            report "End of the encryption test." severity note;
            test_error <= '0';
            -- Decryption Test
            report "Start Midori128 decryption test." severity note;  
            report "Reading plaintext, key and ciphertext" severity note;
            test_input_text <= read_ciphertext;
            test_input_key <= read_key;
            true_output_text <= read_plaintext;
            report "Finished reading" severity note;
            test_enc_dec <= '0';
            report "Test enc_dec put to 0" severity note;
            test_start_operation <= "01";
            report "Init key schedule" severity note;
            wait for PERIOD;
            test_start_operation <= "11";
            wait until test_core_free = '1';
            wait for tb_delay;    
            test_start_operation <= "10";
            wait for PERIOD;    
            before_time := now;
            test_start_operation <= "11";
            wait until test_core_free = '1';
            wait for tb_delay;
            after_time := now;
            report "Decryption time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            if (true_output_text = test_output_text) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Computed values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            wait for PERIOD;
        end loop;
        report "End of the decryption test." severity note;
        test_bench_finish <= true;
        wait;
end process;

end Behavioral;