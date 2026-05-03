onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_apb_uart_rx/clk
add wave -noupdate -radix binary /tb_apb_uart_rx/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -color Khaki -radix binary /tb_apb_uart_rx/serial_in
add wave -noupdate -radix binary /tb_apb_uart_rx/psel
add wave -noupdate /tb_apb_uart_rx/paddr
add wave -noupdate -color Gold -radix binary /tb_apb_uart_rx/penable
add wave -noupdate -radix binary /tb_apb_uart_rx/pwrite
add wave -noupdate /tb_apb_uart_rx/pwdata
add wave -noupdate -divider internals
add wave -noupdate -radix unsigned /tb_apb_uart_rx/DUT/rcv/data_size
add wave -noupdate -radix unsigned /tb_apb_uart_rx/DUT/rcv/bit_period
add wave -noupdate /tb_apb_uart_rx/DUT/rcv/rx_data
add wave -noupdate -color Coral /tb_apb_uart_rx/DUT/rcv/sr/sr_out
add wave -noupdate -radix binary /tb_apb_uart_rx/DUT/rcv/data_read
add wave -noupdate -radix binary /tb_apb_uart_rx/DUT/rcv/shift_strobe_m
add wave -noupdate -radix binary /tb_apb_uart_rx/DUT/rcv/rc_u/packet_done
add wave -noupdate -color Orchid -radix binary /tb_apb_uart_rx/DUT/rcv/data_ready
add wave -noupdate -divider state
add wave -noupdate -radix unsigned /tb_apb_uart_rx/current_transaction_num
add wave -noupdate /tb_apb_uart_rx/DUT/rcv/rc_u/current_state
add wave -noupdate /tb_apb_uart_rx/st
add wave -noupdate -divider outputs
add wave -noupdate -color {Medium Orchid} /tb_apb_uart_rx/prdata
add wave -noupdate -color Cyan -radix binary /tb_apb_uart_rx/psaterr
add wave -noupdate -divider errors
add wave -noupdate -color Yellow -radix binary /tb_apb_uart_rx/DUT/rcv/overrun_error
add wave -noupdate -color Yellow -radix binary /tb_apb_uart_rx/DUT/rcv/framing_error
add wave -noupdate -color Cyan -radix binary /tb_apb_uart_rx/psaterr
add wave -noupdate -divider regs
add wave -noupdate -expand -subitemconfig {{/tb_apb_uart_rx/DUT/apb/current_regs[6]} {-color Turquoise -height 16} {/tb_apb_uart_rx/DUT/apb/current_regs[4]} {-color Gold -height 16} {/tb_apb_uart_rx/DUT/apb/current_regs[3]} {-color Gold -height 16} {/tb_apb_uart_rx/DUT/apb/current_regs[2]} {-color Gold -height 16} {/tb_apb_uart_rx/DUT/apb/current_regs[1]} {-color Turquoise -height 16} {/tb_apb_uart_rx/DUT/apb/current_regs[0]} {-color Turquoise -height 16}} /tb_apb_uart_rx/DUT/apb/current_regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2297492 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 74
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
WaveRestoreZoom {50 ns} {21050 ns}
