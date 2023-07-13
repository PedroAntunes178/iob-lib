`timescale 1ns / 1ps

module iob_reg_r #(
   parameter DATA_W  = 21,
   parameter RST_VAL = {DATA_W{1'b0}},
   parameter CLKEDGE = "posedge"
) (
   `include "clk_en_rst_port.vs"

   input rst_i,

   input  [DATA_W-1:0] data_i,
   output [DATA_W-1:0] data_o
);

   wire [DATA_W-1:0] data_nxt = rst_i ? RST_VAL : data_i;

   iob_reg #(
      .DATA_W (DATA_W),
      .RST_VAL(RST_VAL),
      .CLKEDGE(CLKEDGE)
   ) iob_reg_inst (
      `include "clk_en_rst_portmap.vs"
      .data_i(data_nxt),
      .data_o(data_o)
   );

endmodule
