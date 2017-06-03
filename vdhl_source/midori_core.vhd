library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midori_core is
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
end midori_core;

architecture behavioral of midori_core is

component midori_core_state_machine
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
end component;

component midori_keyadd
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        key : in STD_LOGIC_VECTOR(127 downto 0);
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

component midori_subcell
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

component midori_shufflecell
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        enc_dec : in STD_LOGIC;
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

component midori_invshufflecell
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        enc_dec : in STD_LOGIC;
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

component midori_mixcolumn
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

component midori_roundconstants_enc
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        i : in STD_LOGIC_VECTOR(4 downto 0); 
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;

component midori_roundconstants_dec
    Port(
        a : in STD_LOGIC_VECTOR(127 downto 0);
        i : in STD_LOGIC_VECTOR(4 downto 0); 
        o : out STD_LOGIC_VECTOR(127 downto 0)
    );
end component;



signal input_text_with_key : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_subbytes : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_shiftrows : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_addroundkeys_before_mix : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_mixcolumns : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_addroundkeys_after_mix : STD_LOGIC_VECTOR(127 downto 0);
signal new_intermediate_text : STD_LOGIC_VECTOR(127 downto 0);

signal clean_internal_registers : STD_LOGIC;

signal intermediate_text_enable : STD_LOGIC;

signal round_mixcolumns_a : STD_LOGIC_VECTOR(127 downto 0);

signal sel_first_round_process : STD_LOGIC;
signal sel_load_new_enc_key : STD_LOGIC;
signal sel_load_new_dec_key : STD_LOGIC;

signal mem_round_keys_input_key : STD_LOGIC_VECTOR(127 downto 0);
signal mem_round_keys_write_key_enable : STD_LOGIC;
signal mem_round_keys_output_key : STD_LOGIC_VECTOR(127 downto 0);

signal round_key_enable : STD_LOGIC;
signal sel_generate_round_keys : STD_LOGIC;
signal round_key : STD_LOGIC_VECTOR(127 downto 0);

-- The whitening key is the original key
signal whitening_key : STD_LOGIC_VECTOR(127 downto 0);
signal new_round_key : STD_LOGIC_VECTOR(127 downto 0);

signal round_number_rstn : STD_LOGIC;
signal round_number_enable : STD_LOGIC;
signal round_number_key_generation : STD_LOGIC;
signal round_number : STD_LOGIC_VECTOR(3 downto 0);

signal round_constant_rstn : STD_LOGIC;
signal round_constant_enable : STD_LOGIC;
signal round_constant : STD_LOGIC_VECTOR(7 downto 0);
signal new_round_constant : STD_LOGIC_VECTOR(7 downto 0);
signal new_round_constant_inv : STD_LOGIC_VECTOR(7 downto 0);

signal is_last_key : STD_LOGIC;
signal is_last_round : STD_LOGIC;

signal encryption_mode_enabled : STD_LOGIC;

begin

state_machine : midori_core_state_machine
    Port Map(
        clk => clk,
        rstn => rstn,
        start_operation => start_operation,
        is_last_key => is_last_key,
        is_last_round => is_last_round,
        clean_internal_registers => clean_internal_registers,
        intermediate_text_enable => intermediate_text_enable,
        sel_first_round_process => sel_first_round_process,
        sel_load_new_enc_key => sel_load_new_enc_key,
		sel_load_new_dec_key => sel_load_new_dec_key,
        mem_round_keys_write_key_enable => mem_round_keys_write_key_enable,
        round_key_enable => round_key_enable,
        sel_generate_round_keys => sel_generate_round_keys,
        round_number_rstn => round_number_rstn,
        round_number_enable => round_number_enable,
        round_number_key_generation => round_number_key_generation,
        round_constant_rstn => round_constant_rstn, 
        round_constant_enable => round_constant_enable,
        core_free => core_free,
        operation_finished => operation_finished
    );


first_add_round : aes_addroundkeys
    Port Map(
        a => input_text,
        key => round_key,
        o => input_text_with_key
    );

reg_intermediate_text : process(clk)
    begin
        if(rising_edge(clk)) then
            if(clean_internal_registers = '0') then
                intermediate_text <= (others => '0');
            elsif(intermediate_text_enable = '1') then
                if(sel_first_round_process = '1') then
                    intermediate_text <= input_text_with_key;
                else
                    intermediate_text <= new_intermediate_text;
                end if;
            else
                null;
            end if;
        end if;
    end process;
	
round_subbytes : aes_subbytes
    Port Map(
        a => intermediate_text,
        enc_dec => enc_dec,
        o => intermediate_text_subbytes
    );

