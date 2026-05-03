onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_rcv_block/clk
add wave -noupdate -radix binary /tb_rcv_block/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -radix binary /tb_rcv_block/serial_in
add wave -noupdate -radix binary /tb_rcv_block/data_read
add wave -noupdate /tb_rcv_block/rx_data
add wave -noupdate -divider internals
add wave -noupdate /tb_rcv_block/DUT/sr/data_size
add wave -noupdate /tb_rcv_block/DUT/tim/shift_strobe
add wave -noupdate /tb_rcv_block/DUT/tim/packet_done
add wave -noupdate -radix binary /tb_rcv_block/DUT/sr/sr_out
add wave -noupdate -radix hexadecimal /tb_rcv_block/DUT/sr/packet_data
add wave -noupdate /tb_rcv_block/DUT/sr/stop_bit
add wave -noupdate -divider outputs
add wave -noupdate -radix binary /tb_rcv_block/data_ready
add wave -noupdate -radix binary /tb_rcv_block/overrun_error
add wave -noupdate -radix binary /tb_rcv_block/framing_error
add wave -noupdate /tb_rcv_block/DUT/sr/packet_data
add wave -noupdate -divider state
add wave -noupdate /tb_rcv_block/DUT/rc_u/current_state
add wave -noupdate /tb_rcv_block/test_case
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1274299 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {309238 ps} {695799 ps}
