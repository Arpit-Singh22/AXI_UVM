`uvm_analysis_imp_decl(_master)
class axi_sbd extends uvm_scoreboard;
	uvm_analysis_imp_master#(axi_tx, axi_sbd) imp_master;
	byte wr_byteAA[*];
	`uvm_component_utils(axi_sbd)
	`NEW_COMP

	function void build();
		imp_master = new("imp_master", this);
	endfunction

	function void write_master(axi_tx tx);
		if (tx.wr_rd == 1) begin
			for(int i=0; i <= tx.burst_len; i++) begin
				wr_byteAA[tx.addr+3] = (tx.dataQ[i][31:24]);
				wr_byteAA[tx.addr+2] = (tx.dataQ[i][23:16]);
				wr_byteAA[tx.addr+1] = (tx.dataQ[i][15:8]);
				wr_byteAA[tx.addr+0] = (tx.dataQ[i][7:0]);
				tx.addr += 2**tx.burst_size;
			end
		end
		else begin
			for(int i=0; i <= tx.burst_len; i++) begin
				if ( wr_byteAA[tx.addr+3] == (tx.dataQ[i][31:24]) &&
				wr_byteAA[tx.addr+2] == (tx.dataQ[i][23:16]) &&
				wr_byteAA[tx.addr+1] == (tx.dataQ[i][15:8]) &&
				wr_byteAA[tx.addr+0] == (tx.dataQ[i][7:0]) )
				begin
					num_matches += 4;
				end
				else num_mismatches += 4;
				tx.addr += 2**tx.burst_size;
			end
		end
	endfunction
endclass
