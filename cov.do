vlog list.svh +incdir+/home/jedi/Downloads/uvm-1.2/src +define+TX_COMPARE \
-assertdebug

vopt work.top +cover=fcbest -o axi_5wr_rd_test

vsim -coverage -assertdebug axi_5wr_rd_test \
-sv_lib /usr/local/questasim/uvm-1.2/linux_x86_64/uvm_dpi \
+UVM_TIMEOUT=5000 +UVM_TESTNAME=axi_5wr_rd_test

coverage save -onexit AXI_5WR_RD_TEST.ucdb

#add wave -position insertpoint sim:/top/pif/*
do wave.do
run -all
