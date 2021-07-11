vlib work
vcom -2008 ../../rtl/flow_in_hs.vhd
vcom -2008 ../../rtl/flow_in.vhd
vcom -2008 ../../rtl/flow_out_hs.vhd
vcom -2008 ../../rtl/flow_out.vhd
vcom -2008 ../../rtl/routing_xy.vhd
vcom -2008 ../../rtl/routing.vhd
vcom -2008 ../../rtl/arbitration_rr.vhd
vcom -2008 ../../rtl/arbitration.vhd
vcom -2008 ../../rtl/buffering_fifo.vhd
vcom -2008 ../../rtl/buffering.vhd
vcom -2008 ../../rtl/switch.vhd
vcom -2008 ../../rtl/channel_in.vhd
vcom -2008 ../../rtl/channel_out.vhd
vcom -2008 ../../rtl/crossbar.vhd
vcom -2008 ../../rtl/router.vhd
vcom -2008 ../../rtl/xina.vhd
vcom -2008 ../../tb/xina_tb.vhd
vsim xina_tb
add wave *
run 10 us