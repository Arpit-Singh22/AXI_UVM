class axi_driver extends uvm_driver#(axi_tx);
	virtual axi_interface vif;
	`uvm_component_utils(axi_driver)
	`NEW_COMP

	function void build();
		if(!`GET_INTF)
			`uvm_error("INTF","interface error in master driver");
	endfunction

	task run();
		wait (vif.arstn == 1);
		forever begin
			seq_item_port.get_next_item(req);
			req.print();
			drive_tx(req);
			seq_item_port.item_done();
		end
	endtask

	task drive_tx(axi_tx tx);
		if(tx.wr_rd) begin
			write_addr_phase(tx);
			write_data_phase(tx);
			write_resp_phase(tx);
			exp_byte_count += (tx.burst_len+1)*(2**tx.burst_size);
		end
		else begin 
			read_addr_phase(tx);
			read_data_phase(tx);
		end
	endtask

	task write_addr_phase(axi_tx tx);
		@(posedge vif.aclk)
		vif.awaddr  = tx.addr;
		vif.awlen   = tx.burst_len;
		vif.awsize  = tx.burst_size;
		vif.awburst = tx.burst_type;
		vif.awid	= tx.tx_id;
		vif.awvalid = 1'b1;
		wait (vif.awready==1);

		@(posedge vif.aclk)
		vif.awaddr  = 0; 
		vif.awlen   = 0; 
		vif.awsize  = 0; 
		vif.awburst = 0; 
		vif.awid	= 0; 
		vif.awvalid = 0; 
	endtask

	task write_data_phase(axi_tx tx);
		for(int i = 0; i <= tx.burst_len; i++) begin
			@(posedge vif.aclk);
			vif.wdata  = tx.dataQ.pop_front();
			vif.wstrb  = tx.strbQ.pop_front();
			vif.wid    = tx.tx_id;
			vif.wvalid = 1'b1;
			vif.wlast  = (i == tx.burst_len) ? 1'b1 : 1'b0;
			wait(vif.wready);
		end
			@(posedge vif.aclk);
			vif.wdata  = 0; 
			vif.wstrb  = 0; 
			vif.wid    = 0; 
			vif.wlast  = 0; 
			vif.wvalid = 0;
	endtask
 
	task write_resp_phase(axi_tx tx);
		while(vif.bvalid==0) begin
			@(posedge vif.aclk);
		end
		vif.bready = 1;

		@(posedge vif.aclk);
		vif.bready = 0;
	endtask

	task read_addr_phase(axi_tx tx);
		@(posedge vif.aclk);
		vif.araddr  = tx.addr;
		vif.arlen   = tx.burst_len;
		vif.arsize  = tx.burst_size;
		vif.arburst = tx.burst_type;
		vif.arid	= tx.tx_id;
		vif.arvalid = 1'b1;
		wait (vif.arready==1'b1);

		@(posedge vif.aclk)
		vif.araddr  = 0; 
		vif.arlen   = 0; 
		vif.arsize  = 0; 
		vif.arburst = 0; 
		vif.arid	= 0; 
		vif.arvalid = 0; 
	endtask

	task read_data_phase(axi_tx tx);
		//vif.rready = 1;
		repeat(tx.burst_len+1) begin
			while(vif.rvalid == 0) begin
				@(posedge vif.aclk);
			end
		vif.rready = 1;
		@(posedge vif.aclk);
		vif.rready = 0;
		end
		vif.rready = 0;
	endtask
endclass
