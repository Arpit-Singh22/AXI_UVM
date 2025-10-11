class axi_env extends uvm_env;
	axi_magent magent;
	axi_sagent sagent;
	axi_sbd sbd;
	`uvm_component_utils(axi_env);
	`NEW_COMP

	function void build();
		magent = axi_magent::type_id::create("magent", this);
		sagent = axi_sagent::type_id::create("sagent", this);
		sbd = axi_sbd::type_id::create("sbd", this);
	endfunction

	function void connect();
		magent.mon.ap_port.connect(sbd.imp_master);	
		`ifdef TX_COMPARE
		sagent.mon.ap_port.connect(sbd.imp_slave);	
		`endif
	endfunction
endclass
