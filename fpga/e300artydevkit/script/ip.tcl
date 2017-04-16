create_ip -vendor xilinx.com -library ip -name clk_wiz -module_name mmcm -dir $ipdir -force
set_property -dict [list \
  CONFIG.PRIMITIVE {MMCM} \
  CONFIG.RESET_TYPE {ACTIVE_LOW} \
  CONFIG.CLKOUT1_USED {true} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {8.388} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {65.000} \
  ] [get_ips mmcm]

create_ip -vendor xilinx.com -library ip -name proc_sys_reset -module_name reset_sys -dir $ipdir -force
set_property -dict [list \
  CONFIG.C_EXT_RESET_HIGH {false} \
  CONFIG.C_AUX_RESET_HIGH {false} \
  CONFIG.C_NUM_BUS_RST {1} \
  CONFIG.C_NUM_PERP_RST {1} \
  CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
  CONFIG.C_NUM_PERP_ARESETN {1} \
  ] [get_ips reset_sys]

create_ip -vendor xilinx.com -library ip -name blk_mem_gen -module_name xilinx_axi_mem -dir $ipdir -force
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.AXI_ID_Width {4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {32} \
  CONFIG.Write_Depth_A {1024} \
  CONFIG.Read_Width_A {32} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {32} \
  CONFIG.Read_Width_B {32} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100}
  ] [get_ips xilinx_axi_mem]

