class axi_mon extends uvm_monitor;
	`uvm_component_utils(axi_mon)
	virtual axi_interface vif;
	uvm_analysis_port#(axi_tx) ap_port;
	`NEW_COMP
	axi_tx wr_txA[15:0]; 
	axi_tx rd_txA[15:0];
	string name;

	function void build();
		ap_port = new("ap_port", this);
		if(!`GET_INTF)
			`uvm_error("INTFERR","interface error in monitor");
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			@(posedge vif.aclk);
			if(vif.awvalid && vif.awready) begin
				name = $sformatf("wr_txA[%0d]",vif.awid);
				wr_txA[vif.awid] = axi_tx::type_id::create(name);
				wr_txA[vif.awid].wr_rd = 1'b1;
				wr_txA[vif.awid].addr       = vif.awaddr;
				wr_txA[vif.awid].burst_len  = vif.awlen;
				wr_txA[vif.awid].burst_size = vif.awsize;
				wr_txA[vif.awid].burst_type = burst_type_t'(vif.awburst);
				wr_txA[vif.awid].tx_id		= vif.awid;
			end
			#1;
			if(vif.wvalid && vif.wready) begin
				wr_txA[vif.wid].dataQ.push_back(vif.wdata);
				wr_txA[vif.wid].strbQ.push_back(vif.wstrb);
			end
			if(vif.bvalid && vif.bready) begin
				wr_txA[vif.bid].respQ.push_back(vif.bresp);
				ap_port.write(wr_txA[vif.bid]);
				//wr_txA[vif.bid].print();
			end
			if(vif.arvalid && vif.arready) begin
				name = $sformatf("rd_txA[%0d]",vif.arid);
				rd_txA[vif.arid] = axi_tx::type_id::create(name);
				rd_txA[vif.arid].wr_rd = 1'b0;
				rd_txA[vif.arid].addr       = vif.araddr;
				rd_txA[vif.arid].burst_len  = vif.arlen;
				rd_txA[vif.arid].burst_size = vif.arsize;
				rd_txA[vif.arid].burst_type = burst_type_t'(vif.arburst);
				rd_txA[vif.arid].tx_id		= vif.arid;
			end
			if(vif.rvalid && vif.rready) begin
				rd_txA[vif.rid].dataQ.push_back(vif.rdata);
				rd_txA[vif.rid].respQ.push_back(vif.rresp);
				if(vif.rlast) begin
					ap_port.write(rd_txA[vif.rid]);
					//rd_txA[vif.rid].print();
				end
			end
		end
	endtask
endclass 
