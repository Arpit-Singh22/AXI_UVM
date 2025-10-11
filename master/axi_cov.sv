class axi_cov extends uvm_subscriber#(axi_tx);
	axi_tx tx;
	`uvm_component_utils(axi_cov)
	covergroup axi_cg;
		ADDR_CP: coverpoint tx.addr {
			option.auto_bin_max = 8;
		}
		WR_RD_CP: coverpoint tx.wr_rd {
			bins WRITE = {1'b1};
			bins READ  = {1'b0};
		}
		BURST_LEN_CP: coverpoint tx.burst_len {
			option.auto_bin_max = 8;
		}
		BURST_SIZE_CP: coverpoint tx.burst_size {
			bins BYTE_SIZE_1  = {3'b000};
			bins BYTE_SIZE_2  = {3'b001};
			bins BYTE_SIZE_4  = {3'b010};
			bins BYTE_SIZE_8  = {3'b100};
			bins BYTE_SIZE_16 = {3'b100};
			bins BYTE_SIZE_32 = {3'b101};
			bins BYTE_SIZE_64 = {3'b110};
			bins BYTE_SIZE_128 = {3'b111};
		}
		BURST_TYPE_CP: coverpoint tx.burst_type{
			bins FIXED  = {2'b00};
			bins INCR   = {2'b01};
			bins WRAP   = {2'b10};
			illegal_bins ILLEGAL = {2'b11};
		}
		ADDR_X_WR_RD_CP: cross ADDR_CP, WR_RD_CP;
		BURST_TYPE_X_WR_RD_CP: cross BURST_TYPE_CP, WR_RD_CP;
	endgroup

	function new(string name, uvm_component parent);
		super.new(name, parent);
		axi_cg = new();
	endfunction

	function void write(axi_tx t);
		$cast(tx,t);
		axi_cg.sample();
	endfunction
endclass
