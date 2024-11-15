
################################################################
# This is a generated script based on design: occamy_u55c
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source occamy_u55c_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu55c-fsvh2892-2L-e
   set_property BOARD_PART xilinx.com:au55c:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name occamy_u55c

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_apb_bridge:3.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_iic:2.1\
xilinx.com:ip:axi_protocol_checker:2.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:hbm:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:jtag_axi:1.2\
ethz.ch:user:occamy_xilinx:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set IIC_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0 ]

  set pci_express_x4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express_x4 ]

  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $pcie_refclk

  set qsfp0_4x [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 qsfp0_4x ]

  set qsfp0_refclk0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 qsfp0_refclk0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {161132812} \
   ] $qsfp0_refclk0

  set slr0_freerun_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 slr0_freerun_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $slr0_freerun_clk


  # Create ports
  set pcie_perstn [ create_bd_port -dir I -type rst pcie_perstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $pcie_perstn
  set uart_rx_i_0 [ create_bd_port -dir I uart_rx_i_0 ]
  set uart_tx_o_0 [ create_bd_port -dir O uart_tx_o_0 ]

  # Create instance: axi_apb_bridge_0, and set properties
  set axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 axi_apb_bridge_0 ]
  set_property -dict [ list \
   CONFIG.C_APB_NUM_SLAVES {2} \
 ] $axi_apb_bridge_0

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_addr_width {64} \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_burst_size {16} \
   CONFIG.c_s2mm_burst_size {16} \
   CONFIG.c_s_axis_s2mm_tdata_width {64} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {16} \
   CONFIG.c_sg_use_stsapp_length {0} \
 ] $axi_dma_0

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0 ]
  set_property -dict [ list \
   CONFIG.IIC_BOARD_INTERFACE {Custom} \
 ] $axi_iic_0

  # Create instance: axi_protocol_checker_0, and set properties
  set axi_protocol_checker_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_checker:2.0 axi_protocol_checker_0 ]

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_FIFO_DEPTH {16} \
   CONFIG.C_SCK_RATIO {2} \
   CONFIG.C_SPI_MEMORY {2} \
   CONFIG.C_SPI_MODE {2} \
   CONFIG.C_TYPE_OF_AXI4_INTERFACE {1} \
   CONFIG.C_USE_STARTUP {1} \
   CONFIG.C_USE_STARTUP_INT {1} \
   CONFIG.FIFO_INCLUDED {1} \
   CONFIG.Master_mode {1} \
 ] $axi_quad_spi_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {false} \
   CONFIG.Byte_Size {8} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_32bit_Address {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_A_Write_Rate {50} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Read_Width_A {32} \
   CONFIG.Read_Width_B {32} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {true} \
   CONFIG.Use_RSTA_Pin {true} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.Write_Width_A {32} \
   CONFIG.Write_Width_B {32} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $blk_mem_gen_0

  # Create instance: c_high, and set properties
  set c_high [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 c_high ]

  # Create instance: c_low, and set properties
  set c_low [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 c_low ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $c_low

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [ list \
   CONFIG.AXI_DRP {false} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {115.831} \
   CONFIG.CLKOUT1_PHASE_ERROR {87.180} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_JITTER {183.467} \
   CONFIG.CLKOUT2_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {180.712} \
   CONFIG.CLKOUT3_PHASE_ERROR {87.180} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {12.5} \
   CONFIG.CLKOUT3_REQUESTED_PHASE {0} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {Buffer} \
   CONFIG.CLKOUT4_JITTER {112.035} \
   CONFIG.CLKOUT4_PHASE_ERROR {87.180} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {120} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {slr0_freerun_clk} \
   CONFIG.CLK_OUT1_PORT {clk_100_bufg} \
   CONFIG.CLK_OUT2_PORT {clk_core} \
   CONFIG.CLK_OUT3_PORT {clk_rtc} \
   CONFIG.CLK_OUT4_PORT {clk_hbm} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {12.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {48} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {96} \
   CONFIG.MMCM_CLKOUT2_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {10} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {4} \
   CONFIG.PHASE_DUTY_CONFIG {false} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_DYN_RECONFIG {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz

  # Create instance: concat_irq, and set properties
  set concat_irq [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_irq ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {12} \
 ] $concat_irq

  # Create instance: concat_rst, and set properties
  set concat_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_rst ]

  # Create instance: concat_rst_core, and set properties
  set concat_rst_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_rst_core ]

  # Create instance: hbm_0, and set properties
  set hbm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:hbm:1.0 hbm_0 ]
  set_property -dict [ list \
   CONFIG.USER_APB_PCLK_0 {50} \
   CONFIG.USER_APB_PCLK_1 {50} \
   CONFIG.USER_APB_PCLK_PERIOD_0 {20.0} \
   CONFIG.USER_APB_PCLK_PERIOD_1 {20.0} \
   CONFIG.USER_AXI_ADDR_SIZE {32} \
   CONFIG.USER_CLK_SEL_LIST0 {AXI_00_ACLK} \
   CONFIG.USER_CLK_SEL_LIST1 {AXI_16_ACLK} \
   CONFIG.USER_HBM_CP_1 {6} \
   CONFIG.USER_HBM_DENSITY {8GB} \
   CONFIG.USER_HBM_FBDIV_1 {36} \
   CONFIG.USER_HBM_HEX_CP_RES_1 {0x0000A600} \
   CONFIG.USER_HBM_HEX_FBDIV_CLKOUTDIV_1 {0x00000902} \
   CONFIG.USER_HBM_HEX_LOCK_FB_REF_DLY_1 {0x00001f1f} \
   CONFIG.USER_HBM_LOCK_FB_DLY_1 {31} \
   CONFIG.USER_HBM_LOCK_REF_DLY_1 {31} \
   CONFIG.USER_HBM_RES_1 {10} \
   CONFIG.USER_HBM_STACK {2} \
   CONFIG.USER_MC0_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC0_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC0_EN_DATA_MASK {false} \
   CONFIG.USER_MC0_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC0_REF_TEMP_COMP {false} \
   CONFIG.USER_MC10_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC10_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC10_EN_DATA_MASK {false} \
   CONFIG.USER_MC10_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC10_REF_TEMP_COMP {false} \
   CONFIG.USER_MC11_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC11_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC11_EN_DATA_MASK {false} \
   CONFIG.USER_MC11_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC11_REF_TEMP_COMP {false} \
   CONFIG.USER_MC12_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC12_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC12_EN_DATA_MASK {false} \
   CONFIG.USER_MC12_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC12_REF_TEMP_COMP {false} \
   CONFIG.USER_MC13_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC13_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC13_EN_DATA_MASK {false} \
   CONFIG.USER_MC13_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC13_REF_TEMP_COMP {false} \
   CONFIG.USER_MC14_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC14_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC14_EN_DATA_MASK {false} \
   CONFIG.USER_MC14_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC14_REF_TEMP_COMP {false} \
   CONFIG.USER_MC15_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC15_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC15_EN_DATA_MASK {false} \
   CONFIG.USER_MC15_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC15_REF_TEMP_COMP {false} \
   CONFIG.USER_MC1_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC1_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC1_EN_DATA_MASK {false} \
   CONFIG.USER_MC1_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC1_REF_TEMP_COMP {false} \
   CONFIG.USER_MC2_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC2_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC2_EN_DATA_MASK {false} \
   CONFIG.USER_MC2_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC2_REF_TEMP_COMP {false} \
   CONFIG.USER_MC3_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC3_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC3_EN_DATA_MASK {false} \
   CONFIG.USER_MC3_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC3_REF_TEMP_COMP {false} \
   CONFIG.USER_MC4_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC4_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC4_EN_DATA_MASK {false} \
   CONFIG.USER_MC4_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC4_REF_TEMP_COMP {false} \
   CONFIG.USER_MC5_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC5_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC5_EN_DATA_MASK {false} \
   CONFIG.USER_MC5_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC5_REF_TEMP_COMP {false} \
   CONFIG.USER_MC6_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC6_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC6_EN_DATA_MASK {false} \
   CONFIG.USER_MC6_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC6_REF_TEMP_COMP {false} \
   CONFIG.USER_MC7_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC7_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC7_EN_DATA_MASK {false} \
   CONFIG.USER_MC7_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC7_REF_TEMP_COMP {false} \
   CONFIG.USER_MC8_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC8_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC8_EN_DATA_MASK {false} \
   CONFIG.USER_MC8_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC8_REF_TEMP_COMP {false} \
   CONFIG.USER_MC9_CA0_CA5_MAP {0x1c61440c0} \
   CONFIG.USER_MC9_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC9_EN_DATA_MASK {false} \
   CONFIG.USER_MC9_LADDR_CA0_CA4_MAP {0xc61440c0} \
   CONFIG.USER_MC9_REF_TEMP_COMP {false} \
   CONFIG.USER_MC_ENABLE_08 {TRUE} \
   CONFIG.USER_MC_ENABLE_09 {TRUE} \
   CONFIG.USER_MC_ENABLE_10 {TRUE} \
   CONFIG.USER_MC_ENABLE_11 {TRUE} \
   CONFIG.USER_MC_ENABLE_12 {TRUE} \
   CONFIG.USER_MC_ENABLE_13 {TRUE} \
   CONFIG.USER_MC_ENABLE_14 {TRUE} \
   CONFIG.USER_MC_ENABLE_15 {TRUE} \
   CONFIG.USER_MC_ENABLE_APB_01 {TRUE} \
   CONFIG.USER_MEMORY_DISPLAY {8192} \
   CONFIG.USER_PHY_ENABLE_08 {TRUE} \
   CONFIG.USER_PHY_ENABLE_09 {TRUE} \
   CONFIG.USER_PHY_ENABLE_10 {TRUE} \
   CONFIG.USER_PHY_ENABLE_11 {TRUE} \
   CONFIG.USER_PHY_ENABLE_12 {TRUE} \
   CONFIG.USER_PHY_ENABLE_13 {TRUE} \
   CONFIG.USER_PHY_ENABLE_14 {TRUE} \
   CONFIG.USER_PHY_ENABLE_15 {TRUE} \
   CONFIG.USER_SAXI_01 {true} \
   CONFIG.USER_SAXI_02 {false} \
   CONFIG.USER_SAXI_03 {false} \
   CONFIG.USER_SAXI_04 {true} \
   CONFIG.USER_SAXI_05 {true} \
   CONFIG.USER_SAXI_06 {false} \
   CONFIG.USER_SAXI_07 {false} \
   CONFIG.USER_SAXI_08 {true} \
   CONFIG.USER_SAXI_09 {false} \
   CONFIG.USER_SAXI_10 {false} \
   CONFIG.USER_SAXI_11 {false} \
   CONFIG.USER_SAXI_12 {true} \
   CONFIG.USER_SAXI_13 {false} \
   CONFIG.USER_SAXI_14 {false} \
   CONFIG.USER_SAXI_15 {false} \
   CONFIG.USER_SAXI_17 {false} \
   CONFIG.USER_SAXI_18 {false} \
   CONFIG.USER_SAXI_19 {false} \
   CONFIG.USER_SAXI_20 {true} \
   CONFIG.USER_SAXI_21 {false} \
   CONFIG.USER_SAXI_22 {false} \
   CONFIG.USER_SAXI_23 {false} \
   CONFIG.USER_SAXI_24 {true} \
   CONFIG.USER_SAXI_25 {false} \
   CONFIG.USER_SAXI_26 {false} \
   CONFIG.USER_SAXI_27 {false} \
   CONFIG.USER_SAXI_28 {true} \
   CONFIG.USER_SAXI_29 {false} \
   CONFIG.USER_SAXI_30 {false} \
   CONFIG.USER_SAXI_31 {false} \
   CONFIG.USER_STACK_8HI {false} \
   CONFIG.USER_SWITCH_ENABLE_01 {TRUE} \
   CONFIG.USER_TEMP_POLL_CNT_0 {50000} \
   CONFIG.USER_TEMP_POLL_CNT_1 {50000} \
   CONFIG.USER_tRFC_0 {0x0EA} \
   CONFIG.USER_tRFC_1 {0x0EA} \
 ] $hbm_0

  # Create instance: ila_25, and set properties
  set ila_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 ila_25 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {4096} \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_NUM_OF_PROBES {3} \
   CONFIG.C_PROBE0_TYPE {0} \
   CONFIG.C_PROBE1_TYPE {0} \
   CONFIG.C_PROBE2_TYPE {0} \
   CONFIG.C_PROBE3_TYPE {0} \
   CONFIG.C_PROBE4_TYPE {0} \
   CONFIG.C_PROBE5_TYPE {0} \
   CONFIG.C_PROBE6_TYPE {0} \
   CONFIG.C_SLOT_0_APC_EN {0} \
   CONFIG.C_SLOT_0_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.C_SLOT_1_APC_EN {0} \
   CONFIG.C_SLOT_1_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.C_SLOT_2_APC_EN {0} \
   CONFIG.C_SLOT_2_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_2_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_3_APC_EN {0} \
   CONFIG.C_SLOT_3_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_3_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_4_APC_EN {0} \
   CONFIG.C_SLOT_4_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_4_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_5_APC_EN {0} \
   CONFIG.C_SLOT_5_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_5_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $ila_25

  # Create instance: ila_axi_checker, and set properties
  set ila_axi_checker [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_axi_checker ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {2} \
   CONFIG.C_PROBE0_WIDTH {160} \
 ] $ila_axi_checker

  # Create instance: ila_occamy2smc2hbm, and set properties
  set ila_occamy2smc2hbm [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_occamy2smc2hbm ]

  # Create instance: ila_occamy2smc2pcie, and set properties
  set ila_occamy2smc2pcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_occamy2smc2pcie ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {8192} \
 ] $ila_occamy2smc2pcie

  # Create instance: ila_smc2hbm, and set properties
  set ila_smc2hbm [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_smc2hbm ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {8192} \
 ] $ila_smc2hbm

  # Create instance: ila_smc2occamy, and set properties
  set ila_smc2occamy [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_smc2occamy ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {8192} \
 ] $ila_smc2occamy

  # Create instance: ila_xdma2smc, and set properties
  set ila_xdma2smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_xdma2smc ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {8192} \
 ] $ila_xdma2smc

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: occamy, and set properties
  set occamy [ create_bd_cell -type ip -vlnv ethz.ch:user:occamy_xilinx:1.0 occamy ]

  # Create instance: psr_25, and set properties
  set psr_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 psr_25 ]

  # Create instance: psr_100, and set properties
  set psr_100 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 psr_100 ]

  # Create instance: psr_hbm, and set properties
  set psr_hbm [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 psr_hbm ]

  # Create instance: rst_or, and set properties
  set rst_or [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 rst_or ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {2} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $rst_or

  # Create instance: rst_or_core, and set properties
  set rst_or_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 rst_or_core ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {2} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $rst_or_core

  # Create instance: smc_hbm_0, and set properties
  set smc_hbm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_0 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_0

  # Create instance: smc_hbm_1, and set properties
  set smc_hbm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_1 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_1

  # Create instance: smc_hbm_2, and set properties
  set smc_hbm_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_2 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_2

  # Create instance: smc_hbm_3, and set properties
  set smc_hbm_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_3 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_3

  # Create instance: smc_hbm_4, and set properties
  set smc_hbm_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_4 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_4

  # Create instance: smc_hbm_5, and set properties
  set smc_hbm_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_5 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_5

  # Create instance: smc_hbm_6, and set properties
  set smc_hbm_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_6 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_6

  # Create instance: smc_hbm_7, and set properties
  set smc_hbm_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_hbm_7 ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {  __view__ { } } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smc_hbm_7

  # Create instance: smc_pcie, and set properties
  set smc_pcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_pcie ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {5} \
   CONFIG.NUM_SI {1} \
 ] $smc_pcie

  # Create instance: smc_spcie, and set properties
  set smc_spcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smc_spcie ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {\
     __view__ {clocking { M01_Exit { ASSOCIATED_CLK aclk1 } S03_Entry { ASSOCIATED_CLK\
aclk } }}\
   } \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {5} \
 ] $smc_spcie

  # Create instance: util_ds_buf, and set properties
  set util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
   CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {pcie_refclk} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $util_ds_buf

  # Create instance: util_vector_logic, and set properties
  set util_vector_logic [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: vio_sys, and set properties
  set vio_sys [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_sys ]
  set_property -dict [ list \
   CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
   CONFIG.C_NUM_PROBE_IN {0} \
   CONFIG.C_NUM_PROBE_OUT {4} \
   CONFIG.C_PROBE_OUT1_WIDTH {1} \
   CONFIG.C_PROBE_OUT2_WIDTH {2} \
   CONFIG.C_PROBE_OUT3_INIT_VAL {0x03} \
   CONFIG.C_PROBE_OUT3_WIDTH {6} \
 ] $vio_sys

  # Create instance: xdma_1, and set properties
  set xdma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_1 ]
  set_property -dict [ list \
   CONFIG.BASEADDR {0x00001000} \
   CONFIG.HIGHADDR {0x00001FFF} \
   CONFIG.PCIE_BOARD_INTERFACE {pci_express_x4} \
   CONFIG.PF0_DEVICE_ID_mqdma {9014} \
   CONFIG.PF0_SRIOV_VF_DEVICE_ID {A034} \
   CONFIG.PF1_SRIOV_VF_DEVICE_ID {A134} \
   CONFIG.PF2_DEVICE_ID_mqdma {9214} \
   CONFIG.PF2_SRIOV_VF_DEVICE_ID {A234} \
   CONFIG.PF3_DEVICE_ID_mqdma {9314} \
   CONFIG.PF3_SRIOV_VF_DEVICE_ID {A334} \
   CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perstn} \
   CONFIG.axi_addr_width {64} \
   CONFIG.axi_bypass_64bit_en {true} \
   CONFIG.axi_bypass_prefetchable {true} \
   CONFIG.axibar_num {1} \
   CONFIG.axil_master_64bit_en {false} \
   CONFIG.axilite_master_en {true} \
   CONFIG.axist_bypass_en {true} \
   CONFIG.axist_bypass_scale {Gigabytes} \
   CONFIG.axist_bypass_size {4} \
   CONFIG.axisten_freq {125} \
   CONFIG.bar_indicator {BAR_1:0} \
   CONFIG.bridge_burst {true} \
   CONFIG.en_bridge_slv {true} \
   CONFIG.functional_mode {AXI_Bridge} \
   CONFIG.mode_selection {Advanced} \
   CONFIG.pcie_blk_locn {PCIE4C_X1Y1} \
   CONFIG.pf0_bar0_64bit {true} \
   CONFIG.pf0_bar0_prefetchable {true} \
   CONFIG.pf0_bar0_scale {Gigabytes} \
   CONFIG.pf0_bar0_size {4} \
   CONFIG.pf0_bar2_enabled {false} \
   CONFIG.pf0_device_id {9014} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_1:0} \
   CONFIG.pf0_msix_cap_table_bir {BAR_1:0} \
   CONFIG.pl_link_cap_max_link_width {X4} \
   CONFIG.vdm_en {true} \
   CONFIG.xdma_axi_intf_mm {AXI_Memory_Mapped} \
   CONFIG.xdma_axilite_slave {true} \
   CONFIG.xdma_sts_ports {false} \
 ] $xdma_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_0

  # Create instance: xxv_ethernet_0_dclkwiz, and set properties
  set xxv_ethernet_0_dclkwiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 xxv_ethernet_0_dclkwiz ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_RESET {true} \
 ] $xxv_ethernet_0_dclkwiz

  # Create interface connections
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_pins axi_apb_bridge_0/APB_M] [get_bd_intf_pins hbm_0/SAPB_0]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M2 [get_bd_intf_pins axi_apb_bridge_0/APB_M2] [get_bd_intf_pins hbm_0/SAPB_1]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins smc_spcie/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins smc_spcie/S02_AXI]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports IIC_0] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_0 [get_bd_intf_pins occamy/m_axi_hbm_0] [get_bd_intf_pins smc_hbm_0/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_1 [get_bd_intf_pins occamy/m_axi_hbm_1] [get_bd_intf_pins smc_hbm_1/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets occamy_m_axi_hbm_1] [get_bd_intf_pins ila_occamy2smc2hbm/SLOT_0_AXI] [get_bd_intf_pins smc_hbm_1/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_2 [get_bd_intf_pins occamy/m_axi_hbm_2] [get_bd_intf_pins smc_hbm_2/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_3 [get_bd_intf_pins occamy/m_axi_hbm_3] [get_bd_intf_pins smc_hbm_3/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_4 [get_bd_intf_pins occamy/m_axi_hbm_4] [get_bd_intf_pins smc_hbm_4/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_5 [get_bd_intf_pins occamy/m_axi_hbm_5] [get_bd_intf_pins smc_hbm_5/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_6 [get_bd_intf_pins occamy/m_axi_hbm_6] [get_bd_intf_pins smc_hbm_6/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_hbm_7 [get_bd_intf_pins occamy/m_axi_hbm_7] [get_bd_intf_pins smc_hbm_7/S00_AXI]
  connect_bd_intf_net -intf_net occamy_m_axi_pcie [get_bd_intf_pins occamy/m_axi_pcie] [get_bd_intf_pins smc_pcie/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets occamy_m_axi_pcie] [get_bd_intf_pins ila_occamy2smc2pcie/SLOT_0_AXI] [get_bd_intf_pins smc_pcie/S00_AXI]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins util_ds_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net rom_porta [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net slr0_freerun_clk_1 [get_bd_intf_ports slr0_freerun_clk] [get_bd_intf_pins clk_wiz/CLK_IN1_D]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_apb_bridge_0/AXI4_LITE] [get_bd_intf_pins smc_pcie/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_quad_spi_0/AXI_FULL] [get_bd_intf_pins smc_pcie/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins smc_pcie/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_9_M00_AXI [get_bd_intf_pins occamy/s_axi_pcie] [get_bd_intf_pins smc_spcie/M00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets smartconnect_9_M00_AXI] [get_bd_intf_pins ila_smc2occamy/SLOT_0_AXI] [get_bd_intf_pins smc_spcie/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_0_M00_AXI [get_bd_intf_pins hbm_0/SAXI_00] [get_bd_intf_pins smc_hbm_0/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_0_M01_AXI [get_bd_intf_pins hbm_0/SAXI_01] [get_bd_intf_pins smc_hbm_0/M01_AXI]
  connect_bd_intf_net -intf_net smc_hbm_1_M00_AXI [get_bd_intf_pins hbm_0/SAXI_04] [get_bd_intf_pins smc_hbm_1/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_1_M01_AXI [get_bd_intf_pins hbm_0/SAXI_05] [get_bd_intf_pins smc_hbm_1/M01_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets smc_hbm_1_M01_AXI] [get_bd_intf_pins ila_smc2hbm/SLOT_0_AXI] [get_bd_intf_pins smc_hbm_1/M01_AXI]
  connect_bd_intf_net -intf_net smc_hbm_2_M00_AXI [get_bd_intf_pins hbm_0/SAXI_08] [get_bd_intf_pins smc_hbm_2/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_3_M00_AXI [get_bd_intf_pins hbm_0/SAXI_12] [get_bd_intf_pins smc_hbm_3/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_4_M00_AXI [get_bd_intf_pins hbm_0/SAXI_16] [get_bd_intf_pins smc_hbm_4/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_5_M00_AXI [get_bd_intf_pins hbm_0/SAXI_20] [get_bd_intf_pins smc_hbm_5/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_6_M00_AXI [get_bd_intf_pins hbm_0/SAXI_24] [get_bd_intf_pins smc_hbm_6/M00_AXI]
  connect_bd_intf_net -intf_net smc_hbm_7_M00_AXI [get_bd_intf_pins hbm_0/SAXI_28] [get_bd_intf_pins smc_hbm_7/M00_AXI]
  connect_bd_intf_net -intf_net smc_pcie_M05_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins smc_pcie/M00_AXI]
  connect_bd_intf_net -intf_net xdma_1_M_AXI_B [get_bd_intf_pins smc_spcie/S00_AXI] [get_bd_intf_pins xdma_1/M_AXI_B]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_1_M_AXI_B] [get_bd_intf_pins ila_xdma2smc/SLOT_0_AXI] [get_bd_intf_pins xdma_1/M_AXI_B]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_1_M_AXI_B] [get_bd_intf_pins axi_protocol_checker_0/PC_AXI] [get_bd_intf_pins xdma_1/M_AXI_B]
  connect_bd_intf_net -intf_net xdma_1_pcie_mgt [get_bd_intf_ports pci_express_x4] [get_bd_intf_pins xdma_1/pcie_mgt]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins concat_irq/In2]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins concat_irq/In3]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins concat_irq/In4]
  connect_bd_net -net axi_protocol_checker_0_pc_asserted [get_bd_pins axi_protocol_checker_0/pc_asserted] [get_bd_pins ila_axi_checker/probe1]
  connect_bd_net -net axi_protocol_checker_0_pc_status [get_bd_pins axi_protocol_checker_0/pc_status] [get_bd_pins ila_axi_checker/probe0]
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins concat_irq/In1]
  connect_bd_net -net c_high_dout [get_bd_pins axi_quad_spi_0/keyclearb] [get_bd_pins axi_quad_spi_0/usrdoneo] [get_bd_pins axi_quad_spi_0/usrdonets] [get_bd_pins c_high/dout] [get_bd_pins occamy/jtag_trst_ni]
  connect_bd_net -net clk_wiz_clk_100_bufg [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins clk_wiz/clk_100_bufg] [get_bd_pins psr_100/slowest_sync_clk] [get_bd_pins xxv_ethernet_0_dclkwiz/clk_in1]
  connect_bd_net -net clk_wiz_clk_core [get_bd_pins axi_apb_bridge_0/s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_quad_spi_0/s_axi4_aclk] [get_bd_pins blk_mem_gen_0/clkb] [get_bd_pins clk_wiz/clk_core] [get_bd_pins hbm_0/APB_0_PCLK] [get_bd_pins hbm_0/APB_1_PCLK] [get_bd_pins ila_25/clk] [get_bd_pins ila_occamy2smc2hbm/clk] [get_bd_pins ila_occamy2smc2pcie/clk] [get_bd_pins ila_smc2occamy/clk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins occamy/clk_i] [get_bd_pins occamy/clk_periph_i] [get_bd_pins psr_25/slowest_sync_clk] [get_bd_pins smc_hbm_0/aclk] [get_bd_pins smc_hbm_1/aclk] [get_bd_pins smc_hbm_2/aclk] [get_bd_pins smc_hbm_3/aclk] [get_bd_pins smc_hbm_4/aclk] [get_bd_pins smc_hbm_5/aclk] [get_bd_pins smc_hbm_6/aclk] [get_bd_pins smc_hbm_7/aclk] [get_bd_pins smc_pcie/aclk] [get_bd_pins smc_spcie/aclk] [get_bd_pins vio_sys/clk]
  connect_bd_net -net clk_wiz_clk_hbm [get_bd_pins clk_wiz/clk_hbm] [get_bd_pins hbm_0/AXI_00_ACLK] [get_bd_pins hbm_0/AXI_01_ACLK] [get_bd_pins hbm_0/AXI_04_ACLK] [get_bd_pins hbm_0/AXI_05_ACLK] [get_bd_pins hbm_0/AXI_08_ACLK] [get_bd_pins hbm_0/AXI_12_ACLK] [get_bd_pins hbm_0/AXI_16_ACLK] [get_bd_pins hbm_0/AXI_20_ACLK] [get_bd_pins hbm_0/AXI_24_ACLK] [get_bd_pins hbm_0/AXI_28_ACLK] [get_bd_pins hbm_0/HBM_REF_CLK_0] [get_bd_pins hbm_0/HBM_REF_CLK_1] [get_bd_pins ila_smc2hbm/clk] [get_bd_pins psr_hbm/slowest_sync_clk] [get_bd_pins smc_hbm_0/aclk1] [get_bd_pins smc_hbm_1/aclk1] [get_bd_pins smc_hbm_2/aclk1] [get_bd_pins smc_hbm_3/aclk1] [get_bd_pins smc_hbm_4/aclk1] [get_bd_pins smc_hbm_5/aclk1] [get_bd_pins smc_hbm_6/aclk1] [get_bd_pins smc_hbm_7/aclk1]
  connect_bd_net -net clk_wiz_clk_rtc [get_bd_pins clk_wiz/clk_rtc] [get_bd_pins occamy/rtc_i]
  connect_bd_net -net const_low_dout [get_bd_pins axi_quad_spi_0/gsr] [get_bd_pins axi_quad_spi_0/gts] [get_bd_pins axi_quad_spi_0/usrcclkts] [get_bd_pins c_low/dout] [get_bd_pins occamy/test_mode_i]
  connect_bd_net -net glbl_rst [get_bd_pins concat_rst/In1] [get_bd_pins vio_sys/probe_out1]
  connect_bd_net -net occamy_bootmode [get_bd_pins occamy/boot_mode_i] [get_bd_pins vio_sys/probe_out2]
  connect_bd_net -net occamy_bootrom_addr_o [get_bd_pins occamy/bootrom_addr_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net occamy_rst_vio [get_bd_pins concat_rst_core/In1] [get_bd_pins vio_sys/probe_out0]
  connect_bd_net -net occamy_rstn [get_bd_pins occamy/rst_ni] [get_bd_pins occamy/rst_periph_ni] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net occamy_uart_tx_o [get_bd_ports uart_tx_o_0] [get_bd_pins occamy/uart_tx_o]
  connect_bd_net -net pcie_perstn_1 [get_bd_ports pcie_perstn] [get_bd_pins xdma_1/sys_rst_n]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_apb_bridge_0/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_quad_spi_0/s_axi4_aresetn] [get_bd_pins hbm_0/APB_0_PRESET_N] [get_bd_pins hbm_0/APB_1_PRESET_N] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins psr_25/peripheral_aresetn] [get_bd_pins smc_hbm_0/aresetn] [get_bd_pins smc_hbm_1/aresetn] [get_bd_pins smc_hbm_2/aresetn] [get_bd_pins smc_hbm_3/aresetn] [get_bd_pins smc_hbm_4/aresetn] [get_bd_pins smc_hbm_5/aresetn] [get_bd_pins smc_hbm_6/aresetn] [get_bd_pins smc_hbm_7/aresetn] [get_bd_pins smc_pcie/aresetn] [get_bd_pins smc_spcie/aresetn]
  connect_bd_net -net psr_hbm_peripheral_aresetn [get_bd_pins hbm_0/AXI_00_ARESET_N] [get_bd_pins hbm_0/AXI_01_ARESET_N] [get_bd_pins hbm_0/AXI_04_ARESET_N] [get_bd_pins hbm_0/AXI_05_ARESET_N] [get_bd_pins hbm_0/AXI_08_ARESET_N] [get_bd_pins hbm_0/AXI_12_ARESET_N] [get_bd_pins hbm_0/AXI_16_ARESET_N] [get_bd_pins hbm_0/AXI_20_ARESET_N] [get_bd_pins hbm_0/AXI_24_ARESET_N] [get_bd_pins hbm_0/AXI_28_ARESET_N] [get_bd_pins psr_hbm/peripheral_aresetn]
  connect_bd_net -net reset_1 [get_bd_pins concat_rst/In0] [get_bd_pins concat_rst_core/In0] [get_bd_pins xlconstant_0/dout] [get_bd_pins xxv_ethernet_0_dclkwiz/reset]
  connect_bd_net -net rom_addr [get_bd_pins blk_mem_gen_0/addrb] [get_bd_pins ila_25/probe1] [get_bd_pins xlslice_0/Dout]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets rom_addr]
  connect_bd_net -net rom_doutb [get_bd_pins blk_mem_gen_0/doutb] [get_bd_pins ila_25/probe2] [get_bd_pins occamy/bootrom_data_i]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets rom_doutb]
  connect_bd_net -net rom_en [get_bd_pins blk_mem_gen_0/enb] [get_bd_pins ila_25/probe0] [get_bd_pins occamy/bootrom_en_o]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets rom_en]
  connect_bd_net -net rst_or_Res [get_bd_pins rst_or/Res] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net rst_or_core_Res [get_bd_pins rst_or_core/Res] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net uart_rx_i_0_1 [get_bd_ports uart_rx_i_0] [get_bd_pins occamy/uart_rx_i]
  connect_bd_net -net util_ds_buf_IBUF_DS_ODIV2 [get_bd_pins util_ds_buf/IBUF_DS_ODIV2] [get_bd_pins xdma_1/sys_clk]
  connect_bd_net -net util_ds_buf_IBUF_OUT [get_bd_pins util_ds_buf/IBUF_OUT] [get_bd_pins xdma_1/sys_clk_gt]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins psr_100/ext_reset_in] [get_bd_pins psr_25/ext_reset_in] [get_bd_pins psr_hbm/ext_reset_in] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xdma_1_axi_aclk [get_bd_pins axi_protocol_checker_0/aclk] [get_bd_pins ila_axi_checker/clk] [get_bd_pins ila_xdma2smc/clk] [get_bd_pins smc_spcie/aclk1] [get_bd_pins xdma_1/axi_aclk]
  connect_bd_net -net xdma_1_axi_aresetn [get_bd_pins axi_protocol_checker_0/aresetn] [get_bd_pins xdma_1/axi_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins concat_rst/dout] [get_bd_pins rst_or/Op1]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins concat_irq/dout] [get_bd_pins occamy/ext_irq_i]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins concat_rst_core/dout] [get_bd_pins rst_or_core/Op1]
  connect_bd_net -net xxv_ethernet_0_dclkwiz_locked [get_bd_pins util_vector_logic/Op1] [get_bd_pins xxv_ethernet_0_dclkwiz/locked]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x0001000000000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs occamy/s_axi_pcie/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x0001000000000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs occamy/s_axi_pcie/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x001000000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM00] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM00] -force
  assign_bd_address -offset 0x001010000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM01] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM01] -force
  assign_bd_address -offset 0x001020000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM02] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM02] -force
  assign_bd_address -offset 0x001030000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM03] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM03] -force
  assign_bd_address -offset 0x001040000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM04] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM04] -force
  assign_bd_address -offset 0x001050000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM05] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM05] -force
  assign_bd_address -offset 0x001060000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM06] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM06] -force
  assign_bd_address -offset 0x001070000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM07] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM07] -force
  assign_bd_address -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM08] -force
  assign_bd_address -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM09] -force
  assign_bd_address -offset 0x0010A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM10] -force
  assign_bd_address -offset 0x0010B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM11] -force
  assign_bd_address -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM12] -force
  assign_bd_address -offset 0x0010D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM13] -force
  assign_bd_address -offset 0x0010E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM14] -force
  assign_bd_address -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM15] -force
  assign_bd_address -offset 0x001100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM16] -force
  assign_bd_address -offset 0x001110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM17] -force
  assign_bd_address -offset 0x001120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM18] -force
  assign_bd_address -offset 0x001130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM19] -force
  assign_bd_address -offset 0x001140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM20] -force
  assign_bd_address -offset 0x001150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM21] -force
  assign_bd_address -offset 0x001160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM22] -force
  assign_bd_address -offset 0x001170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM23] -force
  assign_bd_address -offset 0x001180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM24] -force
  assign_bd_address -offset 0x001190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM25] -force
  assign_bd_address -offset 0x0011A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM26] -force
  assign_bd_address -offset 0x0011B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM27] -force
  assign_bd_address -offset 0x0011C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM28] -force
  assign_bd_address -offset 0x0011D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM29] -force
  assign_bd_address -offset 0x0011E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM30] -force
  assign_bd_address -offset 0x0011F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM31] -force
  assign_bd_address -offset 0x4D000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces occamy/m_axi_pcie] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x4D400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces occamy/m_axi_pcie] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x4C000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces occamy/m_axi_pcie] [get_bd_addr_segs axi_quad_spi_0/aximm/MEM0] -force
  assign_bd_address -offset 0x4CC00000 -range 0x00400000 -target_address_space [get_bd_addr_spaces occamy/m_axi_pcie] [get_bd_addr_segs hbm_0/SAPB_0/Reg] -force
  assign_bd_address -offset 0x4C800000 -range 0x00400000 -target_address_space [get_bd_addr_spaces occamy/m_axi_pcie] [get_bd_addr_segs hbm_0/SAPB_1/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x0001000000000000 -target_address_space [get_bd_addr_spaces xdma_1/M_AXI_B] [get_bd_addr_segs occamy/s_axi_pcie/reg0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x001050000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x001060000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM06]
  exclude_bd_addr_seg -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM06]
  exclude_bd_addr_seg -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x0010A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM10]
  exclude_bd_addr_seg -offset 0x0010A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM10]
  exclude_bd_addr_seg -offset 0x0010B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x0010B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM12]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM12]
  exclude_bd_addr_seg -offset 0x0010D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM13]
  exclude_bd_addr_seg -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM13]
  exclude_bd_addr_seg -offset 0x0010E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM14]
  exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x001100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x001110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x001120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x001130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x001140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x001150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x001160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x001170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x001180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x001190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x0011A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0011B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0011C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0011D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0011E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0011F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_00/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_0] [get_bd_addr_segs hbm_0/SAXI_01/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x001010000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x001020000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x001030000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM03]
  exclude_bd_addr_seg -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM03]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x0010A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM10]
  exclude_bd_addr_seg -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM10]
  exclude_bd_addr_seg -offset 0x0010B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM11]
  exclude_bd_addr_seg -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM12]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM12]
  exclude_bd_addr_seg -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM13]
  exclude_bd_addr_seg -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM13]
  exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM14]
  exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_04/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_1] [get_bd_addr_segs hbm_0/SAXI_05/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM03]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM06]
  exclude_bd_addr_seg -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM12]
  exclude_bd_addr_seg -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM13]
  exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_2] [get_bd_addr_segs hbm_0/SAXI_08/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM03]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM06]
  exclude_bd_addr_seg -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM09]
  exclude_bd_addr_seg -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM10]
  exclude_bd_addr_seg -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_3] [get_bd_addr_segs hbm_0/SAXI_12/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM03]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM06]
  exclude_bd_addr_seg -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM09]
  exclude_bd_addr_seg -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM10]
  exclude_bd_addr_seg -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM12]
  exclude_bd_addr_seg -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM13]
  exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_4] [get_bd_addr_segs hbm_0/SAXI_16/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x001020000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x001030000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM03]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x001050000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x001060000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM06]
  exclude_bd_addr_seg -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x0010A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM10]
  exclude_bd_addr_seg -offset 0x0010B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM12]
  exclude_bd_addr_seg -offset 0x0010D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM13]
  exclude_bd_addr_seg -offset 0x0010E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x001100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x001110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x001120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x001130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x001180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x001190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x0011A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0011B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x0011C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0011D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0011E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0011F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_5] [get_bd_addr_segs hbm_0/SAXI_20/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x001020000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x001030000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM03]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x001050000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x001060000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM06]
  exclude_bd_addr_seg -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x0010A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM10]
  exclude_bd_addr_seg -offset 0x0010B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM12]
  exclude_bd_addr_seg -offset 0x0010D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM13]
  exclude_bd_addr_seg -offset 0x0010E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x001100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x001110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x001120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x001130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x001140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x001150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x001160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x001170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x0011C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0011D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0011E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0011F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_6] [get_bd_addr_segs hbm_0/SAXI_24/HBM_MEM31]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x001020000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x001030000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM03]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x001050000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x001060000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM06]
  exclude_bd_addr_seg -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x001080000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x001090000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x0010A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM10]
  exclude_bd_addr_seg -offset 0x0010B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x0010C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM12]
  exclude_bd_addr_seg -offset 0x0010D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM13]
  exclude_bd_addr_seg -offset 0x0010E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0010F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x001100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x001110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x001120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x001130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x001140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x001150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x001160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x001170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x001180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x001190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x0011A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x0011B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces occamy/m_axi_hbm_7] [get_bd_addr_segs hbm_0/SAXI_28/HBM_MEM27]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


