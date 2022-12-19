`timescale 1ns / 1ps

module iob_piso_reg_en
  #(
    parameter DATA_W = 32
    )
   (

    input              clk_i,
    input              arst_i,

    input              en_i,
    input              sen_i,

    input              ld_i,

    // parallel input
    input [DATA_W-1:0] p_i,

    // serial output
    output             s_o
    );

   reg [DATA_W-1:0]    data_reg;

   wire [DATA_W-1:0]   data;
   assign data = sen_i? data_reg << 1: data_reg;
   
   always @(posedge clk_i, posedge arst_i)
     if (arst_i)
       data_reg <= 1'b0;
     else if (ld_i)
       data_reg <= p_i;
     else if (en_i)
       data_reg <= data;

   assign s_o = data_reg[DATA_W-1];
   
endmodule
