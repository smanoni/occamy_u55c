# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Nils Wistoff <nwistoff@iis.ee.ethz.ch>

# Not used anymore
#set_property PACKAGE_PIN BJ51 [get_ports clk_100MHz_n]
#set_property IOSTANDARD DIFF_SSTL12 [get_ports clk_100MHz_n]
#set_property PACKAGE_PIN BH51 [get_ports clk_100MHz_p]
#set_property IOSTANDARD DIFF_SSTL12 [get_ports clk_100MHz_p]

#set_property PACKAGE_PIN BP26 [get_ports uart_rx_i_0]
#set_property IOSTANDARD LVCMOS18 [get_ports uart_rx_i_0]
#set_property PACKAGE_PIN BN26 [get_ports uart_tx_o_0]
#set_property IOSTANDARD LVCMOS18 [get_ports uart_tx_o_0]
set_property PACKAGE_PIN BJ41 [get_ports uart_rx_i_0]
set_property IOSTANDARD LVCMOS18 [get_ports uart_rx_i_0]
set_property PACKAGE_PIN BH41 [get_ports uart_tx_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports uart_tx_o_0]

# CPU_RESET pushbutton switch
set_false_path -from [get_ports reset] -to [all_registers]
#set_property PACKAGE_PIN BM29      [get_ports reset]
#set_property IOSTANDARD  LVCMOS12  [get_ports reset]
set_property PACKAGE_PIN BG45 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports reset]
#set_property PACKAGE_PIN BG45     [get_ports resetn_0]
#set_property IOSTANDARD  LVCMOS18 [get_ports resetn_0]
#set_property PACKAGE_PIN BG45     [get_ports resetn]
#set_property IOSTANDARD  LVCMOS18 [get_ports resetn]

#PCIE set property
set_property PACKAGE_PIN BF41 [get_ports pcie_perstn]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_perstn]
set_property PACKAGE_PIN AR14 [get_ports pcie_refclk_clk_n]
set_property PACKAGE_PIN AR15 [get_ports pcie_refclk_clk_p]


#I2C setup
set_property PACKAGE_PIN BM14 [get_ports IIC_0_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports IIC_0_scl_io]
set_property PACKAGE_PIN BN14 [get_ports IIC_0_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports IIC_0_sda_io]


set_property IOSTANDARD LVDS [get_ports slr0_freerun_clk_clk_n]
set_property PACKAGE_PIN F24 [get_ports slr0_freerun_clk_clk_p]
set_property PACKAGE_PIN F23 [get_ports slr0_freerun_clk_clk_n]
set_property IOSTANDARD LVDS [get_ports slr0_freerun_clk_clk_p]


# Set RTC as false path
set_false_path -to [get_pins {occamy_u55c_i/occamy/inst/i_occamy/i_clint/i_sync_edge/i_sync/reg_q_reg[0]/D}]

################################################################################
# JTAG
################################################################################

# CDC 2phase clearable of DM: i_cdc_resp/i_cdc_req
# CONSTRAINT: Requires max_delay of min_period(src_clk_i, dst_clk_i) through the paths async_req, async_ack, async_data.
set_max_delay -through [get_nets -hier -filter {NAME =~ "*i_cdc_resp/async_req*"}] 10.000
set_max_delay -through [get_nets -hier -filter {NAME =~ "*i_cdc_resp/async_ack*"}] 10.000
set_max_delay -through [get_nets -hier -filter {NAME =~ "*i_cdc_resp/async_data*"}] 10.000
set_max_delay -through [get_nets -hier -filter {NAME =~ "*i_cdc_req/async_req*"}] 10.000
set_max_delay -through [get_nets -hier -filter {NAME =~ "*i_cdc_req/async_ack*"}] 10.000
set_max_delay -through [get_nets -hier -filter {NAME =~ "*i_cdc_req/async_data*"}] 10.000

################################################################################
# TIMING GROUPS
################################################################################

# Create timing groups through the FPU to help meet timing

# ingress and egress same for all pipe configs
group_path -name {sdotp_ingress} -weight 1.000 -through [get_pins -of [get_cells -hierarchical -filter {ORIG_REF_NAME == fpnew_sdotp_multi || REF_NAME == fpnew_sdotp_multi}] -filter { DIRECTION == "IN" && NAME !~ *out_ready_i && NAME !~ *rst_ni && NAME !~ *clk_i}]
group_path -name {fma_ingress} -weight 1.000 -through [get_pins -of [get_cells -hierarchical -filter {ORIG_REF_NAME == fpnew_fma_multi || REF_NAME == fpnew_fma_multi}] -filter { DIRECTION == "IN" && NAME !~ *out_ready_i && NAME !~ *rst_ni && NAME !~ *clk_i}]
group_path -name {sdotp_egress} -weight 1.000 -through [get_pins -of [get_cells -hierarchical -filter {ORIG_REF_NAME == fpnew_sdotp_multi || REF_NAME == fpnew_sdotp_multi}] -filter { DIRECTION == "OUT" && NAME !~ *in_ready_o}]
group_path -name {fma_egress} -weight 1.000 -through [get_pins -of [get_cells -hierarchical -filter {ORIG_REF_NAME == fpnew_fma_multi || REF_NAME == fpnew_fma_multi}] -filter { DIRECTION == "OUT" && NAME !~ *in_ready_o}]

# For 2 DISTRIBUTED pipe registers, registers are placed on input and mid
# The inside path therefore goes through the registers created in `gen_inside_pipeline[0]`

# The inside path groups

set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#create_clock -name TCK -period 40 -waveform {0 20} [get_pins occamy_u55c_i/occamy/inst/i_occamy/i_dmi_jtag/i_dmi_jtag_tap/i_tap_dtmcs/INTERNAL_TCK]
#create_generated_clock -name  -period 10 -waveform {0 5} [get_pins occamy_u55c_i/occamy/inst/i_occamy/i_dmi_jtag/i_dmi_jtag_tap/i_tap_dtmcs/INTERNAL_TCK]

