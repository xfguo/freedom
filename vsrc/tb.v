`timescale 1ns/1ps

module tb;
  // All wires connected to the chip top
  reg dut_clock;
  reg dut_reset;
  /* input   */ wire dut_io_jtag_TCK;
  /* input   */ wire dut_io_jtag_TMS;
  /* input   */ wire dut_io_jtag_TDI;
  /* output  */ wire dut_io_jtag_TDO;
  /* input   */ wire dut_io_jtag_TRST;
  /* output  */ wire dut_io_jtag_DRV_TDO;

  E300ArtyDevKitSystem dut
  (
    .clock(dut_clock),
    .reset(dut_reset),
    .io_jtag_TCK     (dut_io_jtag_TCK),
    .io_jtag_TMS     (dut_io_jtag_TMS),
    .io_jtag_TDI     (dut_io_jtag_TDI),
    .io_jtag_TDO     (dut_io_jtag_TDO),
    .io_jtag_TRST    (dut_io_jtag_TRST),
    .io_jtag_DRV_TDO (dut_io_jtag_DRV_TDO)
  );

  //=================================================
  // Clock & Reset

  initial begin
    dut_clock = 0;
    while (1) begin
      #10; // 50 MHz
      dut_clock = ~dut_clock;
    end
  end

  initial begin
    dut_reset = 1'b1;
    #100;
    dut_reset = 1'b0;
  end

  JTAGVPI virtual_jtag(
    .jtag_TMS (dut_io_jtag_TMS),
    .jtag_TCK (dut_io_jtag_TCK),
    .jtag_TDI (dut_io_jtag_TDI),
    .jtag_TDO (dut_io_jtag_TDO),
    .jtag_TRST (1'b0),
    .enable(~dut_reset),
    .init_done(~dut_reset)
);

endmodule
