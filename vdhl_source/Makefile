.PHONY: clean
GHDL=ghdl
GHDLFLAGS=--ieee=synopsys


SBOX_OBJ=\
	midori_sb1.o \
	midori_ssbi.o
TB_SBOX=tb_midori_ssbi

SUBCELL_OBJ=\
	midori_sb1.o \
	midori_ssbi.o \
	midori_subcell.o
TB_SUBCELL=tb_midori_subcell

MIXCOLUMNS_OBJ=\
	midori_mixcolumn.o
TB_MIXCOLUMNS=tb_midori_mixcolumn

SHUFFLECELL_OBJ=\
	midori_shufflecell.o
TB_SHUFFLECELL=tb_midori_shufflecell

INVSHUFFLECELL_OBJ=\
	midori_invshufflecell.o
TB_INVSHUFFLECELL=tb_midori_invshufflecell

ROUNDCONSTANTS_ENC_OBJ=\
	midori_roundconstants_enc.o
TB_ROUNDCONSTANTS_ENC=tb_midori_roundconstants_enc


CORE_OBJ=\
	$(SHIFTROWS_OBJ)\
	$(MIXCOLUMNS_OBJ)\
	aes_inverse_multiply_x_gf_2.o \
	aes_addroundkeys.o \
	aes_all_rounds_keys.o \
	aes_sbox.o \
	aes_subbytes.o \
	aes_update_key.o \
	aes128_core_state_machine.o \
	aes128_core.o
TB_CORE=tb_aes128_core

test_sbox: $(SBOX_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_SBOX).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SBOX)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SBOX) --wave=$(TB_SBOX).ghw

test_subcell: $(SUBCELL_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_SUBCELL).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SUBCELL)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SUBCELL) --wave=$(TB_SUBCELL).ghw

test_mixcolumns: $(MIXCOLUMNS_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_MIXCOLUMNS).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_MIXCOLUMNS)
	$(GHDL) -r $(GHDLFLAGS) $(TB_MIXCOLUMNS) --wave=$(TB_MIXCOLUMNS).ghw

test_shufflecell: $(SHUFFLECELL_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_SHUFFLECELL).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SHUFFLECELL)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SHUFFLECELL) --wave=$(TB_SHUFFLECELL).ghw

test_invshufflecell: $(INVSHUFFLECELL_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_INVSHUFFLECELL).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_INVSHUFFLECELL)
	$(GHDL) -r $(GHDLFLAGS) $(TB_INVSHUFFLECELL) --wave=$(TB_INVSHUFFLECELL).ghw

test_roundconstants_enc: $(ROUNDCONSTANTS_ENC_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_ENC).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_ENC)
	$(GHDL) -r $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_ENC) --wave=$(TB_ROUNDCONSTANTS_ENC).ghw

test_core: $(CORE_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_CORE).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_CORE)
	$(GHDL) -r $(GHDLFLAGS) $(TB_CORE) --wave=$(TB_CORE).ghw

# Binary depends on the object file
%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

# Object file depends on source
%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

clean:
	@echo "Cleaning up..."
	rm -f *.ghw
	rm -f *.vcd
	rm -f work*.cf
