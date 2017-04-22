.PHONY: clean
GHDL=ghdl
GHDLFLAGS=--ieee=synopsys

SBOX_OBJ=\
	midori_sb1.o \
	midori_ssbi.o
TB_SBOX=tb_midori_ssbi

MIXCOLUMNS_OBJ=\
	aes_multiply_x_gf_2.o \
	aes_mixcolumn_multiplication.o \
	aes_mixcolumns.o
TB_MIXCOLUMNS=tb_aes_mixcolumns

SHIFTROWS_OBJ=\
	aes_shiftrows.o
TB_SHIFTROWS=tb_aes_shiftrows

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

test_core: $(CORE_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_CORE).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_CORE)
	$(GHDL) -r $(GHDLFLAGS) $(TB_CORE) --wave=$(TB_CORE).ghw

test_mixcolumns: $(MIXCOLUMNS_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_MIXCOLUMNS).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_MIXCOLUMNS)
	$(GHDL) -r $(GHDLFLAGS) $(TB_MIXCOLUMNS) --wave=$(TB_MIXCOLUMNS).ghw

test_shiftrows: $(SHIFTROWS_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_SHIFTROWS).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SHIFTROWS)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SHIFTROWS) --wave=$(TB_SHIFTROWS).ghw

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
