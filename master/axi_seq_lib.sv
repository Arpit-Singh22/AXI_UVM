class axi_base_seq extends uvm_sequence#(axi_tx);
	`uvm_object_utils(axi_base_seq)
	`NEW_OBJ
	//uvm_phase phase;

	//task pre_body();
	//	phase = get_starting_phase();
	//	if(phase != null) begin
	//		phase.raise_objection(this);
	//		phase.phase_done.set_drain_time(this, 50);
	//	end
	//endtask

	//task post_body();
	//	if(phase != null) begin
	//		phase.drop_objection(this);
	//	end
	//endtask
endclass

class axi_wr_rd_seq extends axi_base_seq;
	`uvm_object_utils(axi_wr_rd_seq)
	`NEW_OBJ

	task body();
		`uvm_do_with(req, {req.wr_rd==1;})
		`uvm_do_with(req, {req.wr_rd==0;})
	endtask
endclass

class axi_5wr_5rd_seq extends axi_base_seq;
	axi_tx txQ[$];
	axi_tx tx;
	`uvm_object_utils(axi_5wr_5rd_seq)
	`NEW_OBJ

	task body();
		repeat(count) begin
			`uvm_do_with(req, {req.wr_rd==1;})
			tx = new req;
			txQ.push_back(tx);
		end
		repeat(count) begin
			tx = txQ.pop_front();
			`uvm_do_with(req, {req.wr_rd      == 0;
							   req.addr       == tx.addr;
							   req.burst_len  == tx.burst_len;
							   req.burst_size == tx.burst_size;
							   req.burst_type == tx.burst_type;
							   req.tx_id == tx.tx_id;
								})
		end
	endtask
endclass

class axi_burst_len_seq extends axi_base_seq;
	axi_tx txQ[$];
	axi_tx tx;
	`uvm_object_utils(axi_burst_len_seq)
	`NEW_OBJ

	task body();
        for (int i=0; i<count; i++) begin
			`uvm_do_with(req, {req.wr_rd==1; req.burst_len==i;})
			tx = new req;
			txQ.push_back(tx);
		end
		repeat(count) begin
			tx = txQ.pop_front();
			`uvm_do_with(req, {req.wr_rd      == 0;
							   req.addr       == tx.addr;
							   req.burst_len  == tx.burst_len;
							   req.burst_size == tx.burst_size;
							   req.burst_type == tx.burst_type;
							   req.tx_id == tx.tx_id;
								})
		end
	endtask
endclass

class axi_burst_size_seq extends axi_base_seq;
	axi_tx txQ[$];
	axi_tx tx;
	`uvm_object_utils(axi_burst_size_seq)
	`NEW_OBJ

	task body();
        for (int i=0; i<count; i++) begin
			`uvm_do_with(req, {req.wr_rd==1; req.burst_size==i;})
			tx = new req;
			txQ.push_back(tx);
		end
		repeat(count) begin
			tx = txQ.pop_front();
			`uvm_do_with(req, {req.wr_rd      == 0;
							   req.addr       == tx.addr;
							   req.burst_len  == tx.burst_len;
							   req.burst_size == tx.burst_size;
							   req.burst_type == tx.burst_type;
							   req.tx_id == tx.tx_id;
								})
		end
	endtask
endclass

class axi_wr_rd_wrap_seq extends axi_base_seq;
    axi_tx txQ[$], tx;
    `uvm_object_utils(axi_wr_rd_wrap_seq)
    `NEW_OBJ
     
    task body();
        repeat(count) begin
            `uvm_do_with(req, {req.wr_rd==1; req.burst_type==WRAP;})
            tx = new req;
            txQ.push_back(tx);
        end
        txQ.shuffle();

        repeat(count) begin
			tx = txQ.pop_front();
			`uvm_do_with(req, {req.wr_rd      == 0;
							   req.addr       == tx.addr;
							   req.burst_len  == tx.burst_len;
							   req.burst_size == tx.burst_size;
							   req.burst_type == tx.burst_type;
							   req.tx_id == tx.tx_id;
                               })
        end
    endtask
endclass
