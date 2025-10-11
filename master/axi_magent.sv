class axi_magent extends uvm_agent;
	axi_driver driver;
	axi_sequencer sqr;
	axi_mon mon;
	axi_cov cov;

	`uvm_component_utils(axi_magent)
	`NEW_COMP
	function void build_phase(uvm_phase phase);
		driver=axi_driver::type_id::create("driver",this);
		sqr=axi_sequencer::type_id::create("sqr",this);
		mon=axi_mon::type_id::create("mon",this);
		cov=axi_cov::type_id::create("cov",this);
	endfunction

	function void connect();
		driver.seq_item_port.connect(sqr.seq_item_export);
		mon.ap_port.connect(cov.analysis_export);
	endfunction
endclass
