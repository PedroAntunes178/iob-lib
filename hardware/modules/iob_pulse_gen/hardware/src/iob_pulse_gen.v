`timescale 1ns / 1ps


module iob_pulse_gen #(
   parameter START    = 0,
   parameter DURATION = 0
) (
   `include "iob_clk_en_rst_port.vs"
   input  start_i,
   output pulse_o
);

   localparam WIDTH = $clog2(START + DURATION + 2);

   //start detect
   wire start_detected;
   wire start_detected_nxt;
   assign start_detected_nxt = start_detected | start_i;

   iob_reg #(
      .DATA_W (1),
      .RST_VAL(0),
      .CLKEDGE("posedge")
   ) start_detected_inst (
      `include "iob_clk_en_rst_portmap.vs"
      .data_i(start_detected_nxt),
      .data_o(start_detected)
   );

   //counter
   wire [    1-1:0] cnt_en;
   wire [WIDTH-1:0] cnt;

   //counter enable
   assign cnt_en = start_detected & (cnt <= (START + DURATION));

   //counter
   iob_counter #(
      .DATA_W (WIDTH),
      .RST_VAL({WIDTH{1'b0}})
   ) cnt0 (
      `include "iob_clk_en_rst_portmap.vs"
      .rst_i (start_i),
      .en_i  (cnt_en),
      .data_o(cnt)
   );

   //pulse
   assign pulse_o = cnt_en & |cnt;

endmodule