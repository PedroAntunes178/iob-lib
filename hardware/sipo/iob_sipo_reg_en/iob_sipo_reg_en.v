`timescale 1ns / 1ps

module iob_sipo_reg_en
  #(
    parameter DATA_W = 32
    )
   (

    input               clk_i,
    input               arst_i,

    input               en_i,
    input               sen_i,

    // parallel input
    input               s_i,

    // serial output
    output [DATA_W-1:0] p_o
    );

   reg [DATA_W-1:0]  data_reg;
   
   wire [DATA_W-1:0] s_expanded;
   assign s_expanded = {{(DATA_W-1){1'b0}}, s_i};

   wire [DATA_W-1:0] data;
   assign data = sen_i? (data_reg << 1) | s_expanded: data_reg;
   
   always @(posedge clk_i, posedge arst_i)
     if (arst_i)
       data_reg <= {DATA_W{1'b0}};
     else if (en_i)
       data_reg <= data;

   assign p_o = data_reg;
   
endmodule
