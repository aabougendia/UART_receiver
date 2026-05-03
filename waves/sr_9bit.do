onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_sr_9bit/CLK_PERIOD
add wave -noupdate /tb_sr_9bit/BIT_TIME
add wave -noupdate -radix binary /tb_sr_9bit/clk
add wave -noupdate -radix binary /tb_sr_9bit/n_rst
add wave -noupdate -radix binary /tb_sr_9bit/shift_strobe
add wave -noupdate -radix binary /tb_sr_9bit/serial_in
add wave -noupdate /tb_sr_9bit/packet_data
add wave -noupdate -radix binary /tb_sr_9bit/stop_bit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1 ns}
