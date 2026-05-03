onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color White -radix binary /tb_rcu/clk
add wave -noupdate -color White -radix binary /tb_rcu/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -radix binary /tb_rcu/new_packet_detected
add wave -noupdate -radix binary /tb_rcu/packet_done
add wave -noupdate -radix binary /tb_rcu/framing_error
add wave -noupdate -divider {sys. state}
add wave -noupdate /tb_rcu/DUT/current_state
add wave -noupdate -divider outputs
add wave -noupdate -color {Cornflower Blue} -radix binary /tb_rcu/sbc_clear
add wave -noupdate -color {Cornflower Blue} -radix binary /tb_rcu/sbc_enable
add wave -noupdate -color {Cornflower Blue} -radix binary /tb_rcu/load_buffer
add wave -noupdate -color {Cornflower Blue} -radix binary /tb_rcu/enable_timer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {8038 ps} 0}
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
WaveRestoreZoom {0 ps} {102375 ps}
