`define NEW_OBJ	\
function new(string name="axi_tx");	\
	super.new(name);	\
	endfunction

`define NEW_COMP	\
function new(string name="axi_tx", uvm_component parent);	\
	super.new(name, parent);	\
	endfunction

`define WIDTH 32
`define DEPTH 32
`define ADDR_WIDTH 32 
`define DATA_WIDTH 32
`define ID_WIDTH 4
`define STRB_WIDTH `DATA_WIDTH/8
//`define AGENT_TYPE `

`define GET_INTF \
	uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif)

int count=1;
int num_matches;
int num_mismatches;
int exp_byte_count;

`define AXI_TEST(TEST, SEQ) \
class TEST extends axi_base_test;\
	`uvm_component_utils(TEST)\
	`NEW_COMP\
            \
	task run_phase(uvm_phase phase);\
		SEQ seq = new($sformatf(SEQ));\
		super.run_phase(phase);\
		phase.raise_objection(this);\
		seq.start(env.magent.sqr);\
		phase.phase_done.set_drain_time(this,50);\
		phase.drop_objection(this);\
	endtask\
endclass

