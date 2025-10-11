`uvm_analysis_imp_decl(_master)
class axi_sbd extends uvm_scoreboard;
	uvm_analysis_imp_master#(axi_tx, axi_sbd) imp_master;
	byte wr_byteQ[$], wr_byte;
	byte rd_byteQ[$], rd_byte;
	`uvm_component_utils(axi_sbd)
	`NEW_COMP

	function void build();
		imp_master = new("imp_master", this);
	endfunction

	// byte comparision
	function void write_master(axi_tx tx);
		if (tx.wr_rd == 1) begin
			for(int i=0; i <= tx.burst_len; i++) begin
				wr_byteQ.push_back(tx.dataQ[i][31:24]);
				wr_byteQ.push_back(tx.dataQ[i][23:16]);
				wr_byteQ.push_back(tx.dataQ[i][15:8]);
				wr_byteQ.push_back(tx.dataQ[i][7:0]);
			end
		end
		else begin
			for(int i=0; i <= tx.burst_len; i++) begin
				rd_byteQ.push_back(tx.dataQ[i][31:24]);
				rd_byteQ.push_back(tx.dataQ[i][23:16]);
				rd_byteQ.push_back(tx.dataQ[i][15:8]);
				rd_byteQ.push_back(tx.dataQ[i][7:0]);
			end
		end
	endfunction
	
	task run();
		forever begin
			//do byte by byte comparision
			wait(wr_byteQ.size() > 0 && rd_byteQ.size() > 0);
			wr_byte = wr_byteQ.pop_front();
			rd_byte = rd_byteQ.pop_front();
			if (wr_byte == rd_byte) num_matches++;
			else begin
				num_mismatches++;
				`uvm_error("COMPARE_FAIL", $psprintf("wr_byte=%h, rd_byte=%h",wr_byte,rd_byte))
			end
		end
	endtask
endclass
