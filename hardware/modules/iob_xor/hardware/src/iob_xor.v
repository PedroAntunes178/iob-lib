`timescale 1ns / 1ps


module iob_xor
  #(
    parameter W = 21,
    parameter N = 21
) (
   input [N*W-1:0] in_i,
   output [W-1:0]  out_o
);

   wire [(N-1)*W-1:0] and_vec;
   
   genvar i;
   generate
      for (i = 1; i < N; i = i + 1) begin : gen_mux
         assign and_vec[i*W +: W] = in_i[i*W +: W] ^ and_vec[(i-1)*W +: W];
      end
   endgenerate

   assign out_o = and_vec[(N-1)*W +: W];

endmodule
