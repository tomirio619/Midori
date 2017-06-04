library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity midori_core_state_machine is
    Port(
        clk : in STD_LOGIC;
        rstn : in STD_LOGIC;
        start_operation : in STD_LOGIC_VECTOR(1 downto 0);
        is_last_key : in STD_LOGIC;
        is_last_round : out STD_LOGIC;
        clean_internal_registers : out STD_LOGIC;
        intermediate_text_enable : out STD_LOGIC;
        sel_first_round_process : out STD_LOGIC;
        sel_load_new_enc_key : out STD_LOGIC;
		sel_load_new_dec_key : out STD_LOGIC;
        mem_round_keys_write_key_enable : out STD_LOGIC;
        round_key_enable : out STD_LOGIC;
        sel_generate_round_keys : out STD_LOGIC;
        round_number_rstn : out STD_LOGIC;
        round_number_enable : out STD_LOGIC;
        round_number_key_generation : out STD_LOGIC;
        round_constant_rstn : out STD_LOGIC;
        round_constant_enable : out STD_LOGIC;
        core_free : out STD_LOGIC;
        operation_finished : out STD_LOGIC
    );
end midori_core_state_machine;

architecture behavioral of midori_core_state_machine is

type state is (reset, wait_command,
-- Key Expansion
init_key_schedule, wait_key_load_memory, finish_key_schedule,
-- Encryption, Decryption process
init_enc_dec, wait_first_round_key, first_round_enc_dec, remaining_rounds_enc_dec, last_round_enc_dec, finish_enc_dec
);

signal actual_state, next_state : state;

signal next_is_last_round : STD_LOGIC;
signal next_clean_internal_registers : STD_LOGIC;
signal next_intermediate_text_enable : STD_LOGIC;
signal next_sel_first_round_process : STD_LOGIC;
signal next_sel_load_new_enc_key : STD_LOGIC;
signal next_sel_load_new_dec_key : STD_LOGIC;
signal next_mem_round_keys_write_key_enable : STD_LOGIC;
signal next_round_key_enable : STD_LOGIC;
signal next_sel_generate_round_keys : STD_LOGIC;
signal next_sel_load_enc_key : STD_LOGIC;
signal next_sel_load_dec_key : STD_LOGIC;
signal next_round_number_rst : STD_LOGIC;
signal next_round_number_enable : STD_LOGIC;
signal next_round_number_key_generation : STD_LOGIC;
signal next_round_constant_rst : STD_LOGIC;
signal next_round_constant_enable : STD_LOGIC;
signal next_core_free : STD_LOGIC;
signal next_operation_finished : STD_LOGIC;

begin

update_internal_registers : process(clk, rstn)
    begin
        if(rstn = '0') then
            actual_state <= reset;
            is_last_round <= '0';
            clean_internal_registers <= '0';
            intermediate_text_enable <= '0';
            sel_first_round_process <= '0';
            sel_load_new_enc_key <= '0';
	    	sel_load_new_dec_key <= '0';
            mem_round_keys_write_key_enable <= '0';
            round_key_enable <= '0';
            sel_generate_round_keys <= '0';
            round_number_rstn <= '0';
            round_number_enable <= '0';
            round_number_key_generation <= '0';
            round_constant_rstn <= '0';
            round_constant_enable <= '0';
            core_free <= '0';
            operation_finished <= '0';
        elsif(rising_edge(clk)) then
            actual_state <= next_state;
            is_last_round <= next_is_last_round;
            clean_internal_registers <= next_clean_internal_registers;
            intermediate_text_enable <= next_intermediate_text_enable;
            sel_first_round_process <= next_sel_first_round_process;
            sel_load_new_enc_key <= next_sel_load_new_enc_key;
	  		sel_load_new_dec_key <= next_sel_load_new_dec_key;
            mem_round_keys_write_key_enable <= next_mem_round_keys_write_key_enable;
            round_key_enable <= next_round_key_enable;
            sel_generate_round_keys <= next_sel_generate_round_keys;
            round_number_rstn <= next_round_number_rst;
            round_number_enable <= next_round_number_enable;
            round_number_key_generation <= next_round_number_key_generation;
            round_constant_rstn <= next_round_constant_rst;
            round_constant_enable <= next_round_constant_enable;
            core_free <= next_core_free;
            operation_finished <= next_operation_finished;
        end if;
    end process;
    
