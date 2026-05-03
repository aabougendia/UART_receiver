onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_apb_subordinate/clk
add wave -noupdate -radix binary /tb_apb_subordinate/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -color Orange /tb_apb_subordinate/rx_data
add wave -noupdate -color Orange -radix binary /tb_apb_subordinate/data_ready
add wave -noupdate -color Orange -radix binary /tb_apb_subordinate/overrun_error
add wave -noupdate -color Orange -radix binary /tb_apb_subordinate/framing_error
add wave -noupdate -color Orange -radix binary /tb_apb_subordinate/psel
add wave -noupdate -color Orange /tb_apb_subordinate/paddr
add wave -noupdate -color Orange -radix binary /tb_apb_subordinate/penable
add wave -noupdate -color Orange -radix binary /tb_apb_subordinate/pwrite
add wave -noupdate -color Orange /tb_apb_subordinate/pwdata
add wave -noupdate -divider status
add wave -noupdate /tb_apb_subordinate/status
add wave -noupdate -divider internals
add wave -noupdate -radix binary /tb_apb_subordinate/enqueue_transaction_en
add wave -noupdate -radix binary /tb_apb_subordinate/transaction_write
add wave -noupdate -radix binary /tb_apb_subordinate/transaction_fake
add wave -noupdate /tb_apb_subordinate/transaction_addr
add wave -noupdate /tb_apb_subordinate/transaction_data
add wave -noupdate -radix binary /tb_apb_subordinate/transaction_error
add wave -noupdate -radix binary /tb_apb_subordinate/model_reset
add wave -noupdate -radix binary /tb_apb_subordinate/enable_transactions
add wave -noupdate -radix unsigned /tb_apb_subordinate/current_transaction_num
add wave -noupdate -divider outputs
add wave -noupdate -color Cyan -radix binary /tb_apb_subordinate/data_read
add wave -noupdate -color Cyan /tb_apb_subordinate/bit_period
add wave -noupdate -color Cyan /tb_apb_subordinate/data_size
add wave -noupdate -color Cyan /tb_apb_subordinate/prdata
add wave -noupdate -color Cyan -radix binary /tb_apb_subordinate/psaterr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {181957 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 153
configure wave -valuecolwidth 39
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
WaveRestoreZoom {121502 ps} {243896 ps}
