`define WIDTH 8
`define DEPTH 16
`define ADDR_WIDTH $clog2(`DEPTH)

module memory(axi_interface.design_mp mp);
	reg [`WIDTH-1:0] mem [`DEPTH-1:0];
	integer i;

	always @(posedge mp.clk) begin
		if(mp.res) begin
			mp.rdata=0;
			mp.ready=0;
			for(i=0;i<`DEPTH;i=i+1) mem[i]=0;
		end else begin
			if(mp.valid) begin
				mp.ready=1;
				if(mp.wr_rd_en) mem[mp.addr]=mp.wdata;
				else mp.rdata=mem[mp.addr];
			end else begin
				mp.ready=0;
			end
		end
	end
endmodule
