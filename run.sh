#compilation and elaboration
vcs -sverilog -full64 -debug_access+all -kdb \
		+incdir+../top \
		+incdir+../master\
		+incdir+../slave \
		+incdir+../common \
		+incdir+../src \
		+incdir+UVM_NO_DPI \
		../top/list.svh 
#simulation
./simv -l sim.log +ntb_random_seed=21545
