class axi_base_test extends uvm_test;
	axi_env env;
	`uvm_component_utils(axi_base_test)
	`NEW_COMP
	
	function void build();
		env = axi_env::type_id::create("env", this);
	endfunction
	
	function void end_of_elaboration();
		uvm_top.print_topology();
	endfunction

	function void report();
		`ifdef TX_COMPARE
		if(num_mismatches == 0 && num_matches == 2*count) begin //transaction level compare
			`uvm_info("STATUS", $psprintf("TEST_PASSED, num_matches=%0d",num_matches), UVM_NONE);
		end
		
		`elsif BYTE_COMPARE
		if(num_mismatches == 0 && num_matches == exp_byte_count) begin //byte compare 
			`uvm_info("STATUS", $psprintf("TEST_PASSED, exp_byte_count=%0d",exp_byte_count), UVM_NONE);
		end
		`endif
		else begin
			`uvm_error("STATUS", "TEST_FAILED");
		end
	endfunction
endclass

`AXI_TEST(axi_wr_rd_test, axi_wr_rd_seq)
`AXI_TEST(axi_5wr_5rd_test, axi_5wr_5rd_seq)
`AXI_TEST(axi_burst_len_test, axi_burst_len_seq)
`AXI_TEST(axi_burst_size_test, axi_burst_size_seq)
`AXI_TEST(axi_wr_rd_wrap_test, axi_wr_rd_wrap_seq)

