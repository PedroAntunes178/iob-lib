`timescale 1ns / 1ps

module iob_edge_detect #(
   parameter CLKEDGE = "posedge"
) (
   `include "iob_clkenrst_port.vs"
   input  bit_i,
   output detected_o
);

   wire bit_i_reg;

   iob_reg #(
      .DATA_W (1),
      .RST_VAL(1'b1),
      .CLKEDGE(CLKEDGE)
   ) reg0 (
      `include "iob_clkenrst_portmap.vs"

      .data_i({bit_i}),
      .data_o(bit_i_reg)
   );

   assign detected_o = bit_i & ~bit_i_reg;

endmodule
