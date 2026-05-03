onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_timer/CLK_PERIOD
add wave -noupdate /tb_timer/BIT_TIME
add wave -noupdate -radix binary /tb_timer/clk
add wave -noupdate -radix binary /tb_timer/n_rst
add wave -noupdate -radix binary /tb_timer/enable_timer
add wave -noupdate -radix binary /tb_timer/shift_strobe
add wave -noupdate -radix binary /tb_timer/packet_done
add wave -noupdate -radix decimal /tb_timer/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36250 ps} 0}
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
WaveRestoreZoom {32129 ps} {279888 ps}
