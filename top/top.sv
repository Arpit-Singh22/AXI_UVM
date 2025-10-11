module top;
	logic clk,rst;

	axi_interface pif(clk,rst);
    axi_assertions axi_assertions_i(pif);
	//memory dut(pif.design_mp);
	initial begin
		uvm_config_db#(virtual axi_interface)::set(null,"*","vif",pif); 
	end

	always #5 clk=~clk;
	initial begin
		clk=0;
		rst=0;
		repeat(3) @(posedge clk);
		rst=1;
	end
	initial begin
		//$fsdbDumpfile("axi.fsdb");
		//$fsdbDumpvars;
		run_test("axi_wr_rd_test");
	end
endmodule