round_shiftrows : aes_shiftrows
    Port Map(
        a => intermediate_text_subbytes,
        enc_dec => enc_dec,
        o => intermediate_text_shiftrows
    );

round_add_round_before_mix : aes_addroundkeys    
    Port Map(
        a => intermediate_text_shiftrows,
        key => round_key,
        o => intermediate_text_addroundkeys_before_mix
    );    
    
round_mixcolumns : aes_mixcolumns    
    Port Map(
        a => round_mixcolumns_a,
        enc_dec => enc_dec,
        o => intermediate_text_mixcolumns
    );
	
round_add_round_after_mix : aes_addroundkeys    
    Port Map(
        a => intermediate_text_mixcolumns,
        key => round_key,
        o => intermediate_text_addroundkeys_after_mix
    );
    
mem_round_keys : aes_all_rounds_keys
    Port Map(
        clk => clk,
        input_key => mem_round_keys_input_key,
        round_number => round_number,
        write_key_enable => mem_round_keys_write_key_enable,
        output_key => mem_round_keys_output_key
    );

reg_round_keys : process(clk)
    begin
        if(rising_edge(clk)) then
            if(clean_internal_registers = '0') then
                round_key <= (others => '0');
            elsif(round_key_enable = '1') then
                if(sel_generate_round_keys = '1') then
                    round_key <= new_round_key;
                elsif (enc_dec = '1' or round_number_key_generation = '1') then
					if ( sel_load_new_enc_key = '1' ) then
						round_key <= input_key;
					else
						null;
					end if;
				-- We never reach this part, so the decryption key is never restored
				elsif ( sel_load_new_dec_key = '1') then
						round_key <= decryption_key;
				else
					null;
				end if;
			else
				null;
            end if;
        end if;
    end process;


reg_decryption_key : process(clk)
	begin
		if(rising_edge(clk)) then
			if (enc_dec = '1' and sel_load_new_dec_key) then
				decryption_key <= new_round_key;
			else
				null;
			end if;
		end if;
	end process;



key_schedule : aes_update_key
    Port Map(
        key => round_key,
		enc_dec => enc_dec,
        round_constant => round_constant,
        new_key => new_round_key
    );
    
reg_round_constant : process(clk)
    begin
        if(rising_edge(clk)) then
            if(round_constant_rstn = '0' or clean_internal_registers = '0') then
				if(enc_dec = '1' or  round_number_key_generation = '1') then
                    round_constant <= X"01";
				else
		    		round_constant <= X"36";
	    		end if;
            elsif(round_constant_enable = '1') then
				if(enc_dec = '1' or  round_number_key_generation = '1') then
 	            	round_constant <= new_round_constant;
				else
		    		round_constant <= new_round_constant_inv;
				end if;
            else
                null;
            end if;
        end if;
    end process;
    
update_round_constant : aes_multiply_x_gf_2
    Port Map(
        a => round_constant,
        o => new_round_constant
    );


update_round_constant_inv : aes_inverse_multiply_x_gf_2
    Port Map(
        a => round_constant,
        o => new_round_constant_inv
    );

    
ctr_round_number : process(clk)
    begin
        if(rising_edge(clk)) then
            if(clean_internal_registers = '0') then
                round_number <= X"0";
            elsif(round_number_rstn = '0') then
                if(encryption_mode_enabled = '1') then
                    round_number <= X"0";
                else
                    round_number <= X"15";
                end if;
            elsif(round_number_enable = '1') then
                if(encryption_mode_enabled = '1') then
                    round_number <= std_logic_vector(unsigned(round_number) + to_unsigned(1, 4));
                else
                    round_number <= std_logic_vector(unsigned(round_number) - to_unsigned(1, 4));
                end if;
            else
                null;
            end if;
        end if;
    end process;

encryption_mode_enabled <= enc_dec or round_number_key_generation;
                           
round_mixcolumns_a <= intermediate_text_shiftrows when (enc_dec = '1') else
                      intermediate_text_addroundkeys_before_mix;

new_intermediate_text <= intermediate_text_addroundkeys_before_mix when is_last_round = '1' else
                         intermediate_text_mixcolumns              when enc_dec = '0' else
                         intermediate_text_addroundkeys_after_mix;

is_last_key <= '1' when (((encryption_mode_enabled = '1') and round_number = X"9") or ((encryption_mode_enabled = '0') and round_number = X"1")) else '0';
                         
output_text <= new_intermediate_text;


    
end behavioral;