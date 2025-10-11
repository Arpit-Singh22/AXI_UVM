class axi_driver extends uvm_driver#(axi_tx);
	virtual axi_interface vif;
	`uvm_component_utils(axi_driver) `NEW_COMP

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
		end
		else begin 
			read_addr_phase(tx);
			read_data_phase(tx);
		end
	endtask

	task write_addr_phase(axi_tx tx);
		@(vif.drv_cb)
		vif.drv_cb.awaddr  <= tx.addr;
		vif.drv_cb.awlen   <= tx.burst_len;
		vif.drv_cb.awsize  <= tx.burst_size;
		vif.drv_cb.awburst <= tx.burst_type;
		vif.drv_cb.awid	   <= tx.tx_id;
		vif.drv_cb.awvalid <= 1'b1;
		wait (vif.drv_cb.awready==1);

		@( vif.drv_cb)
		vif.drv_cb.awaddr  <= 0; 
		vif.drv_cb.awlen   <= 0; 
		vif.drv_cb.awsize  <= 0; 
		vif.drv_cb.awburst <= 0; 
		vif.drv_cb.awid	   <= 0; 
		vif.drv_cb.awvalid <= 0; 
	endtask

	task write_data_phase(axi_tx tx);
		for(int i = 0; i <= tx.burst_len; i++) begin
			@(vif.drv_cb);
			vif.drv_cb.wdata  <= tx.dataQ.pop_front();
			vif.drv_cb.wstrb  <= tx.strbQ.pop_front();
			vif.drv_cb.wid    <= tx.tx_id;
			vif.drv_cb.wvalid <= 1'b1;
			vif.drv_cb.wlast  <= (i == tx.burst_len) ? 1'b1 : 1'b0;
			wait(vif.drv_cb.wready);
			@(vif.drv_cb);
			vif.drv_cb.wdata  <= 0; 
			vif.drv_cb.wstrb  <= 0; 
			vif.drv_cb.wid    <= 0; 
			vif.drv_cb.wlast  <= 0; 
			vif.drv_cb.wvalid <= 0;
		end
	endtask
 
	task write_resp_phase(axi_tx tx);
		while(vif.drv_cb.bvalid==0) begin
			@(vif.drv_cb);
		end
		vif.drv_cb.bready <= 1;
		
		@( vif.drv_cb);
		vif.drv_cb.bready <= 0;
	endtask
	
	task read_addr_phase(axi_tx tx);
		@(vif.drv_cb);
		vif.drv_cb.araddr  <= tx.addr;
		vif.drv_cb.arlen   <= tx.burst_len;
		vif.drv_cb.arsize  <= tx.burst_size;
		vif.drv_cb.arburst <= tx.burst_type;
		vif.drv_cb.arid	   <= tx.tx_id;
		vif.drv_cb.arvalid <= 1'b1;
		wait (vif.drv_cb.arready==1'b1);

		@( vif.drv_cb)
		vif.drv_cb.araddr  <= 0; 
		vif.drv_cb.arlen   <= 0; 
		vif.drv_cb.arsize  <= 0; 
		vif.drv_cb.arburst <= 0; 
		vif.drv_cb.arid	   <= 0; 
		vif.drv_cb.arvalid <= 0; 
	endtask

	task read_data_phase(axi_tx tx);
		vif.drv_cb.rready <= 1;
		repeat(tx.burst_len+1) begin
			while(vif.drv_cb.rvalid == 0) begin
				@(vif.drv_cb);
			end
		//vif.drv_cb.rready <= 1;
		@(vif.drv_cb);
		//vif.drv_cb.rready <= 0;
		end
		@(vif.drv_cb);
		vif.drv_cb.rready <= 0;
	endtask
endclass
