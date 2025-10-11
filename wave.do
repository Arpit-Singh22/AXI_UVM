onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/pif/aclk
add wave -noupdate /top/pif/arstn
add wave -noupdate -group {Write Address Channel} /top/pif/awvalid
add wave -noupdate -group {Write Address Channel} /top/pif/awready
add wave -noupdate -group {Write Address Channel} /top/pif/awaddr
add wave -noupdate -group {Write Address Channel} /top/pif/awid
add wave -noupdate -group {Write Address Channel} /top/pif/awlen
add wave -noupdate -group {Write Address Channel} /top/pif/awsize
add wave -noupdate -group {Write Address Channel} /top/pif/awburst
add wave -noupdate -group {Write Address Channel} /top/pif/awlock
add wave -noupdate -group {Write Address Channel} /top/pif/awcache
add wave -noupdate -group {Write Address Channel} /top/pif/awprot
add wave -noupdate -group {Write Data Channel} /top/pif/wdata
add wave -noupdate -group {Write Data Channel} /top/pif/wstrb
add wave -noupdate -group {Write Data Channel} /top/pif/wid
add wave -noupdate -group {Write Data Channel} /top/pif/wvalid
add wave -noupdate -group {Write Data Channel} /top/pif/wready
add wave -noupdate -group {Write Data Channel} /top/pif/wlast
add wave -noupdate -group {Write Response Channel} /top/pif/bresp
add wave -noupdate -group {Write Response Channel} /top/pif/bid
add wave -noupdate -group {Write Response Channel} /top/pif/bvalid
add wave -noupdate -group {Write Response Channel} /top/pif/bready
add wave -noupdate -group {Read Address Channel} /top/pif/araddr
add wave -noupdate -group {Read Address Channel} /top/pif/arid
add wave -noupdate -group {Read Address Channel} /top/pif/arsize
add wave -noupdate -group {Read Address Channel} /top/pif/arlen
add wave -noupdate -group {Read Address Channel} /top/pif/arburst
add wave -noupdate -group {Read Address Channel} /top/pif/arprot
add wave -noupdate -group {Read Address Channel} /top/pif/arcache
add wave -noupdate -group {Read Address Channel} /top/pif/arlock
add wave -noupdate -group {Read Address Channel} /top/pif/arvalid
add wave -noupdate -group {Read Address Channel} /top/pif/arready
add wave -noupdate -group {Read Data & Response Channel} /top/pif/rdata
add wave -noupdate -group {Read Data & Response Channel} /top/pif/rid
add wave -noupdate -group {Read Data & Response Channel} /top/pif/rvalid
add wave -noupdate -group {Read Data & Response Channel} /top/pif/rready
add wave -noupdate -group {Read Data & Response Channel} /top/pif/rlast
add wave -noupdate -group {Read Data & Response Channel} /top/pif/rresp
add wave -noupdate /top/axi_assertions_i/WA_HSK_CHECK
add wave -noupdate /top/axi_assertions_i/WR_HSK_CHECK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {948 ns} {1398 ns}
