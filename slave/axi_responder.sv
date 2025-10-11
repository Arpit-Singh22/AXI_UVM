class axi_responder extends uvm_component;
	virtual axi_interface vif;
	byte mem[*];
	bit [`ADDR_WIDTH-1:0] awaddr_t;
	bit [3:0] awlen_t;
	bit [2:0] awsize_t;
	bit [1:0] awburst_t;

	bit [`ADDR_WIDTH-1:0] araddr_t;
	bit [3:0] arlen_t;
	bit [2:0] arsize_t;
	bit [1:0] arburst_t;

	bit [`ADDR_WIDTH-1:0] wrap_lower_addr;
	bit [`ADDR_WIDTH-1:0] wrap_upper_addr;
    int tx_size;
	`uvm_component_utils(axi_responder)
	`NEW_COMP

	function void build();
		if(!`GET_INTF)
			`uvm_error("INTF","interface error in responder");
	endfunction
	int count;
	task run();
		forever begin
			@(vif.responder_cb);
			vif.responder_cb.awready <= vif.responder_cb.awvalid;
			
			if(vif.responder_cb.awvalid) begin
				awaddr_t   = vif.responder_cb.awaddr;
				awlen_t    = vif.responder_cb.awlen;
				awsize_t   = vif.responder_cb.awsize;
				awburst_t  = vif.responder_cb.awburst;
                tx_size    = (awlen_t + 1)*(2**awsize_t);
                wrap_lower_addr = awaddr_t - (awaddr_t % tx_size);
                wrap_upper_addr = wrap_lower_addr + tx_size - 1;
                `uvm_info("WRAP_ADDR",$psprintf("wrap_lower=%0h, wrap_upper=%0h",wrap_lower_addr,wrap_upper_addr),UVM_LOW)
			end

			vif.responder_cb.wready  <= vif.responder_cb.wvalid;
			if(vif.responder_cb.wvalid) begin
                `uvm_info("WRITE",$psprintf("awaddr_t=%0h, wdata=%0h",awaddr_t,vif.responder_cb.wdata),UVM_LOW)
				mem[awaddr_t+0]  = vif.responder_cb.wdata[7:0];
				mem[awaddr_t+1]  = vif.responder_cb.wdata[15:8];
				mem[awaddr_t+2]  = vif.responder_cb.wdata[23:16];
				mem[awaddr_t+3]  = vif.responder_cb.wdata[31:24];
				awaddr_t += 2**awsize_t;
                if (awburst_t == WRAP && awaddr_t > wrap_upper_addr ) begin
                    awaddr_t = wrap_lower_addr;
                end
			end

			if(vif.responder_cb.wlast) 
				do_write_resp_phase(vif.responder_cb.wid);
				
			vif.responder_cb.arready <= vif.responder_cb.arvalid;
			if(vif.responder_cb.arvalid) begin
				araddr_t   = vif.responder_cb.araddr;
				arlen_t    = vif.responder_cb.arlen;
				arsize_t   = vif.responder_cb.arsize;
				arburst_t  = vif.responder_cb.arburst;
                tx_size    = (arlen_t + 1)*(2**arsize_t);
                wrap_lower_addr = araddr_t - (araddr_t % tx_size);
                wrap_upper_addr = wrap_lower_addr + tx_size - 1;
				do_read_data_phase(vif.responder_cb.arid, vif.responder_cb.arlen);
			end
		end
	endtask

	task do_write_resp_phase(bit [3:0]id);
		@(vif.responder_cb);
		vif.responder_cb.bvalid <= 1'b1;
		vif.responder_cb.bresp  <= 2'b00;	// OKAY response
		vif.responder_cb.bid    <= id;
		wait (vif.responder_cb.bready==1'b1);

		@(vif.responder_cb);
		vif.responder_cb.bvalid <= 0; 
		vif.responder_cb.bresp  <= 0; 
		vif.responder_cb.bid    <= 0; 
	endtask
	
	task do_read_data_phase(bit [3:0] id,bit [3:0] arlen);
		for(int i=0; i <= arlen; i++) begin
			@(vif.responder_cb);
			vif.responder_cb.rid   <= id;
			vif.responder_cb.rvalid <= 1'b1;
			vif.responder_cb.rdata <={
						mem[araddr_t+3],  
			            mem[araddr_t+2],
						mem[araddr_t+1],
                        mem[araddr_t+0]
						};
			vif.responder_cb.rresp <= 2'b00;
			vif.responder_cb.rlast <= (i == arlen) ? 1 : 0;
            `uvm_info("READ",$psprintf("araddr_t=%0h, rdata=%0h",araddr_t,vif.responder_cb.rdata),UVM_LOW)
			wait(vif.responder_cb.rready ==1);
			araddr_t += 2**arsize_t;
            if (arburst_t == WRAP && araddr_t > wrap_upper_addr ) begin
                araddr_t = wrap_lower_addr;
            end
		end
		@(vif.responder_cb);
		vif.responder_cb.rid    <= 0; 
		vif.responder_cb.rdata  <= 0; 
		vif.responder_cb.rresp  <= 0;
		vif.responder_cb.rlast  <= 0; 
		vif.responder_cb.rvalid <= 0;
	endtask
endclass
