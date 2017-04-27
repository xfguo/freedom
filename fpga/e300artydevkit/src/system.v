`timescale 1ns/1ps

module system
(
`ifdef X
  input wire CLK100MHZ,
`else
  input clk_out1,
  input hfclk,
  input mmcm_locked,

  input reset_core,
  input reset_bus,
  input reset_periph,
  input reset_intcon_n,
  input reset_periph_n,
`endif
  input wire ck_rst,

  // Green LEDs
  inout wire led_0,
  inout wire led_1,
  inout wire led_2,
  inout wire led_3,

  // RGB LEDs, 3 pins each
  output wire led0_r,
  output wire led0_g,
  output wire led0_b,
  output wire led1_r,
  output wire led1_g,
  output wire led1_b,
  output wire led2_r,
  output wire led2_g,
  output wire led2_b,

  // Sliding switches, 3 used as GPIOs
  // sw_3 selects input to UART0
  inout wire sw_0,
  inout wire sw_1,
  inout wire sw_2,
  input wire sw_3,

  // Buttons. First 3 used as GPIOs, the last is used as wakeup
  inout wire btn_0,
  inout wire btn_1,
  inout wire btn_2,
  inout wire btn_3,

  // Dedicated QSPI interface
  output wire qspi_cs,
  output wire qspi_sck,
  inout wire [3:0] qspi_dq,

  // UART0 (GPIO 16,17)
  output wire uart_rxd_out,
  input wire uart_txd_in,

  // UART1 (GPIO 24,25) (not present on 48-pin)
  inout wire ja_0,
  inout wire ja_1,

  // Arduino (aka chipkit) shield digital IO pins, 14 is not connected to the
  // chip, used for debug.
  inout wire [19:0] ck_io,

  // Dedicated SPI pins on 6 pin header standard on later arduino models
  // connected to SPI2 (on FPGA)
  inout wire ck_miso,
  inout wire ck_mosi,
  inout wire ck_ss,
  inout wire ck_sck,

  // JD (used for JTAG connection)
  inout wire jd_0, // TDO
  inout wire jd_1, // TRST_n
  inout wire jd_2, // TCK
  inout wire jd_4, // TDI
  inout wire jd_5, // TMS
  input wire jd_6 // SRST_n
);

  // All wires connected to the chip top
  wire dut_clock;
  wire dut_reset;
  wire dut_io_pads_jtag_TCK_i_ival;
  wire dut_io_pads_jtag_TCK_o_oval;
  wire dut_io_pads_jtag_TCK_o_oe;
  wire dut_io_pads_jtag_TCK_o_ie;
  wire dut_io_pads_jtag_TCK_o_pue;
  wire dut_io_pads_jtag_TCK_o_ds;
  wire dut_io_pads_jtag_TMS_i_ival;
  wire dut_io_pads_jtag_TMS_o_oval;
  wire dut_io_pads_jtag_TMS_o_oe;
  wire dut_io_pads_jtag_TMS_o_ie;
  wire dut_io_pads_jtag_TMS_o_pue;
  wire dut_io_pads_jtag_TMS_o_ds;
  wire dut_io_pads_jtag_TDI_i_ival;
  wire dut_io_pads_jtag_TDI_o_oval;
  wire dut_io_pads_jtag_TDI_o_oe;
  wire dut_io_pads_jtag_TDI_o_ie;
  wire dut_io_pads_jtag_TDI_o_pue;
  wire dut_io_pads_jtag_TDI_o_ds;
  wire dut_io_pads_jtag_TDO_i_ival;
  wire dut_io_pads_jtag_TDO_o_oval;
  wire dut_io_pads_jtag_TDO_o_oe;
  wire dut_io_pads_jtag_TDO_o_ie;
  wire dut_io_pads_jtag_TDO_o_pue;
  wire dut_io_pads_jtag_TDO_o_ds;
  wire dut_io_pads_jtag_TRST_n_i_ival;
  wire dut_io_pads_jtag_TRST_n_o_oval;
  wire dut_io_pads_jtag_TRST_n_o_oe;
  wire dut_io_pads_jtag_TRST_n_o_ie;
  wire dut_io_pads_jtag_TRST_n_o_pue;
  wire dut_io_pads_jtag_TRST_n_o_ds;
  wire dut_io_pads_gpio_0_i_ival;
  wire dut_io_pads_gpio_0_o_oval;
  wire dut_io_pads_gpio_0_o_oe;
  wire dut_io_pads_gpio_0_o_ie;
  wire dut_io_pads_gpio_0_o_pue;
  wire dut_io_pads_gpio_0_o_ds;
  wire dut_io_pads_gpio_1_i_ival;
  wire dut_io_pads_gpio_1_o_oval;
  wire dut_io_pads_gpio_1_o_oe;
  wire dut_io_pads_gpio_1_o_ie;
  wire dut_io_pads_gpio_1_o_pue;
  wire dut_io_pads_gpio_1_o_ds;
  wire dut_io_pads_gpio_2_i_ival;
  wire dut_io_pads_gpio_2_o_oval;
  wire dut_io_pads_gpio_2_o_oe;
  wire dut_io_pads_gpio_2_o_ie;
  wire dut_io_pads_gpio_2_o_pue;
  wire dut_io_pads_gpio_2_o_ds;
  wire dut_io_pads_gpio_3_i_ival;
  wire dut_io_pads_gpio_3_o_oval;
  wire dut_io_pads_gpio_3_o_oe;
  wire dut_io_pads_gpio_3_o_ie;
  wire dut_io_pads_gpio_3_o_pue;
  wire dut_io_pads_gpio_3_o_ds;
  wire dut_io_pads_gpio_4_i_ival;
  wire dut_io_pads_gpio_4_o_oval;
  wire dut_io_pads_gpio_4_o_oe;
  wire dut_io_pads_gpio_4_o_ie;
  wire dut_io_pads_gpio_4_o_pue;
  wire dut_io_pads_gpio_4_o_ds;
  wire dut_io_pads_gpio_5_i_ival;
  wire dut_io_pads_gpio_5_o_oval;
  wire dut_io_pads_gpio_5_o_oe;
  wire dut_io_pads_gpio_5_o_ie;
  wire dut_io_pads_gpio_5_o_pue;
  wire dut_io_pads_gpio_5_o_ds;
  wire dut_io_pads_gpio_6_i_ival;
  wire dut_io_pads_gpio_6_o_oval;
  wire dut_io_pads_gpio_6_o_oe;
  wire dut_io_pads_gpio_6_o_ie;
  wire dut_io_pads_gpio_6_o_pue;
  wire dut_io_pads_gpio_6_o_ds;
  wire dut_io_pads_gpio_7_i_ival;
  wire dut_io_pads_gpio_7_o_oval;
  wire dut_io_pads_gpio_7_o_oe;
  wire dut_io_pads_gpio_7_o_ie;
  wire dut_io_pads_gpio_7_o_pue;
  wire dut_io_pads_gpio_7_o_ds;
  wire dut_io_pads_gpio_8_i_ival;
  wire dut_io_pads_gpio_8_o_oval;
  wire dut_io_pads_gpio_8_o_oe;
  wire dut_io_pads_gpio_8_o_ie;
  wire dut_io_pads_gpio_8_o_pue;
  wire dut_io_pads_gpio_8_o_ds;
  wire dut_io_pads_gpio_9_i_ival;
  wire dut_io_pads_gpio_9_o_oval;
  wire dut_io_pads_gpio_9_o_oe;
  wire dut_io_pads_gpio_9_o_ie;
  wire dut_io_pads_gpio_9_o_pue;
  wire dut_io_pads_gpio_9_o_ds;
  wire dut_io_pads_gpio_10_i_ival;
  wire dut_io_pads_gpio_10_o_oval;
  wire dut_io_pads_gpio_10_o_oe;
  wire dut_io_pads_gpio_10_o_ie;
  wire dut_io_pads_gpio_10_o_pue;
  wire dut_io_pads_gpio_10_o_ds;
  wire dut_io_pads_gpio_11_i_ival;
  wire dut_io_pads_gpio_11_o_oval;
  wire dut_io_pads_gpio_11_o_oe;
  wire dut_io_pads_gpio_11_o_ie;
  wire dut_io_pads_gpio_11_o_pue;
  wire dut_io_pads_gpio_11_o_ds;
  wire dut_io_pads_gpio_12_i_ival;
  wire dut_io_pads_gpio_12_o_oval;
  wire dut_io_pads_gpio_12_o_oe;
  wire dut_io_pads_gpio_12_o_ie;
  wire dut_io_pads_gpio_12_o_pue;
  wire dut_io_pads_gpio_12_o_ds;
  wire dut_io_pads_gpio_13_i_ival;
  wire dut_io_pads_gpio_13_o_oval;
  wire dut_io_pads_gpio_13_o_oe;
  wire dut_io_pads_gpio_13_o_ie;
  wire dut_io_pads_gpio_13_o_pue;
  wire dut_io_pads_gpio_13_o_ds;
  wire dut_io_pads_gpio_14_i_ival;
  wire dut_io_pads_gpio_14_o_oval;
  wire dut_io_pads_gpio_14_o_oe;
  wire dut_io_pads_gpio_14_o_ie;
  wire dut_io_pads_gpio_14_o_pue;
  wire dut_io_pads_gpio_14_o_ds;
  wire dut_io_pads_gpio_15_i_ival;
  wire dut_io_pads_gpio_15_o_oval;
  wire dut_io_pads_gpio_15_o_oe;
  wire dut_io_pads_gpio_15_o_ie;
  wire dut_io_pads_gpio_15_o_pue;
  wire dut_io_pads_gpio_15_o_ds;
  wire dut_io_pads_gpio_16_i_ival;
  wire dut_io_pads_gpio_16_o_oval;
  wire dut_io_pads_gpio_16_o_oe;
  wire dut_io_pads_gpio_16_o_ie;
  wire dut_io_pads_gpio_16_o_pue;
  wire dut_io_pads_gpio_16_o_ds;
  wire dut_io_pads_gpio_17_i_ival;
  wire dut_io_pads_gpio_17_o_oval;
  wire dut_io_pads_gpio_17_o_oe;
  wire dut_io_pads_gpio_17_o_ie;
  wire dut_io_pads_gpio_17_o_pue;
  wire dut_io_pads_gpio_17_o_ds;
  wire dut_io_pads_gpio_18_i_ival;
  wire dut_io_pads_gpio_18_o_oval;
  wire dut_io_pads_gpio_18_o_oe;
  wire dut_io_pads_gpio_18_o_ie;
  wire dut_io_pads_gpio_18_o_pue;
  wire dut_io_pads_gpio_18_o_ds;
  wire dut_io_pads_gpio_19_i_ival;
  wire dut_io_pads_gpio_19_o_oval;
  wire dut_io_pads_gpio_19_o_oe;
  wire dut_io_pads_gpio_19_o_ie;
  wire dut_io_pads_gpio_19_o_pue;
  wire dut_io_pads_gpio_19_o_ds;
  wire dut_io_pads_gpio_20_i_ival;
  wire dut_io_pads_gpio_20_o_oval;
  wire dut_io_pads_gpio_20_o_oe;
  wire dut_io_pads_gpio_20_o_ie;
  wire dut_io_pads_gpio_20_o_pue;
  wire dut_io_pads_gpio_20_o_ds;
  wire dut_io_pads_gpio_21_i_ival;
  wire dut_io_pads_gpio_21_o_oval;
  wire dut_io_pads_gpio_21_o_oe;
  wire dut_io_pads_gpio_21_o_ie;
  wire dut_io_pads_gpio_21_o_pue;
  wire dut_io_pads_gpio_21_o_ds;
  wire dut_io_pads_gpio_22_i_ival;
  wire dut_io_pads_gpio_22_o_oval;
  wire dut_io_pads_gpio_22_o_oe;
  wire dut_io_pads_gpio_22_o_ie;
  wire dut_io_pads_gpio_22_o_pue;
  wire dut_io_pads_gpio_22_o_ds;
  wire dut_io_pads_gpio_23_i_ival;
  wire dut_io_pads_gpio_23_o_oval;
  wire dut_io_pads_gpio_23_o_oe;
  wire dut_io_pads_gpio_23_o_ie;
  wire dut_io_pads_gpio_23_o_pue;
  wire dut_io_pads_gpio_23_o_ds;
  wire dut_io_pads_gpio_24_i_ival;
  wire dut_io_pads_gpio_24_o_oval;
  wire dut_io_pads_gpio_24_o_oe;
  wire dut_io_pads_gpio_24_o_ie;
  wire dut_io_pads_gpio_24_o_pue;
  wire dut_io_pads_gpio_24_o_ds;
  wire dut_io_pads_gpio_25_i_ival;
  wire dut_io_pads_gpio_25_o_oval;
  wire dut_io_pads_gpio_25_o_oe;
  wire dut_io_pads_gpio_25_o_ie;
  wire dut_io_pads_gpio_25_o_pue;
  wire dut_io_pads_gpio_25_o_ds;
  wire dut_io_pads_gpio_26_i_ival;
  wire dut_io_pads_gpio_26_o_oval;
  wire dut_io_pads_gpio_26_o_oe;
  wire dut_io_pads_gpio_26_o_ie;
  wire dut_io_pads_gpio_26_o_pue;
  wire dut_io_pads_gpio_26_o_ds;
  wire dut_io_pads_gpio_27_i_ival;
  wire dut_io_pads_gpio_27_o_oval;
  wire dut_io_pads_gpio_27_o_oe;
  wire dut_io_pads_gpio_27_o_ie;
  wire dut_io_pads_gpio_27_o_pue;
  wire dut_io_pads_gpio_27_o_ds;
  wire dut_io_pads_gpio_28_i_ival;
  wire dut_io_pads_gpio_28_o_oval;
  wire dut_io_pads_gpio_28_o_oe;
  wire dut_io_pads_gpio_28_o_ie;
  wire dut_io_pads_gpio_28_o_pue;
  wire dut_io_pads_gpio_28_o_ds;
  wire dut_io_pads_gpio_29_i_ival;
  wire dut_io_pads_gpio_29_o_oval;
  wire dut_io_pads_gpio_29_o_oe;
  wire dut_io_pads_gpio_29_o_ie;
  wire dut_io_pads_gpio_29_o_pue;
  wire dut_io_pads_gpio_29_o_ds;
  wire dut_io_pads_gpio_30_i_ival;
  wire dut_io_pads_gpio_30_o_oval;
  wire dut_io_pads_gpio_30_o_oe;
  wire dut_io_pads_gpio_30_o_ie;
  wire dut_io_pads_gpio_30_o_pue;
  wire dut_io_pads_gpio_30_o_ds;
  wire dut_io_pads_gpio_31_i_ival;
  wire dut_io_pads_gpio_31_o_oval;
  wire dut_io_pads_gpio_31_o_oe;
  wire dut_io_pads_gpio_31_o_ie;
  wire dut_io_pads_gpio_31_o_pue;
  wire dut_io_pads_gpio_31_o_ds;
  wire dut_io_pads_qspi_sck_i_ival;
  wire dut_io_pads_qspi_sck_o_oval;
  wire dut_io_pads_qspi_sck_o_oe;
  wire dut_io_pads_qspi_sck_o_ie;
  wire dut_io_pads_qspi_sck_o_pue;
  wire dut_io_pads_qspi_sck_o_ds;
  wire dut_io_pads_qspi_dq_0_i_ival;
  wire dut_io_pads_qspi_dq_0_o_oval;
  wire dut_io_pads_qspi_dq_0_o_oe;
  wire dut_io_pads_qspi_dq_0_o_ie;
  wire dut_io_pads_qspi_dq_0_o_pue;
  wire dut_io_pads_qspi_dq_0_o_ds;
  wire dut_io_pads_qspi_dq_1_i_ival;
  wire dut_io_pads_qspi_dq_1_o_oval;
  wire dut_io_pads_qspi_dq_1_o_oe;
  wire dut_io_pads_qspi_dq_1_o_ie;
  wire dut_io_pads_qspi_dq_1_o_pue;
  wire dut_io_pads_qspi_dq_1_o_ds;
  wire dut_io_pads_qspi_dq_2_i_ival;
  wire dut_io_pads_qspi_dq_2_o_oval;
  wire dut_io_pads_qspi_dq_2_o_oe;
  wire dut_io_pads_qspi_dq_2_o_ie;
  wire dut_io_pads_qspi_dq_2_o_pue;
  wire dut_io_pads_qspi_dq_2_o_ds;
  wire dut_io_pads_qspi_dq_3_i_ival;
  wire dut_io_pads_qspi_dq_3_o_oval;
  wire dut_io_pads_qspi_dq_3_o_oe;
  wire dut_io_pads_qspi_dq_3_o_ie;
  wire dut_io_pads_qspi_dq_3_o_pue;
  wire dut_io_pads_qspi_dq_3_o_ds;
  wire dut_io_pads_qspi_cs_0_i_ival;
  wire dut_io_pads_qspi_cs_0_o_oval;
  wire dut_io_pads_qspi_cs_0_o_oe;
  wire dut_io_pads_qspi_cs_0_o_ie;
  wire dut_io_pads_qspi_cs_0_o_pue;
  wire dut_io_pads_qspi_cs_0_o_ds;
  wire dut_io_pads_aon_erst_n_i_ival;
  wire dut_io_pads_aon_erst_n_o_oval;
  wire dut_io_pads_aon_erst_n_o_oe;
  wire dut_io_pads_aon_erst_n_o_ie;
  wire dut_io_pads_aon_erst_n_o_pue;
  wire dut_io_pads_aon_erst_n_o_ds;
  wire dut_io_pads_aon_lfextclk_i_ival;
  wire dut_io_pads_aon_lfextclk_o_oval;
  wire dut_io_pads_aon_lfextclk_o_oe;
  wire dut_io_pads_aon_lfextclk_o_ie;
  wire dut_io_pads_aon_lfextclk_o_pue;
  wire dut_io_pads_aon_lfextclk_o_ds;
  wire dut_io_pads_aon_pmu_dwakeup_n_i_ival;
  wire dut_io_pads_aon_pmu_dwakeup_n_o_oval;
  wire dut_io_pads_aon_pmu_dwakeup_n_o_oe;
  wire dut_io_pads_aon_pmu_dwakeup_n_o_ie;
  wire dut_io_pads_aon_pmu_dwakeup_n_o_pue;
  wire dut_io_pads_aon_pmu_dwakeup_n_o_ds;
  wire dut_io_pads_aon_pmu_vddpaden_i_ival;
  wire dut_io_pads_aon_pmu_vddpaden_o_oval;
  wire dut_io_pads_aon_pmu_vddpaden_o_oe;
  wire dut_io_pads_aon_pmu_vddpaden_o_ie;
  wire dut_io_pads_aon_pmu_vddpaden_o_pue;
  wire dut_io_pads_aon_pmu_vddpaden_o_ds;

  //=================================================
  // Clock & Reset

  wire SRST_n; // From FTDI Chip