update_output : process(actual_state, start_operation, is_last_key)
    begin
        next_is_last_round <= '0';
        next_clean_internal_registers <= '1';
        next_intermediate_text_enable <= '0';
        next_sel_first_round_process <= '0';
        next_sel_load_new_enc_key <= '0';
		next_sel_load_new_dec_key <= '0';
        next_mem_round_keys_write_key_enable <= '0';
        next_round_key_enable <= '0';
        next_sel_generate_round_keys <= '0';
        next_round_number_rst <= '1';
        next_round_number_enable <= '0';
        next_round_number_key_generation <= '0';
        next_round_constant_rst <= '1';
        next_round_constant_enable <= '0';
        next_core_free <= '0';
        next_operation_finished <= '0';
        case actual_state is
            when reset =>
                next_core_free <= '1';
                next_clean_internal_registers <= '0';
                next_round_number_rst <= '0';
            when wait_command =>
                if(start_operation = "01") then
                    next_round_number_rst <= '0';
                    next_round_constant_rst <= '0';
                    next_round_number_key_generation <= '1';
                    next_core_free <= '0';
                elsif(start_operation = "10") then
                    next_round_number_rst <= '0';
                    next_core_free <= '0';
                else
                    next_core_free <= '1';
                end if;
            when init_key_schedule =>
                next_sel_load_new_enc_key <= '1';
                next_mem_round_keys_write_key_enable <= '1';
                next_round_number_key_generation <= '1';
            when wait_key_load_memory =>
				next_sel_load_new_enc_key <= '1';
                next_round_number_key_generation <= '1';
            when finish_key_schedule =>
                next_core_free <= '1';
            when init_enc_dec =>
                next_round_number_enable <= '1';
            when wait_first_round_key =>    -- If we are doing decryption, this should be the state in which we fetch the decryption key from the circuit.
				next_sel_load_new_enc_key <= '1';
				next_round_key_enable <= '1';
                next_round_number_enable <= '1';
				next_round_constant_rst	<= '0';
				next_round_constant_enable <= '1';
            when first_round_enc_dec =>
                next_round_key_enable <= '1';
				next_round_number_enable <= '1';
                next_intermediate_text_enable <= '1';
                next_sel_first_round_process <= '1';
				next_sel_generate_round_keys <= '1';
				next_round_constant_enable <= '1';
            when remaining_rounds_enc_dec =>
                next_intermediate_text_enable <= '1';
				next_round_key_enable <= '1';
				next_round_number_enable <= '1';
                next_round_constant_enable <= '1';
				next_sel_load_enc_key <= '0';
				next_sel_generate_round_keys <= '1';
            when last_round_enc_dec =>
                next_intermediate_text_enable <= '1';
				next_sel_generate_round_keys <= '1';
                next_round_key_enable <= '1';
                next_round_number_enable <= '1';
            when finish_enc_dec =>
                next_core_free <= '1';
                next_is_last_round <= '1';
                next_operation_finished <= '1';
        end case;
        
    end process;

update_state : process(actual_state, start_operation, is_last_key)
    begin
        next_state <= reset;
        case actual_state is
            when reset =>
                next_state <= wait_command;
            when wait_command =>
                if(start_operation = "01") then
                    next_state <= init_key_schedule;
                elsif(start_operation = "10") then 
                    next_state <= init_enc_dec;
                else
                    next_state <= wait_command;
                end if;
            when init_key_schedule =>
                next_state <= wait_key_load_memory;
            when wait_key_load_memory =>
                next_state <= finish_key_schedule;
            when finish_key_schedule =>
                next_state <= wait_command;    
            when init_enc_dec =>
                next_state <= wait_first_round_key;
            when wait_first_round_key =>
                next_state <= first_round_enc_dec;
            when first_round_enc_dec =>
                next_state <= remaining_rounds_enc_dec;
            when remaining_rounds_enc_dec =>
                if(is_last_key = '1') then
                    next_state <= last_round_enc_dec;
                else
                    next_state <= remaining_rounds_enc_dec;
                end if;
            when last_round_enc_dec =>
                next_state <= finish_enc_dec;  
            when finish_enc_dec =>
                next_state <= wait_command;  
        end case;
        
    end process;    
    
end behavioral;
