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
signal intermediate_text_subcell : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_shufflecell : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_inv_shufflecell : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_add_key_before_mix : STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_mixcolumn : STD_LOGIC_VECTOR(127 downto 0);

signal intermediate_text_add_key_after_mix_enc: STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_add_key_after_mix_dec: STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_add_round_constant_enc: STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_add_round_constant_dec: STD_LOGIC_VECTOR(127 downto 0);
signal intermediate_text_final_add_key : STD_LOGIC_VECTOR(127 downto 0);

signal new_intermediate_text : STD_LOGIC_VECTOR(127 downto 0);

signal clean_internal_registers : STD_LOGIC;

signal intermediate_text_enable : STD_LOGIC;

signal round_add_key_after_mix_a : STD_LOGIC_VECTOR(127 downto 0);
signal round_add_round_constant_a : STD_LOGIC_VECTOR(127 downto 0);
signal round_mixcolumn_a : STD_LOGIC_VECTOR(127 downto 0);

signal sel_first_round_process : STD_LOGIC;
signal sel_load_new_enc_key : STD_LOGIC;
signal sel_load_new_dec_key : STD_LOGIC;

signal mem_round_keys_input_key : STD_LOGIC_VECTOR(127 downto 0);
signal mem_round_keys_write_key_enable : STD_LOGIC;
signal mem_round_keys_output_key : STD_LOGIC_VECTOR(127 downto 0);

signal round_key_enable : STD_LOGIC;
signal sel_generate_round_keys : STD_LOGIC;
signal sel_generate_decryption_key : STD_LOGIC;
signal round_key : STD_LOGIC_VECTOR(127 downto 0);

-- The whitening key is the original key
signal whitening_key : STD_LOGIC_VECTOR(127 downto 0);
signal new_round_key : STD_LOGIC_VECTOR(127 downto 0);
signal decryption_key : STD_LOGIC_VECTOR(127 downto 0);

signal round_number_rstn : STD_LOGIC;
signal round_number_enable : STD_LOGIC;
signal round_number_key_generation : STD_LOGIC;
signal round_number : STD_LOGIC_VECTOR(4 downto 0);

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


first_add_round_key : midori_keyadd
    Port Map(
        a => input_text,
        key => whitening_key,
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
	
round_subcell : midori_subcell
    Port Map(
        a => intermediate_text,
        o => intermediate_text_subcell
    );

round_shufflecell : midori_shufflecell
    Port Map(
        a => intermediate_text_subcell,
        o => intermediate_text_shufflecell
    );

round_inv_shufflecell : midori_inv_shufflecell
    Port Map(
        a => intermediate_text_subcell,
        o => intermediate_text_inv_shufflecell
    );

round_mixcolumn : midori_mixcolumn    
    Port Map(
        a => round_mixcolumn_a,
        o => intermediate_text_mixcolumn
    );
	
round_add_key_after_mix_enc : midori_keyadd    
    Port Map(
        a => round_add_key_after_mix_a,
        key => whitening_key,
        o => intermediate_text_add_key_after_mix_enc
    );

round_add_key_after_mix_dec : midori_keyadd    
    Port Map(
        a => round_add_key_after_mix_a,
        key => decryption_key,
        o => intermediate_text_add_key_after_mix_dec
    );

round_add_round_constant_enc : midori_roundconstants_enc   
    Port Map(
        a => round_add_round_constant_a,
        i => round_number,
        o => intermediate_text_add_round_constant_enc
    );


round_add_round_constant_dec : midori_roundconstants_dec
    Port Map(
        a => round_add_round_constant_a,
        i => round_number,
        o => intermediate_text_add_round_constant_dec
    );
    

final_add_round_key : midori_keyadd
    Port Map(
        a => intermediate_text_subcell,
        key => whitening_key,
        o => intermediate_text_final_add_key
    );


reg_decryption_key : process(clk)
	begin
		if(rising_edge(clk)) then
			if (enc_dec = '1' and sel_load_new_dec_key = '1') then
				decryption_key <= new_round_key;
			else
				decryption_key <= (others => '0');
			end if;
		end if;
	end process;

reg_whitening_key : process(clk)
	begin
		if(rising_edge(clk)) then
			if(sel_load_new_enc_key = '1' or sel_load_new_dec_key = '1') then
				whitening_key <= input_key;
			end if;
		end if;
	end process;
    
ctr_round_number : process(clk)
    begin
        if(rising_edge(clk)) then
            if(clean_internal_registers = '0') then
                round_number <= (others => '0');
            elsif(round_number_rstn = '0') then
                if(encryption_mode_enabled = '1') then
                    round_number <= (others => '0');
                else
                    round_number <= "1" & X"3";	-- You cannot directly initialize vectors that are not multiples of 4 bits
                end if;
            elsif(round_number_enable = '1') then
                if(encryption_mode_enabled = '1') then
                    round_number <= std_logic_vector(unsigned(round_number) + to_unsigned(1, 5));
                else
                    round_number <= std_logic_vector(unsigned(round_number) - to_unsigned(1, 5));
                end if;
            else
                null;
            end if;
        end if;
    end process;


encryption_mode_enabled <= enc_dec or round_number_key_generation;
                           
round_mixcolumn_a <= intermediate_text_shufflecell when (enc_dec = '1') else
						whitening_key when (sel_generate_decryption_key  = '1') else
                      	intermediate_text_subcell;

round_add_key_after_mix_a <= intermediate_text_mixcolumn when (enc_dec = '1') else
				             	intermediate_text_inv_shufflecell;

round_add_round_constant_a <= intermediate_text_add_key_after_mix_enc when (enc_dec = '1') else
								intermediate_text_add_key_after_mix_dec;

new_intermediate_text <= intermediate_text_add_round_constant_enc when (enc_dec = '1') else
								intermediate_text_add_round_constant_dec;

is_last_key <= '1' when (((encryption_mode_enabled = '1') and to_integer(unsigned(round_number)) = 15) or ((encryption_mode_enabled = '0') and to_integer(unsigned(round_number)) = 1)) else '0';
                         
output_text <= intermediate_text_final_add_key;


    
end behavioral;