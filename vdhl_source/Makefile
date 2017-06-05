.PHONY: clean
GHDL=ghdl
GHDLFLAGS=-g --ieee=synopsys --std=93c 


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

INV_SHUFFLECELL_OBJ=\
	midori_inv_shufflecell.o
TB_INV_SHUFFLECELL=tb_midori_inv_shufflecell

ROUNDCONSTANTS_ENC_OBJ=\
	midori_roundconstants_enc.o
TB_ROUNDCONSTANTS_ENC=tb_midori_roundconstants_enc

ROUNDCONSTANTS_DEC_OBJ=\
	$(INV_SHUFFLECELL_OBJ)\
	$(MIXCOLUMNS_OBJ)\
	midori_roundconstants_dec.o
TB_ROUNDCONSTANTS_DEC=tb_midori_roundconstants_dec

CORE_OBJ=\
	$(SUBCELL_OBJ)\
	$(MIXCOLUMNS_OBJ)\
	$(SHUFFLECELL_OBJ)\
	$(INV_SHUFFLECELL_OBJ)\
	$(ROUNDCONSTANTS_DEC_OBJ)\
	midori_key_add.o\
	midori_roundconstants_enc\
	midori_roundconstants_dec.o\
	midori_core_state_machine.o \
	midori_core.o
TB_CORE=tb_midori_core

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

test_inv_shufflecell: $(INV_SHUFFLECELL_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_INV_SHUFFLECELL).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_INV_SHUFFLECELL)
	$(GHDL) -r $(GHDLFLAGS) $(TB_INV_SHUFFLECELL) --wave=$(TB_INV_SHUFFLECELL).ghw

test_roundconstants_enc: $(ROUNDCONSTANTS_ENC_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_ENC).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_ENC)
	$(GHDL) -r $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_ENC) --wave=$(TB_ROUNDCONSTANTS_ENC).ghw

test_roundconstants_dec: $(ROUNDCONSTANTS_DEC_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_DEC).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_DEC)
	$(GHDL) -r $(GHDLFLAGS) $(TB_ROUNDCONSTANTS_DEC) --wave=$(TB_ROUNDCONSTANTS_DEC).ghw

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
