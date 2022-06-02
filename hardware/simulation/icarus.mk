CACHE_DIR:=../../..

ELAB_MODULE=iob_cache_tb

include ../simulation.mk

VSRC+=$(CACHE_HW_DIR)/simulation/verilog_tb/iob_cache_tb.v

run: $(VHDR) $(VSRC)
	iverilog -W all -g2005-sv $(VSRC) -s $(ELAB_MODULE)
	./a.out $(TEST_LOG)
ifeq ($(VCD),1)
	if [ "`pgrep -u $(USER) gtkwave`" ]; then killall -q -9 gtkwave; fi
	gtkwave -a ../waves.gtkw uut.vcd &
endif	

clean: sim-clean
	@rm -f a.out

.PHONY: run clean
