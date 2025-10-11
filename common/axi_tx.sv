typedef enum bit [1:0] {
	FIXED = 2'b00,
	INCR = 2'b01,
	WRAP = 2'b10,
	RSVD_BT = 2'b11
} burst_type_t;

class axi_tx extends uvm_sequence_item;
	rand bit [31:0] dataQ[$];
	rand bit [`ADDR_WIDTH-1:0] addr;
	rand bit [7:0] burst_len;
	rand bit [2:0] burst_size;
	rand burst_type_t burst_type;
	//rand bit [1:0] lock_type;
	//rand bit [2:0] prot_type;
	//rand bit [3:0] cache_type;
	rand bit [3:0] tx_id; // no need to declare awid, wid, bid, arid, rid
	rand bit [1:0] respQ[$]; // during read txs, response comes multiple times
	rand bit [3:0] strbQ[$];
	rand bit wr_rd;

	`uvm_object_utils_begin(axi_tx)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_queue_int(dataQ, UVM_ALL_ON)
		`uvm_field_int(burst_len, UVM_ALL_ON)
		`uvm_field_int(burst_size, UVM_ALL_ON)
		`uvm_field_enum(burst_type_t, burst_type, UVM_ALL_ON)
		//`uvm_field_int(lock_type, UVM_ALL_ON)
		//`uvm_field_int(prot_type, UVM_ALL_ON)
		//`uvm_field_int(cache_type, UVM_ALL_ON)
		`uvm_field_int(tx_id, UVM_ALL_ON)
		`uvm_field_queue_int(respQ, UVM_ALL_ON)
		`uvm_field_queue_int(strbQ, UVM_ALL_ON)
		`uvm_field_int(wr_rd, UVM_ALL_ON)
	`uvm_object_utils_end
	`NEW_OBJ

	constraint dataQ_strbQ_c {
		(wr_rd == 1) -> dataQ.size() == burst_len + 1;
		(wr_rd == 0) -> dataQ.size() == 0; // during reads, don't generate any data(slave will provide

		//constraint on strbQ
		(wr_rd == 1) -> (dataQ.size() == burst_len + 1 && strbQ.size() == burst_len + 1);
		(wr_rd == 0) -> (dataQ.size() == 0 && strbQ.size() == 0); 
		
		//(wr_rd == 1) -> strbQ.size() == burst_len + 1;
		//(wr_rd == 0) -> strbQ.size() == 0; 

        foreach (strbQ[i]) {
            soft strbQ[i] == 4'hf;
        }
	}
	
	constraint wrap_c {
		burst_type == INCR -> burst_len inside {[0:15]};
		burst_type == WRAP -> burst_len inside {1,3,7,15};
		burst_type == WRAP -> addr % (2**burst_size) == 0; //wrap tx must be aligned
	}

	constraint burst_type_c {
		burst_type != RSVD_BT;
		//lock_type != RSVD_LOCK;
		soft burst_size == 2;
		soft burst_type == 2'b01; //INCR
	}
endclass
