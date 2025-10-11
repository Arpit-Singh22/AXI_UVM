interface axi_interface(input logic aclk,arstn);
	// write address channels
	bit awvalid;
	bit awready;
	bit [3:0] awid;
	bit [`ADDR_WIDTH-1:0] awaddr;
	bit [7:0] awlen;
	bit [2:0] awsize;
	bit [1:0] awburst;
	bit [1:0] awlock;
	bit [3:0] awcache;
	bit [1:0] awprot;
	
	//write data channel
	bit [`DATA_WIDTH-1:0] wdata;
	bit [`DATA_WIDTH/8-1:0] wstrb;
	bit [3:0] wid;
	bit wvalid;
	bit wready;
	bit wlast;

	//write response channel
	bit [1:0] bresp;
	bit [3:0] bid;
	bit bvalid;
	bit bready;

	//read request channel
	bit [`ADDR_WIDTH-1:0] araddr;
	bit [3:0] arid;
	bit [2:0] arsize;
	bit [7:0] arlen;
	bit [1:0] arburst;
	bit [1:0] arprot;
	bit [3:0] arcache;
	bit [1:0] arlock;
	bit arvalid;
	bit arready;

	//read data channel
	bit [`DATA_WIDTH-1:0] rdata;
	bit [3:0] rid;
	bit rvalid;
	bit rready;
	bit rlast;
	bit [1:0] rresp;
	
	clocking drv_cb@(posedge aclk);
		default input #1 output #0;
		output awid, awaddr, awlen, awsize, awburst, awlock,awvalid;
		input #0 arstn, awready, wready;
		output wid, wdata, wstrb, wlast, wvalid;
		input #0 bid, bresp, bvalid;
		output bready;

		output arid, araddr, arlen, arsize, arburst, arlock, arvalid;
		input #0 arready;
		input #0 rid, rdata, rlast, rvalid, rresp;
		output #0 rready;	// only for rready keep skew at 0
	endclocking
	
	clocking mon_cb@(posedge aclk);
		default input #0;
		input awid, awaddr, awlen, awsize, awburst, awlock,awvalid;
		input arstn, awready, wready;
		input wid, wdata, wstrb, wlast, wvalid;
		input bid, bresp, bvalid;
		input bready;

		input arid, araddr, arlen, arsize, arburst, arlock, arvalid;
		input arready;
		input rid, rdata, rlast, rvalid, rresp;
		input rready;	
	endclocking  

	clocking responder_cb@(posedge aclk);
		default input #0 output #0;
		input arstn;

		input awid, awaddr, awlen, awsize, awburst, awlock,awvalid;
		output awready;

		input wid, wdata, wstrb, wlast, wvalid;
		output wready;

		output bid, bresp, bvalid;
		input bready;

		input arid, araddr, arlen, arsize, arburst, arlock, arvalid;
		output arready;
		
		output rid, rdata, rlast, rvalid, rresp;
		input #0 rready;	// only for rready keep skew at 0
	endclocking
endinterface
