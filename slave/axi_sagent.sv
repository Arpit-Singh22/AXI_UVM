class axi_sagent extends uvm_agent;
	axi_mon mon;
	axi_responder responder;

	`uvm_component_utils(axi_sagent)
	`NEW_COMP
	function void build();
		mon=axi_mon::type_id::create("mon",this);
		responder=axi_responder::type_id::create("responder",this);
	endfunction

	function void connect();
		//mon.ap_port.connect(cov.analysis_export);
	endfunction
endclass