`ifdef X
  mmcm ip_mmcm
  (
    .clk_in1(CLK100MHZ),
    .clk_out1(clk_out1), // 8.388 MHz = 32.768 kHz * 256
    .clk_out2(hfclk), // 65 MHz
    .resetn(ck_rst),
    .locked(mmcm_locked)
  );
`else
  
`endif

  wire slowclk;
  clkdivider slowclkgen
  (
    .clk(clk_out1),
    .reset(~mmcm_locked),
    .clk_out(slowclk)
  );

`ifdef X
  reset_sys ip_reset_sys
  (
    .slowest_sync_clk(clk_out1),
    .ext_reset_in(ck_rst & SRST_n), // Active-low
    .aux_reset_in(1'b1),
    .mb_debug_sys_rst(1'b0),
    .dcm_locked(mmcm_locked),
    .mb_reset(reset_core),
    .bus_struct_reset(reset_bus),
    .peripheral_reset(reset_periph),
    .interconnect_aresetn(reset_intcon_n),
    .peripheral_aresetn(reset_periph_n)
  );
`endif

  //=================================================
  // SPI Interface

  wire [3:0] qspi_ui_dq_o, qspi_ui_dq_oe;
  wire [3:0] qspi_ui_dq_i;

  ////PULLUP qspi_pullup[3:0]
  //(
  //  .dout(qspi_dq)
  //);

  gpio_lite qspi_iobuf0
  (
    .pad_io(qspi_dq[0]),
    .dout(qspi_ui_dq_i[0]),
    .din(qspi_ui_dq_o[0]),
    .oe(~qspi_ui_dq_oe[0])
  );

  gpio_lite qspi_iobuf1
  (
    .pad_io(qspi_dq[1]),
    .dout(qspi_ui_dq_i[1]),
    .din(qspi_ui_dq_o[1]),
    .oe(~qspi_ui_dq_oe[1])
  );

  gpio_lite qspi_iobuf2
  (
    .pad_io(qspi_dq[2]),
    .dout(qspi_ui_dq_i[2]),
    .din(qspi_ui_dq_o[2]),
    .oe(~qspi_ui_dq_oe[2])
  );
  
  gpio_lite qspi_iobuf3
  (
    .pad_io(qspi_dq[3]),
    .dout(qspi_ui_dq_i[3]),
    .din(qspi_ui_dq_o[3]),
    .oe(~qspi_ui_dq_oe[3])
  );
  //=================================================
  // gpio_lite instantiation for GPIOs

//  wire ck_io[8];
//  wire ck_io[9];
//  wire ck_io[10];
//  wire ck_io[11];
//  wire ck_io[12];
//  wire ck_io[13];
//  wire gpio_6;
//  wire gpio_7;
//  wire gpio_8;
//  wire ck_io[15];
//  wire ck_io[16];
//  wire ck_io[17];
//  wire ck_io[18];
//  wire ck_io[19];
////  wire gpio_14;
//  wire gpio_15;
//  wire ck_io[0];
//  wire ck_io[1];
//  wire ck_io[2];
//  wire ck_io[3];
//  wire ck_io[4];
//  wire ck_io[5];
//  wire ck_io[6];
//  wire ck_io[7];
//  wire gpio_24;
//  wire gpio_25;
//  wire gpio_26;
//  wire gpio_27;
//  wire gpio_28;
//  wire gpio_29;
//  wire gpio_30;
//  wire gpio_31;

  wire iobuf_gpio_0_o;
  gpio_lite
  IOBUF_gpio_0
  (
    .dout(iobuf_gpio_0_o),
    .pad_io(ck_io[8]),
    .din(dut_io_pads_gpio_0_o_oval),
    .oe(~dut_io_pads_gpio_0_o_oe)
  );
  assign dut_io_pads_gpio_0_i_ival = iobuf_gpio_0_o & dut_io_pads_gpio_0_o_ie;

  wire iobuf_gpio_1_o;
  gpio_lite
  IOBUF_gpio_1
  (
    .dout(iobuf_gpio_1_o),
    .pad_io(ck_io[9]),
    .din(dut_io_pads_gpio_1_o_oval),
    .oe(~dut_io_pads_gpio_1_o_oe)
  );
  assign dut_io_pads_gpio_1_i_ival = iobuf_gpio_1_o & dut_io_pads_gpio_1_o_ie;

  wire iobuf_gpio_2_o;
  gpio_lite
  IOBUF_gpio_2
  (
    .dout(iobuf_gpio_2_o),
    .pad_io(ck_io[10]),
    .din(dut_io_pads_gpio_2_o_oval),
    .oe(~dut_io_pads_gpio_2_o_oe)
  );
  assign dut_io_pads_gpio_2_i_ival = iobuf_gpio_2_o & dut_io_pads_gpio_2_o_ie;

  wire iobuf_gpio_3_o;
  gpio_lite
  IOBUF_gpio_3
  (
    .dout(iobuf_gpio_3_o),
    .pad_io(ck_io[11]),
    .din(dut_io_pads_gpio_3_o_oval),
    .oe(~dut_io_pads_gpio_3_o_oe)
  );
  assign dut_io_pads_gpio_3_i_ival = iobuf_gpio_3_o & dut_io_pads_gpio_3_o_ie;

  wire iobuf_gpio_4_o;
  gpio_lite
  IOBUF_gpio_4
  (
    .dout(iobuf_gpio_4_o),
    .pad_io(ck_io[12]),
    .din(dut_io_pads_gpio_4_o_oval),
    .oe(~dut_io_pads_gpio_4_o_oe)
  );
  assign dut_io_pads_gpio_4_i_ival = iobuf_gpio_4_o & dut_io_pads_gpio_4_o_ie;

  wire iobuf_gpio_5_o;
  gpio_lite
  IOBUF_gpio_5
  (
    .dout(iobuf_gpio_5_o),
    .pad_io(ck_io[13]),
    .din(dut_io_pads_gpio_5_o_oval),
    .oe(~dut_io_pads_gpio_5_o_oe)
  );
  assign dut_io_pads_gpio_5_i_ival = iobuf_gpio_5_o & dut_io_pads_gpio_5_o_ie;

  assign dut_io_pads_gpio_6_i_ival = 1'b0;

  assign dut_io_pads_gpio_7_i_ival = 1'b0;

  assign dut_io_pads_gpio_8_i_ival = 1'b0;

  wire iobuf_gpio_9_o;
  gpio_lite
  IOBUF_gpio_9
  (
    .dout(iobuf_gpio_9_o),
    .pad_io(ck_io[15]),
    .din(dut_io_pads_gpio_9_o_oval),
    .oe(~dut_io_pads_gpio_9_o_oe)
  );
  assign dut_io_pads_gpio_9_i_ival = iobuf_gpio_9_o & dut_io_pads_gpio_9_o_ie;

  wire iobuf_gpio_10_o;
  gpio_lite
  IOBUF_gpio_10
  (
    .dout(iobuf_gpio_10_o),
    .pad_io(ck_io[16]),
    .din(dut_io_pads_gpio_10_o_oval),
    .oe(~dut_io_pads_gpio_10_o_oe)
  );
  assign dut_io_pads_gpio_10_i_ival = iobuf_gpio_10_o & dut_io_pads_gpio_10_o_ie;

  wire iobuf_gpio_11_o;
  gpio_lite
  IOBUF_gpio_11
  (
    .dout(iobuf_gpio_11_o),
    .pad_io(ck_io[17]),
    .din(dut_io_pads_gpio_11_o_oval),
    .oe(~dut_io_pads_gpio_11_o_oe)
  );
  assign dut_io_pads_gpio_11_i_ival = iobuf_gpio_11_o & dut_io_pads_gpio_11_o_ie;

  wire iobuf_gpio_12_o;
  gpio_lite
  IOBUF_gpio_12
  (
    .dout(iobuf_gpio_12_o),
    .pad_io(ck_io[18]),
    .din(dut_io_pads_gpio_12_o_oval),
    .oe(~dut_io_pads_gpio_12_o_oe)
  );
  assign dut_io_pads_gpio_12_i_ival = iobuf_gpio_12_o & dut_io_pads_gpio_12_o_ie;

  wire iobuf_gpio_13_o;
  gpio_lite
  IOBUF_gpio_13
  (
    .dout(iobuf_gpio_13_o),
    .pad_io(ck_io[19]),
    .din(dut_io_pads_gpio_13_o_oval),
    .oe(~dut_io_pads_gpio_13_o_oe)
  );
  assign dut_io_pads_gpio_13_i_ival = iobuf_gpio_13_o & dut_io_pads_gpio_13_o_ie;

  wire iobuf_gpio_14_o;
  gpio_lite
  IOBUF_gpio_14
  (
    .dout(iobuf_gpio_14_o),
    .pad_io(led_3),
    .din(dut_io_pads_gpio_14_o_oval),
    .oe(~dut_io_pads_gpio_14_o_oe)
  );
  assign dut_io_pads_gpio_14_i_ival = iobuf_gpio_14_o & dut_io_pads_gpio_14_o_ie;

  wire iobuf_gpio_15_o;
  gpio_lite
  IOBUF_gpio_15
  (
    .dout(iobuf_gpio_15_o),
    .pad_io(btn_0),
    .din(dut_io_pads_gpio_15_o_oval),
    .oe(~dut_io_pads_gpio_15_o_oe)
  );
  assign dut_io_pads_gpio_15_i_ival = iobuf_gpio_15_o & dut_io_pads_gpio_15_o_ie;

  wire iobuf_gpio_16_o;
  gpio_lite
  IOBUF_gpio_16
  (
    .dout(iobuf_gpio_16_o),
    .pad_io(ck_io[0]),
    .din(dut_io_pads_gpio_16_o_oval),
    .oe(~dut_io_pads_gpio_16_o_oe)
  );
  // This GPIO input is shared between FTDI TX pin and Arduino shield pin using SW[3]
  // see below for details
  assign dut_io_pads_gpio_16_i_ival = sw_3 ? (iobuf_gpio_16_o & dut_io_pads_gpio_16_o_ie) : (uart_txd_in & dut_io_pads_gpio_16_o_ie);

  wire iobuf_gpio_17_o;
  gpio_lite
  IOBUF_gpio_17
  (
    .dout(iobuf_gpio_17_o),
    .pad_io(ck_io[1]),
    .din(dut_io_pads_gpio_17_o_oval),
    .oe(~dut_io_pads_gpio_17_o_oe)
  );
  assign dut_io_pads_gpio_17_i_ival = iobuf_gpio_17_o & dut_io_pads_gpio_17_o_ie;
  assign uart_rxd_out = (dut_io_pads_gpio_17_o_oval & dut_io_pads_gpio_17_o_oe);

  wire iobuf_gpio_18_o;
  gpio_lite
  IOBUF_gpio_18
  (
    .dout(iobuf_gpio_18_o),
    .pad_io(ck_io[2]),
    .din(dut_io_pads_gpio_18_o_oval),
    .oe(~dut_io_pads_gpio_18_o_oe)
  );
  assign dut_io_pads_gpio_18_i_ival = iobuf_gpio_18_o & dut_io_pads_gpio_18_o_ie;

  wire iobuf_gpio_19_o;
  gpio_lite
  IOBUF_gpio_19
  (
    .dout(iobuf_gpio_19_o),
    .pad_io(ck_io[3]),
    .din(dut_io_pads_gpio_19_o_oval),
    .oe(~dut_io_pads_gpio_19_o_oe)
  );
  assign dut_io_pads_gpio_19_i_ival = iobuf_gpio_19_o & dut_io_pads_gpio_19_o_ie;

  wire iobuf_gpio_20_o;
  gpio_lite
  IOBUF_gpio_20
  (
    .dout(iobuf_gpio_20_o),
    .pad_io(ck_io[4]),
    .din(dut_io_pads_gpio_20_o_oval),
    .oe(~dut_io_pads_gpio_20_o_oe)
  );
  assign dut_io_pads_gpio_20_i_ival = iobuf_gpio_20_o & dut_io_pads_gpio_20_o_ie;

  wire iobuf_gpio_21_o;
  gpio_lite
  IOBUF_gpio_21
  (
    .dout(iobuf_gpio_21_o),
    .pad_io(ck_io[5]),
    .din(dut_io_pads_gpio_21_o_oval),
    .oe(~dut_io_pads_gpio_21_o_oe)
  );
  assign dut_io_pads_gpio_21_i_ival = iobuf_gpio_21_o & dut_io_pads_gpio_21_o_ie;

  wire iobuf_gpio_22_o;
  gpio_lite
  IOBUF_gpio_22
  (
    .dout(iobuf_gpio_22_o),
    .pad_io(ck_io[6]),
    .din(dut_io_pads_gpio_22_o_oval),
    .oe(~dut_io_pads_gpio_22_o_oe)
  );
  assign dut_io_pads_gpio_22_i_ival = iobuf_gpio_22_o & dut_io_pads_gpio_22_o_ie;

  wire iobuf_gpio_23_o;
  gpio_lite
  IOBUF_gpio_23
  (
    .dout(iobuf_gpio_23_o),
    .pad_io(ck_io[7]),
    .din(dut_io_pads_gpio_23_o_oval),
    .oe(~dut_io_pads_gpio_23_o_oe)
  );
  assign dut_io_pads_gpio_23_i_ival = iobuf_gpio_23_o & dut_io_pads_gpio_23_o_ie;

  wire iobuf_gpio_24_o;
  gpio_lite
  IOBUF_gpio_24
  (
    .dout(iobuf_gpio_24_o),
    .pad_io(ja_1),
    .din(dut_io_pads_gpio_24_o_oval),
    .oe(~dut_io_pads_gpio_24_o_oe)
  );
  assign dut_io_pads_gpio_24_i_ival = iobuf_gpio_24_o & dut_io_pads_gpio_24_o_ie;

  wire iobuf_gpio_25_o;
  gpio_lite
  IOBUF_gpio_25
  (
    .dout(iobuf_gpio_25_o),
    .pad_io(ja_0),
    .din(dut_io_pads_gpio_25_o_oval),
    .oe(~dut_io_pads_gpio_25_o_oe)
  );
  assign dut_io_pads_gpio_25_i_ival = iobuf_gpio_25_o & dut_io_pads_gpio_25_o_ie;

  wire iobuf_gpio_26_o;
  gpio_lite
  IOBUF_gpio_26
  (
    .dout(iobuf_gpio_26_o),
    .pad_io(ck_ss),
    .din(dut_io_pads_gpio_26_o_oval),
    .oe(~dut_io_pads_gpio_26_o_oe)
  );
  assign dut_io_pads_gpio_26_i_ival = iobuf_gpio_26_o & dut_io_pads_gpio_26_o_ie;

  wire iobuf_gpio_27_o;
  gpio_lite
  IOBUF_gpio_27
  (
    .dout(iobuf_gpio_27_o),
    .pad_io(ck_mosi),
    .din(dut_io_pads_gpio_27_o_oval),
    .oe(~dut_io_pads_gpio_27_o_oe)
  );
  assign dut_io_pads_gpio_27_i_ival = iobuf_gpio_27_o & dut_io_pads_gpio_27_o_ie;

  wire iobuf_gpio_28_o;
  gpio_lite
  IOBUF_gpio_28
  (
    .dout(iobuf_gpio_28_o),
    .pad_io(ck_miso),
    .din(dut_io_pads_gpio_28_o_oval),
    .oe(~dut_io_pads_gpio_28_o_oe)
  );
  assign dut_io_pads_gpio_28_i_ival = iobuf_gpio_28_o & dut_io_pads_gpio_28_o_ie;

  wire iobuf_gpio_29_o;
  gpio_lite
  IOBUF_gpio_29
  (
    .dout(iobuf_gpio_29_o),
    .pad_io(ck_sck),
    .din(dut_io_pads_gpio_29_o_oval),
    .oe(~dut_io_pads_gpio_29_o_oe)
  );
  assign dut_io_pads_gpio_29_i_ival = iobuf_gpio_29_o & dut_io_pads_gpio_29_o_ie;

  wire iobuf_gpio_30_o;
  gpio_lite
  IOBUF_gpio_30
  (
    .dout(iobuf_gpio_30_o),
    .pad_io(btn_1),
    .din(dut_io_pads_gpio_30_o_oval),
    .oe(~dut_io_pads_gpio_30_o_oe)
  );
  assign dut_io_pads_gpio_30_i_ival = iobuf_gpio_30_o & dut_io_pads_gpio_30_o_ie;

  wire iobuf_gpio_31_o;
  gpio_lite
  IOBUF_gpio_31
  (
    .dout(iobuf_gpio_31_o),
    .pad_io(btn_2),
    .din(dut_io_pads_gpio_31_o_oval),
    .oe(~dut_io_pads_gpio_31_o_oe)
  );
  assign dut_io_pads_gpio_31_i_ival = iobuf_gpio_31_o & dut_io_pads_gpio_31_o_ie;

  //=================================================
  // JTAG IOBUFs

  wire iobuf_jtag_TCK_o;
  gpio_lite
  IOBUF_jtag_TCK
  (
    .dout(iobuf_jtag_TCK_o),
    .pad_io(jd_2),
    .din(dut_io_pads_jtag_TCK_o_oval),
    .oe(~dut_io_pads_jtag_TCK_o_oe)
  );
  assign dut_io_pads_jtag_TCK_i_ival = iobuf_jtag_TCK_o & dut_io_pads_jtag_TCK_o_ie;
  //PULLUP pullup_TCK (.O(jd_2));

  wire iobuf_jtag_TMS_o;
  gpio_lite
  IOBUF_jtag_TMS
  (
    .dout(iobuf_jtag_TMS_o),
    .pad_io(jd_5),
    .din(dut_io_pads_jtag_TMS_o_oval),
    .oe(~dut_io_pads_jtag_TMS_o_oe)
  );
  assign dut_io_pads_jtag_TMS_i_ival = iobuf_jtag_TMS_o & dut_io_pads_jtag_TMS_o_ie;
  //PULLUP pullup_TMS (.O(jd_5));

  wire iobuf_jtag_TDI_o;
  gpio_lite
  IOBUF_jtag_TDI
  (
    .dout(iobuf_jtag_TDI_o),
    .pad_io(jd_4),
    .din(dut_io_pads_jtag_TDI_o_oval),
    .oe(~dut_io_pads_jtag_TDI_o_oe)
  );
  assign dut_io_pads_jtag_TDI_i_ival = iobuf_jtag_TDI_o & dut_io_pads_jtag_TDI_o_ie;
  //PULLUP pullup_TDI (.O(jd_4));

  wire iobuf_jtag_TDO_o;
  gpio_lite
  IOBUF_jtag_TDO
  (
    .dout(iobuf_jtag_TDO_o),
    .pad_io(jd_0),
    .din(dut_io_pads_jtag_TDO_o_oval),
    .oe(~dut_io_pads_jtag_TDO_o_oe)
  );
  assign dut_io_pads_jtag_TDO_i_ival = iobuf_jtag_TDO_o & dut_io_pads_jtag_TDO_o_ie;

  wire iobuf_jtag_TRST_n_o;
  gpio_lite
  IOBUF_jtag_TRST_n
  (
    .dout(iobuf_jtag_TRST_n_o),
    .pad_io(jd_1),
    .din(dut_io_pads_jtag_TRST_n_o_oval),
    .oe(~dut_io_pads_jtag_TRST_n_o_oe)
  );
  assign dut_io_pads_jtag_TRST_n_i_ival = iobuf_jtag_TRST_n_o & dut_io_pads_jtag_TRST_n_o_ie;
  //PULLUP pullup_TRST_n(.O(jd_1));

  // Mimic putting a pullup on this line (part of reset vote).
  assign SRST_n = jd_6;
  //PULLUP pullup_SRST_n(.O(SRST_n));

  //=================================================
  // Assignment of gpio_lite "IO" pins to package pins

  // Pins IO0-IO13
  // Shield header row 0: PD0-PD7

  // FTDI UART TX/RX are not connected to ck_io[1,2]
  // the way they are on Arduino boards.  We copy outgoing
  // data to both places, switch 3 (sw[3]) determines whether
  // input to UART comes from FTDI chip or ck_io[0] (shield pin PD0)

  // Header row 3: A0-A5 (we don't support using them as analog inputs)
  // just treat them as regular digital GPIOs
  assign ck_io[14] = uart_txd_in; //ck_io[15];  // A0 = <unconnected> CS(1)

  // Mirror outputs of GPIOs with PWM peripherals to RGB LEDs on Arty
  // assign RGB LED0 R,G,B inputs = PWM0(1,2,3) when iof_1 is active
  assign led0_r = dut_io_pads_gpio_1_o_oval & dut_io_pads_gpio_1_o_oe;
  assign led0_g = dut_io_pads_gpio_2_o_oval & dut_io_pads_gpio_2_o_oe;
  assign led0_b = dut_io_pads_gpio_3_o_oval & dut_io_pads_gpio_2_o_oe;
  // Note that this is the one which is actually connected on the HiFive/Crazy88
  // Board. Same with RGB LED1 R,G,B inputs = PWM1(1,2,3) when iof_1 is active
  assign led1_r = dut_io_pads_gpio_19_o_oval & dut_io_pads_gpio_19_o_oe;
  assign led1_g = dut_io_pads_gpio_21_o_oval & dut_io_pads_gpio_21_o_oe;
  assign led1_b = dut_io_pads_gpio_22_o_oval & dut_io_pads_gpio_22_o_oe;
  // and RGB LED2 R,G,B inputs = PWM2(1,2,3) when iof_1 is active
  assign led2_r = dut_io_pads_gpio_11_o_oval & dut_io_pads_gpio_11_o_oe;
  assign led2_g = dut_io_pads_gpio_12_o_oval & dut_io_pads_gpio_12_o_oe;
  assign led2_b = dut_io_pads_gpio_13_o_oval & dut_io_pads_gpio_13_o_oe;

  // Only 19 out of 20 shield pins connected to GPIO pads
  // Shield pin A5 (pin 14) left unconnected
  // The buttons are connected to some extra GPIO pads not connected on the
  // HiFive1 board

//  assign btn_0 = gpio_15;
//  assign btn_1 = gpio_30;
//  assign btn_2 = gpio_31;

  // UART1 RX/TX pins are assigned to PMOD_D connector pins 0/1
//  assign ja_0 = gpio_25; // UART1 TX
//  assign ja_1 = gpio_24; // UART1 RX

  // SPI2 pins mapped to 6 pin ICSP connector (standard on later arduinos)
  // These are connected to some extra GPIO pads not connected on the HiFive1
  // board
//  assign ck_ss = gpio_26;
//  assign ck_mosi = gpio_27;
//  assign ck_miso = gpio_28;
//  assign ck_sck = gpio_29;

  // Use the LEDs for some more useful debugging things.
  assign led_0 = ck_rst;
  assign led_1 = SRST_n;
  assign led_2 = dut_io_pads_aon_pmu_dwakeup_n_i_ival;
//  assign led_3 = gpio_14;

  E300ArtyDevKitTop dut
  (
    .clock(hfclk),
    .reset(1'b1),
    .io_pads_jtag_TCK_i_ival(dut_io_pads_jtag_TCK_i_ival),
    .io_pads_jtag_TCK_o_oval(dut_io_pads_jtag_TCK_o_oval),
    .io_pads_jtag_TCK_o_oe(dut_io_pads_jtag_TCK_o_oe),
    .io_pads_jtag_TCK_o_ie(dut_io_pads_jtag_TCK_o_ie),
    .io_pads_jtag_TCK_o_pue(dut_io_pads_jtag_TCK_o_pue),
    .io_pads_jtag_TCK_o_ds(dut_io_pads_jtag_TCK_o_ds),
    .io_pads_jtag_TMS_i_ival(dut_io_pads_jtag_TMS_i_ival),
    .io_pads_jtag_TMS_o_oval(dut_io_pads_jtag_TMS_o_oval),
    .io_pads_jtag_TMS_o_oe(dut_io_pads_jtag_TMS_o_oe),
    .io_pads_jtag_TMS_o_ie(dut_io_pads_jtag_TMS_o_ie),
    .io_pads_jtag_TMS_o_pue(dut_io_pads_jtag_TMS_o_pue),
    .io_pads_jtag_TMS_o_ds(dut_io_pads_jtag_TMS_o_ds),
    .io_pads_jtag_TDI_i_ival(dut_io_pads_jtag_TDI_i_ival),
    .io_pads_jtag_TDI_o_oval(dut_io_pads_jtag_TDI_o_oval),
    .io_pads_jtag_TDI_o_oe(dut_io_pads_jtag_TDI_o_oe),
    .io_pads_jtag_TDI_o_ie(dut_io_pads_jtag_TDI_o_ie),
    .io_pads_jtag_TDI_o_pue(dut_io_pads_jtag_TDI_o_pue),
    .io_pads_jtag_TDI_o_ds(dut_io_pads_jtag_TDI_o_ds),
    .io_pads_jtag_TDO_i_ival(dut_io_pads_jtag_TDO_i_ival),
    .io_pads_jtag_TDO_o_oval(dut_io_pads_jtag_TDO_o_oval),
    .io_pads_jtag_TDO_o_oe(dut_io_pads_jtag_TDO_o_oe),
    .io_pads_jtag_TDO_o_ie(dut_io_pads_jtag_TDO_o_ie),
    .io_pads_jtag_TDO_o_pue(dut_io_pads_jtag_TDO_o_pue),
    .io_pads_jtag_TDO_o_ds(dut_io_pads_jtag_TDO_o_ds),
    .io_pads_jtag_TRST_n_i_ival(dut_io_pads_jtag_TRST_n_i_ival),
    .io_pads_jtag_TRST_n_o_oval(dut_io_pads_jtag_TRST_n_o_oval),
    .io_pads_jtag_TRST_n_o_oe(dut_io_pads_jtag_TRST_n_o_oe),
    .io_pads_jtag_TRST_n_o_ie(dut_io_pads_jtag_TRST_n_o_ie),
    .io_pads_jtag_TRST_n_o_pue(dut_io_pads_jtag_TRST_n_o_pue),
    .io_pads_jtag_TRST_n_o_ds(dut_io_pads_jtag_TRST_n_o_ds),
    .io_pads_gpio_0_i_ival(dut_io_pads_gpio_0_i_ival),
    .io_pads_gpio_0_o_oval(dut_io_pads_gpio_0_o_oval),
    .io_pads_gpio_0_o_oe(dut_io_pads_gpio_0_o_oe),
    .io_pads_gpio_0_o_ie(dut_io_pads_gpio_0_o_ie),
    .io_pads_gpio_0_o_pue(dut_io_pads_gpio_0_o_pue),
    .io_pads_gpio_0_o_ds(dut_io_pads_gpio_0_o_ds),
    .io_pads_gpio_1_i_ival(dut_io_pads_gpio_1_i_ival),
    .io_pads_gpio_1_o_oval(dut_io_pads_gpio_1_o_oval),
    .io_pads_gpio_1_o_oe(dut_io_pads_gpio_1_o_oe),
    .io_pads_gpio_1_o_ie(dut_io_pads_gpio_1_o_ie),
    .io_pads_gpio_1_o_pue(dut_io_pads_gpio_1_o_pue),
    .io_pads_gpio_1_o_ds(dut_io_pads_gpio_1_o_ds),
    .io_pads_gpio_2_i_ival(dut_io_pads_gpio_2_i_ival),
    .io_pads_gpio_2_o_oval(dut_io_pads_gpio_2_o_oval),
    .io_pads_gpio_2_o_oe(dut_io_pads_gpio_2_o_oe),
    .io_pads_gpio_2_o_ie(dut_io_pads_gpio_2_o_ie),
    .io_pads_gpio_2_o_pue(dut_io_pads_gpio_2_o_pue),
    .io_pads_gpio_2_o_ds(dut_io_pads_gpio_2_o_ds),
    .io_pads_gpio_3_i_ival(dut_io_pads_gpio_3_i_ival),
    .io_pads_gpio_3_o_oval(dut_io_pads_gpio_3_o_oval),
    .io_pads_gpio_3_o_oe(dut_io_pads_gpio_3_o_oe),
    .io_pads_gpio_3_o_ie(dut_io_pads_gpio_3_o_ie),
    .io_pads_gpio_3_o_pue(dut_io_pads_gpio_3_o_pue),
    .io_pads_gpio_3_o_ds(dut_io_pads_gpio_3_o_ds),
    .io_pads_gpio_4_i_ival(dut_io_pads_gpio_4_i_ival),
    .io_pads_gpio_4_o_oval(dut_io_pads_gpio_4_o_oval),
    .io_pads_gpio_4_o_oe(dut_io_pads_gpio_4_o_oe),
    .io_pads_gpio_4_o_ie(dut_io_pads_gpio_4_o_ie),
    .io_pads_gpio_4_o_pue(dut_io_pads_gpio_4_o_pue),
    .io_pads_gpio_4_o_ds(dut_io_pads_gpio_4_o_ds),
    .io_pads_gpio_5_i_ival(dut_io_pads_gpio_5_i_ival),
    .io_pads_gpio_5_o_oval(dut_io_pads_gpio_5_o_oval),
    .io_pads_gpio_5_o_oe(dut_io_pads_gpio_5_o_oe),
    .io_pads_gpio_5_o_ie(dut_io_pads_gpio_5_o_ie),
    .io_pads_gpio_5_o_pue(dut_io_pads_gpio_5_o_pue),
    .io_pads_gpio_5_o_ds(dut_io_pads_gpio_5_o_ds),
    .io_pads_gpio_6_i_ival(dut_io_pads_gpio_6_i_ival),
    .io_pads_gpio_6_o_oval(dut_io_pads_gpio_6_o_oval),
    .io_pads_gpio_6_o_oe(dut_io_pads_gpio_6_o_oe),
    .io_pads_gpio_6_o_ie(dut_io_pads_gpio_6_o_ie),
    .io_pads_gpio_6_o_pue(dut_io_pads_gpio_6_o_pue),
    .io_pads_gpio_6_o_ds(dut_io_pads_gpio_6_o_ds),
    .io_pads_gpio_7_i_ival(dut_io_pads_gpio_7_i_ival),
    .io_pads_gpio_7_o_oval(dut_io_pads_gpio_7_o_oval),
    .io_pads_gpio_7_o_oe(dut_io_pads_gpio_7_o_oe),
    .io_pads_gpio_7_o_ie(dut_io_pads_gpio_7_o_ie),
    .io_pads_gpio_7_o_pue(dut_io_pads_gpio_7_o_pue),
    .io_pads_gpio_7_o_ds(dut_io_pads_gpio_7_o_ds),
    .io_pads_gpio_8_i_ival(dut_io_pads_gpio_8_i_ival),
    .io_pads_gpio_8_o_oval(dut_io_pads_gpio_8_o_oval),
    .io_pads_gpio_8_o_oe(dut_io_pads_gpio_8_o_oe),
    .io_pads_gpio_8_o_ie(dut_io_pads_gpio_8_o_ie),
    .io_pads_gpio_8_o_pue(dut_io_pads_gpio_8_o_pue),
    .io_pads_gpio_8_o_ds(dut_io_pads_gpio_8_o_ds),
    .io_pads_gpio_9_i_ival(dut_io_pads_gpio_9_i_ival),
    .io_pads_gpio_9_o_oval(dut_io_pads_gpio_9_o_oval),
    .io_pads_gpio_9_o_oe(dut_io_pads_gpio_9_o_oe),
    .io_pads_gpio_9_o_ie(dut_io_pads_gpio_9_o_ie),
    .io_pads_gpio_9_o_pue(dut_io_pads_gpio_9_o_pue),
    .io_pads_gpio_9_o_ds(dut_io_pads_gpio_9_o_ds),
    .io_pads_gpio_10_i_ival(dut_io_pads_gpio_10_i_ival),
    .io_pads_gpio_10_o_oval(dut_io_pads_gpio_10_o_oval),
    .io_pads_gpio_10_o_oe(dut_io_pads_gpio_10_o_oe),
    .io_pads_gpio_10_o_ie(dut_io_pads_gpio_10_o_ie),
    .io_pads_gpio_10_o_pue(dut_io_pads_gpio_10_o_pue),
    .io_pads_gpio_10_o_ds(dut_io_pads_gpio_10_o_ds),
    .io_pads_gpio_11_i_ival(dut_io_pads_gpio_11_i_ival),
    .io_pads_gpio_11_o_oval(dut_io_pads_gpio_11_o_oval),
    .io_pads_gpio_11_o_oe(dut_io_pads_gpio_11_o_oe),
    .io_pads_gpio_11_o_ie(dut_io_pads_gpio_11_o_ie),
    .io_pads_gpio_11_o_pue(dut_io_pads_gpio_11_o_pue),
    .io_pads_gpio_11_o_ds(dut_io_pads_gpio_11_o_ds),
    .io_pads_gpio_12_i_ival(dut_io_pads_gpio_12_i_ival),
    .io_pads_gpio_12_o_oval(dut_io_pads_gpio_12_o_oval),
    .io_pads_gpio_12_o_oe(dut_io_pads_gpio_12_o_oe),
    .io_pads_gpio_12_o_ie(dut_io_pads_gpio_12_o_ie),
    .io_pads_gpio_12_o_pue(dut_io_pads_gpio_12_o_pue),
    .io_pads_gpio_12_o_ds(dut_io_pads_gpio_12_o_ds),
    .io_pads_gpio_13_i_ival(dut_io_pads_gpio_13_i_ival),
    .io_pads_gpio_13_o_oval(dut_io_pads_gpio_13_o_oval),
    .io_pads_gpio_13_o_oe(dut_io_pads_gpio_13_o_oe),
    .io_pads_gpio_13_o_ie(dut_io_pads_gpio_13_o_ie),
    .io_pads_gpio_13_o_pue(dut_io_pads_gpio_13_o_pue),
    .io_pads_gpio_13_o_ds(dut_io_pads_gpio_13_o_ds),
    .io_pads_gpio_14_i_ival(dut_io_pads_gpio_14_i_ival),
    .io_pads_gpio_14_o_oval(dut_io_pads_gpio_14_o_oval),
    .io_pads_gpio_14_o_oe(dut_io_pads_gpio_14_o_oe),
    .io_pads_gpio_14_o_ie(dut_io_pads_gpio_14_o_ie),
    .io_pads_gpio_14_o_pue(dut_io_pads_gpio_14_o_pue),
    .io_pads_gpio_14_o_ds(dut_io_pads_gpio_14_o_ds),
    .io_pads_gpio_15_i_ival(dut_io_pads_gpio_15_i_ival),
    .io_pads_gpio_15_o_oval(dut_io_pads_gpio_15_o_oval),
    .io_pads_gpio_15_o_oe(dut_io_pads_gpio_15_o_oe),
    .io_pads_gpio_15_o_ie(dut_io_pads_gpio_15_o_ie),
    .io_pads_gpio_15_o_pue(dut_io_pads_gpio_15_o_pue),
    .io_pads_gpio_15_o_ds(dut_io_pads_gpio_15_o_ds),
    .io_pads_gpio_16_i_ival(dut_io_pads_gpio_16_i_ival),
    .io_pads_gpio_16_o_oval(dut_io_pads_gpio_16_o_oval),
    .io_pads_gpio_16_o_oe(dut_io_pads_gpio_16_o_oe),
    .io_pads_gpio_16_o_ie(dut_io_pads_gpio_16_o_ie),
    .io_pads_gpio_16_o_pue(dut_io_pads_gpio_16_o_pue),
    .io_pads_gpio_16_o_ds(dut_io_pads_gpio_16_o_ds),
    .io_pads_gpio_17_i_ival(dut_io_pads_gpio_17_i_ival),
    .io_pads_gpio_17_o_oval(dut_io_pads_gpio_17_o_oval),
    .io_pads_gpio_17_o_oe(dut_io_pads_gpio_17_o_oe),
    .io_pads_gpio_17_o_ie(dut_io_pads_gpio_17_o_ie),
    .io_pads_gpio_17_o_pue(dut_io_pads_gpio_17_o_pue),
    .io_pads_gpio_17_o_ds(dut_io_pads_gpio_17_o_ds),
    .io_pads_gpio_18_i_ival(dut_io_pads_gpio_18_i_ival),
    .io_pads_gpio_18_o_oval(dut_io_pads_gpio_18_o_oval),
    .io_pads_gpio_18_o_oe(dut_io_pads_gpio_18_o_oe),
    .io_pads_gpio_18_o_ie(dut_io_pads_gpio_18_o_ie),
    .io_pads_gpio_18_o_pue(dut_io_pads_gpio_18_o_pue),
    .io_pads_gpio_18_o_ds(dut_io_pads_gpio_18_o_ds),
    .io_pads_gpio_19_i_ival(dut_io_pads_gpio_19_i_ival),
    .io_pads_gpio_19_o_oval(dut_io_pads_gpio_19_o_oval),
    .io_pads_gpio_19_o_oe(dut_io_pads_gpio_19_o_oe),
    .io_pads_gpio_19_o_ie(dut_io_pads_gpio_19_o_ie),
    .io_pads_gpio_19_o_pue(dut_io_pads_gpio_19_o_pue),
    .io_pads_gpio_19_o_ds(dut_io_pads_gpio_19_o_ds),
    .io_pads_gpio_20_i_ival(dut_io_pads_gpio_20_i_ival),
    .io_pads_gpio_20_o_oval(dut_io_pads_gpio_20_o_oval),
    .io_pads_gpio_20_o_oe(dut_io_pads_gpio_20_o_oe),
    .io_pads_gpio_20_o_ie(dut_io_pads_gpio_20_o_ie),
    .io_pads_gpio_20_o_pue(dut_io_pads_gpio_20_o_pue),
    .io_pads_gpio_20_o_ds(dut_io_pads_gpio_20_o_ds),
    .io_pads_gpio_21_i_ival(dut_io_pads_gpio_21_i_ival),
    .io_pads_gpio_21_o_oval(dut_io_pads_gpio_21_o_oval),
    .io_pads_gpio_21_o_oe(dut_io_pads_gpio_21_o_oe),
    .io_pads_gpio_21_o_ie(dut_io_pads_gpio_21_o_ie),
    .io_pads_gpio_21_o_pue(dut_io_pads_gpio_21_o_pue),
    .io_pads_gpio_21_o_ds(dut_io_pads_gpio_21_o_ds),
    .io_pads_gpio_22_i_ival(dut_io_pads_gpio_22_i_ival),
    .io_pads_gpio_22_o_oval(dut_io_pads_gpio_22_o_oval),
    .io_pads_gpio_22_o_oe(dut_io_pads_gpio_22_o_oe),
    .io_pads_gpio_22_o_ie(dut_io_pads_gpio_22_o_ie),
    .io_pads_gpio_22_o_pue(dut_io_pads_gpio_22_o_pue),
    .io_pads_gpio_22_o_ds(dut_io_pads_gpio_22_o_ds),
    .io_pads_gpio_23_i_ival(dut_io_pads_gpio_23_i_ival),
    .io_pads_gpio_23_o_oval(dut_io_pads_gpio_23_o_oval),
    .io_pads_gpio_23_o_oe(dut_io_pads_gpio_23_o_oe),
    .io_pads_gpio_23_o_ie(dut_io_pads_gpio_23_o_ie),
    .io_pads_gpio_23_o_pue(dut_io_pads_gpio_23_o_pue),
    .io_pads_gpio_23_o_ds(dut_io_pads_gpio_23_o_ds),
    .io_pads_gpio_24_i_ival(dut_io_pads_gpio_24_i_ival),
    .io_pads_gpio_24_o_oval(dut_io_pads_gpio_24_o_oval),
    .io_pads_gpio_24_o_oe(dut_io_pads_gpio_24_o_oe),
    .io_pads_gpio_24_o_ie(dut_io_pads_gpio_24_o_ie),
    .io_pads_gpio_24_o_pue(dut_io_pads_gpio_24_o_pue),
    .io_pads_gpio_24_o_ds(dut_io_pads_gpio_24_o_ds),
    .io_pads_gpio_25_i_ival(dut_io_pads_gpio_25_i_ival),
    .io_pads_gpio_25_o_oval(dut_io_pads_gpio_25_o_oval),
    .io_pads_gpio_25_o_oe(dut_io_pads_gpio_25_o_oe),
    .io_pads_gpio_25_o_ie(dut_io_pads_gpio_25_o_ie),
    .io_pads_gpio_25_o_pue(dut_io_pads_gpio_25_o_pue),
    .io_pads_gpio_25_o_ds(dut_io_pads_gpio_25_o_ds),
    .io_pads_gpio_26_i_ival(dut_io_pads_gpio_26_i_ival),
    .io_pads_gpio_26_o_oval(dut_io_pads_gpio_26_o_oval),
    .io_pads_gpio_26_o_oe(dut_io_pads_gpio_26_o_oe),
    .io_pads_gpio_26_o_ie(dut_io_pads_gpio_26_o_ie),
    .io_pads_gpio_26_o_pue(dut_io_pads_gpio_26_o_pue),
    .io_pads_gpio_26_o_ds(dut_io_pads_gpio_26_o_ds),
    .io_pads_gpio_27_i_ival(dut_io_pads_gpio_27_i_ival),
    .io_pads_gpio_27_o_oval(dut_io_pads_gpio_27_o_oval),
    .io_pads_gpio_27_o_oe(dut_io_pads_gpio_27_o_oe),
    .io_pads_gpio_27_o_ie(dut_io_pads_gpio_27_o_ie),
    .io_pads_gpio_27_o_pue(dut_io_pads_gpio_27_o_pue),
    .io_pads_gpio_27_o_ds(dut_io_pads_gpio_27_o_ds),
    .io_pads_gpio_28_i_ival(dut_io_pads_gpio_28_i_ival),
    .io_pads_gpio_28_o_oval(dut_io_pads_gpio_28_o_oval),
    .io_pads_gpio_28_o_oe(dut_io_pads_gpio_28_o_oe),
    .io_pads_gpio_28_o_ie(dut_io_pads_gpio_28_o_ie),
    .io_pads_gpio_28_o_pue(dut_io_pads_gpio_28_o_pue),
    .io_pads_gpio_28_o_ds(dut_io_pads_gpio_28_o_ds),
    .io_pads_gpio_29_i_ival(dut_io_pads_gpio_29_i_ival),
    .io_pads_gpio_29_o_oval(dut_io_pads_gpio_29_o_oval),
    .io_pads_gpio_29_o_oe(dut_io_pads_gpio_29_o_oe),
    .io_pads_gpio_29_o_ie(dut_io_pads_gpio_29_o_ie),
    .io_pads_gpio_29_o_pue(dut_io_pads_gpio_29_o_pue),
    .io_pads_gpio_29_o_ds(dut_io_pads_gpio_29_o_ds),
    .io_pads_gpio_30_i_ival(dut_io_pads_gpio_30_i_ival),
    .io_pads_gpio_30_o_oval(dut_io_pads_gpio_30_o_oval),
    .io_pads_gpio_30_o_oe(dut_io_pads_gpio_30_o_oe),
    .io_pads_gpio_30_o_ie(dut_io_pads_gpio_30_o_ie),
    .io_pads_gpio_30_o_pue(dut_io_pads_gpio_30_o_pue),
    .io_pads_gpio_30_o_ds(dut_io_pads_gpio_30_o_ds),
    .io_pads_gpio_31_i_ival(dut_io_pads_gpio_31_i_ival),
    .io_pads_gpio_31_o_oval(dut_io_pads_gpio_31_o_oval),
    .io_pads_gpio_31_o_oe(dut_io_pads_gpio_31_o_oe),
    .io_pads_gpio_31_o_ie(dut_io_pads_gpio_31_o_ie),
    .io_pads_gpio_31_o_pue(dut_io_pads_gpio_31_o_pue),
    .io_pads_gpio_31_o_ds(dut_io_pads_gpio_31_o_ds),
    .io_pads_qspi_sck_i_ival(dut_io_pads_qspi_sck_i_ival),
    .io_pads_qspi_sck_o_oval(dut_io_pads_qspi_sck_o_oval),
    .io_pads_qspi_sck_o_oe(dut_io_pads_qspi_sck_o_oe),
    .io_pads_qspi_sck_o_ie(dut_io_pads_qspi_sck_o_ie),
    .io_pads_qspi_sck_o_pue(dut_io_pads_qspi_sck_o_pue),
    .io_pads_qspi_sck_o_ds(dut_io_pads_qspi_sck_o_ds),
    .io_pads_qspi_dq_0_i_ival(dut_io_pads_qspi_dq_0_i_ival),
    .io_pads_qspi_dq_0_o_oval(dut_io_pads_qspi_dq_0_o_oval),
    .io_pads_qspi_dq_0_o_oe(dut_io_pads_qspi_dq_0_o_oe),
    .io_pads_qspi_dq_0_o_ie(dut_io_pads_qspi_dq_0_o_ie),
    .io_pads_qspi_dq_0_o_pue(dut_io_pads_qspi_dq_0_o_pue),
    .io_pads_qspi_dq_0_o_ds(dut_io_pads_qspi_dq_0_o_ds),
    .io_pads_qspi_dq_1_i_ival(dut_io_pads_qspi_dq_1_i_ival),
    .io_pads_qspi_dq_1_o_oval(dut_io_pads_qspi_dq_1_o_oval),
    .io_pads_qspi_dq_1_o_oe(dut_io_pads_qspi_dq_1_o_oe),
    .io_pads_qspi_dq_1_o_ie(dut_io_pads_qspi_dq_1_o_ie),
    .io_pads_qspi_dq_1_o_pue(dut_io_pads_qspi_dq_1_o_pue),
    .io_pads_qspi_dq_1_o_ds(dut_io_pads_qspi_dq_1_o_ds),
    .io_pads_qspi_dq_2_i_ival(dut_io_pads_qspi_dq_2_i_ival),
    .io_pads_qspi_dq_2_o_oval(dut_io_pads_qspi_dq_2_o_oval),
    .io_pads_qspi_dq_2_o_oe(dut_io_pads_qspi_dq_2_o_oe),
    .io_pads_qspi_dq_2_o_ie(dut_io_pads_qspi_dq_2_o_ie),
    .io_pads_qspi_dq_2_o_pue(dut_io_pads_qspi_dq_2_o_pue),
    .io_pads_qspi_dq_2_o_ds(dut_io_pads_qspi_dq_2_o_ds),
    .io_pads_qspi_dq_3_i_ival(dut_io_pads_qspi_dq_3_i_ival),
    .io_pads_qspi_dq_3_o_oval(dut_io_pads_qspi_dq_3_o_oval),
    .io_pads_qspi_dq_3_o_oe(dut_io_pads_qspi_dq_3_o_oe),
    .io_pads_qspi_dq_3_o_ie(dut_io_pads_qspi_dq_3_o_ie),
    .io_pads_qspi_dq_3_o_pue(dut_io_pads_qspi_dq_3_o_pue),
    .io_pads_qspi_dq_3_o_ds(dut_io_pads_qspi_dq_3_o_ds),
    .io_pads_qspi_cs_0_i_ival(dut_io_pads_qspi_cs_0_i_ival),
    .io_pads_qspi_cs_0_o_oval(dut_io_pads_qspi_cs_0_o_oval),
    .io_pads_qspi_cs_0_o_oe(dut_io_pads_qspi_cs_0_o_oe),
    .io_pads_qspi_cs_0_o_ie(dut_io_pads_qspi_cs_0_o_ie),
    .io_pads_qspi_cs_0_o_pue(dut_io_pads_qspi_cs_0_o_pue),
    .io_pads_qspi_cs_0_o_ds(dut_io_pads_qspi_cs_0_o_ds),
    .io_pads_aon_erst_n_i_ival(dut_io_pads_aon_erst_n_i_ival),
    .io_pads_aon_erst_n_o_oval(dut_io_pads_aon_erst_n_o_oval),
    .io_pads_aon_erst_n_o_oe(dut_io_pads_aon_erst_n_o_oe),
    .io_pads_aon_erst_n_o_ie(dut_io_pads_aon_erst_n_o_ie),
    .io_pads_aon_erst_n_o_pue(dut_io_pads_aon_erst_n_o_pue),
    .io_pads_aon_erst_n_o_ds(dut_io_pads_aon_erst_n_o_ds),
    .io_pads_aon_lfextclk_i_ival(dut_io_pads_aon_lfextclk_i_ival),
    .io_pads_aon_lfextclk_o_oval(dut_io_pads_aon_lfextclk_o_oval),
    .io_pads_aon_lfextclk_o_oe(dut_io_pads_aon_lfextclk_o_oe),
    .io_pads_aon_lfextclk_o_ie(dut_io_pads_aon_lfextclk_o_ie),
    .io_pads_aon_lfextclk_o_pue(dut_io_pads_aon_lfextclk_o_pue),
    .io_pads_aon_lfextclk_o_ds(dut_io_pads_aon_lfextclk_o_ds),
    .io_pads_aon_pmu_dwakeup_n_i_ival(dut_io_pads_aon_pmu_dwakeup_n_i_ival),
    .io_pads_aon_pmu_dwakeup_n_o_oval(dut_io_pads_aon_pmu_dwakeup_n_o_oval),
    .io_pads_aon_pmu_dwakeup_n_o_oe(dut_io_pads_aon_pmu_dwakeup_n_o_oe),
    .io_pads_aon_pmu_dwakeup_n_o_ie(dut_io_pads_aon_pmu_dwakeup_n_o_ie),
    .io_pads_aon_pmu_dwakeup_n_o_pue(dut_io_pads_aon_pmu_dwakeup_n_o_pue),
    .io_pads_aon_pmu_dwakeup_n_o_ds(dut_io_pads_aon_pmu_dwakeup_n_o_ds),
    .io_pads_aon_pmu_vddpaden_i_ival(dut_io_pads_aon_pmu_vddpaden_i_ival),
    .io_pads_aon_pmu_vddpaden_o_oval(dut_io_pads_aon_pmu_vddpaden_o_oval),
    .io_pads_aon_pmu_vddpaden_o_oe(dut_io_pads_aon_pmu_vddpaden_o_oe),
    .io_pads_aon_pmu_vddpaden_o_ie(dut_io_pads_aon_pmu_vddpaden_o_ie),
    .io_pads_aon_pmu_vddpaden_o_pue(dut_io_pads_aon_pmu_vddpaden_o_pue),
    .io_pads_aon_pmu_vddpaden_o_ds(dut_io_pads_aon_pmu_vddpaden_o_ds)
  );

  // Assign reasonable values to otherwise unconnected inputs to chip top

  wire iobuf_dwakeup_o;
  gpio_lite
  IOBUF_dwakeup_n
  (
    .dout(iobuf_dwakeup_o),
    .pad_io(btn_3),
    .din(~dut_io_pads_aon_pmu_dwakeup_n_o_oval),
    .oe(~dut_io_pads_aon_pmu_dwakeup_n_o_oe)
  );
  assign dut_io_pads_aon_pmu_dwakeup_n_i_ival = (~iobuf_dwakeup_o) & dut_io_pads_aon_pmu_dwakeup_n_o_ie;

  assign dut_io_pads_aon_erst_n_i_ival = ~reset_periph;
  assign dut_io_pads_aon_lfextclk_i_ival = slowclk;

  assign dut_io_pads_aon_pmu_vddpaden_i_ival = 1'b1;

  assign qspi_cs = dut_io_pads_qspi_cs_0_o_oval;
  assign qspi_ui_dq_o = {
    dut_io_pads_qspi_dq_3_o_oval,
    dut_io_pads_qspi_dq_2_o_oval,
    dut_io_pads_qspi_dq_1_o_oval,
    dut_io_pads_qspi_dq_0_o_oval
  };
  assign qspi_ui_dq_oe = {
    dut_io_pads_qspi_dq_3_o_oe,
    dut_io_pads_qspi_dq_2_o_oe,
    dut_io_pads_qspi_dq_1_o_oe,
    dut_io_pads_qspi_dq_0_o_oe
  };
  assign dut_io_pads_qspi_dq_0_i_ival = qspi_ui_dq_i[0];
  assign dut_io_pads_qspi_dq_1_i_ival = qspi_ui_dq_i[1];
  assign dut_io_pads_qspi_dq_2_i_ival = qspi_ui_dq_i[2];
  assign dut_io_pads_qspi_dq_3_i_ival = qspi_ui_dq_i[3];
  assign qspi_sck = dut_io_pads_qspi_sck_o_oval;
endmodule

// Divide clock by 256, used to generate 32.768 kHz clock for AON block
module clkdivider
(
  input wire clk,
  input wire reset,
  output reg clk_out
);

  reg [7:0] counter;

  always @(posedge clk)
  begin
    if (reset)
    begin
      counter <= 8'd0;
      clk_out <= 1'b0;
    end
    else if (counter == 8'hff)
    begin
      counter <= 8'd0;
      clk_out <= ~clk_out;
    end
    else
    begin
      counter <= counter+1;
    end
  end
endmodule

