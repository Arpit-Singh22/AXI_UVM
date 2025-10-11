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
	`uvm_component_utils(axi_responder)
	`NEW_COMP

	function void build();
		if(!`GET_INTF)
			`uvm_error("INTF","interface error in responder");
	endfunction
	int count;
	task run();
		forever begin
			@(posedge vif.aclk);
			vif.awready = vif.awvalid;
			vif.wready  = vif.wvalid;
			vif.arready = vif.arvalid;
			
			if(vif.awvalid) begin
				awaddr_t   = vif.awaddr;
				awlen_t    = vif.awlen;
				awsize_t   = vif.awsize;
				awburst_t  = vif.awburst;
			end

			if(vif.arvalid ) begin
				araddr_t   = vif.araddr;
				arlen_t    = vif.arlen;
				arsize_t   = vif.arsize;
				arburst_t  = vif.arburst;
				do_read_data_phase(vif.arid, vif.arlen);
			end

			if(vif.wlast) 
				do_write_resp_phase(vif.wid);
						
			if(vif.wvalid) begin
				mem[awaddr_t+0]  = vif.wdata[7:0];
				mem[awaddr_t+1]  = vif.wdata[15:8];
				mem[awaddr_t+2]  = vif.wdata[23:16];
				mem[awaddr_t+3]  = vif.wdata[31:24];
				awaddr_t += 2**awsize_t;
			end
		end
	endtask

	task do_write_resp_phase(bit [3:0]id);
		@(posedge vif.aclk);
		vif.bvalid = 1'b1;
		vif.bresp  = 2'b00;	// OKAY response
		vif.bid    = id;
		wait (vif.bready==1'b1);

		@(posedge vif.aclk);
		vif.bvalid = 0; 
		vif.bresp  = 0; 
		vif.bid    = 0; 
	endtask
	
	task do_read_data_phase(bit [3:0] id,bit [3:0] arlen);
		for(int i=0; i <= arlen ; i++) begin
			@(posedge vif.aclk);
			vif.rid   = id;
			vif.rdata ={
						mem[araddr_t+3],  
			            mem[araddr_t+2],
						mem[araddr_t+1],
                        mem[araddr_t+0]
						};
			vif.rresp = 2'b00;
			vif.rlast = (i == arlen) ? 1 : 0;
			vif.rvalid = 1'b1;
			wait(vif.rready ==1);
			araddr_t += 2**arsize_t;
		end
		@(posedge vif.aclk);
		vif.rid    = 0; 
		vif.rdata  = 0; 
		vif.rresp  = 0;
		vif.rlast  = 0; 
		vif.rvalid = 0;
	endtask
endclass
