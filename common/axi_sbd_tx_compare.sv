`uvm_analysis_imp_decl(_master)
`uvm_analysis_imp_decl(_slave)
class axi_sbd extends uvm_scoreboard;
	uvm_analysis_imp_master#(axi_tx, axi_sbd) imp_master;
	uvm_analysis_imp_slave#(axi_tx, axi_sbd) imp_slave;
	axi_tx mst_txQ[$], mst_tx;
	axi_tx slv_txQ[$], slv_tx;
	`uvm_component_utils(axi_sbd)
	`NEW_COMP

	function void build();
		imp_master = new("imp_master", this);
		imp_slave  = new("imp_slave", this);
	endfunction

	function void write_master(axi_tx tx);
		mst_txQ.push_back(tx);
	endfunction

	function void write_slave(axi_tx tx);
		slv_txQ.push_back(tx);
	endfunction

	task run();
		forever begin
			wait (mst_txQ.size() >0 && slv_txQ.size() >0);
			mst_tx = mst_txQ.pop_front();
			slv_tx = slv_txQ.pop_front();
			if(mst_tx.compare(slv_tx)) begin
				num_matches++;
			end
			else begin
				num_mismatches++;
				`uvm_error("COMPARE","Tx mismatches");
			end
		end
	endtask
endclass
