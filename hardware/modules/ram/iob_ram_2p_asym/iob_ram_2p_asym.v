`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_ram_2p_asym
  #(
    parameter
    W_DATA_W = 42,
    R_DATA_W = 21,
    ADDR_W = 3, //higher ADDR_W lower DATA_W
    //determine W_ADDR_W and R_ADDR_W
    MAXDATA_W = `IOB_MAX(W_DATA_W, R_DATA_W),
    MINDATA_W = `IOB_MIN(W_DATA_W, R_DATA_W),
    R = MAXDATA_W/MINDATA_W,
    MINADDR_W = ADDR_W-$clog2(R),//lower ADDR_W (higher DATA_W)
    W_ADDR_W = (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W,
    R_ADDR_W = (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
  )
  (
    `IOB_INPUT(clk_i, 1),
    `IOB_INPUT(arst_i, 1),
    `IOB_INPUT(cke_i, 1),

    //write port
    `IOB_INPUT(w_en_i, 1),
    `IOB_INPUT(w_addr_i, W_ADDR_W),
    `IOB_INPUT(w_data_i, W_DATA_W),

    //read port
    `IOB_INPUT(r_en_i, 1),
    `IOB_INPUT(r_addr_i, R_ADDR_W),
    `IOB_OUTPUT(r_data_o, R_DATA_W),

    //external memory write port
    `IOB_OUTPUT(ext_mem_clk_o, 1),
    `IOB_OUTPUT(ext_mem_w_en_o, R),
    `IOB_OUTPUT(ext_mem_w_addr_o, MINADDR_W),
    `IOB_OUTPUT(ext_mem_w_data_o, MAXDATA_W),
    //external memory read port
    `IOB_OUTPUT(ext_mem_r_en_o, R),
    `IOB_OUTPUT(ext_mem_r_addr_o, MINADDR_W),
    `IOB_INPUT(ext_mem_r_data_i, MAXDATA_W)

    );

  assign ext_mem_clk_o = clk_i;

  //Generate the RAM based on the parameters
  generate
    if (W_DATA_W > R_DATA_W) begin
      //memory write port
      assign ext_mem_w_en_o = {R{w_en_i}};
      assign ext_mem_w_addr_o = w_addr_i;
      assign ext_mem_w_data_o = w_data_i;

      //register to hold the LSBs of r_addr_i
      wire [$clog2(R)-1:0] r_addr_lsbs_reg;
      iob_reg #(
        .DATA_W($clog2(R)),
        .RST_VAL({$clog2(R){1'd0}})
      ) r_addr_reg_inst (
        .clk_i(clk_i),
        .arst_i(arst_i),
        .cke_i(cke_i),
        .data_i(r_addr_i[$clog2(R)-1:0]),
        .data_o(r_addr_lsbs_reg)
      );

      //memory read port
      assign ext_mem_r_en_o = {{(R-1){1'd0}},r_en_i} << r_addr_i[$clog2(R)-1:0];
      assign ext_mem_r_addr_o = r_addr_i[R_ADDR_W-1:$clog2(R)];

      wire [W_DATA_W-1:0]    r_data;
      assign r_data = ext_mem_r_data_i >> (r_addr_lsbs_reg*R_DATA_W);
      assign r_data_o = r_data[R_DATA_W-1:0];

    end else if (W_DATA_W < R_DATA_W) begin
      //memory write port
      assign ext_mem_w_en_o = {{(R-1){1'd0}},w_en_i} << w_addr_i[$clog2(R)-1:0];
      assign ext_mem_w_data_o = {{(R_DATA_W-W_DATA_W){1'd0}},w_data_i} << (w_addr_i[$clog2(R)-1:0]*W_DATA_W);
      assign ext_mem_w_addr_o = w_addr_i[W_ADDR_W-1:$clog2(R)];

      //memory read port
      assign ext_mem_r_en_o = {R{r_en_i}};
      assign ext_mem_r_addr_o = r_addr_i;
      assign r_data_o = ext_mem_r_data_i;
      
    end else begin //W_DATA_W == R_DATA_W
      //memory write port
      assign ext_mem_w_en_o = w_en_i;
      assign ext_mem_w_addr_o = w_addr_i;
      assign ext_mem_w_data_o = w_data_i;

      //memory read port
      assign ext_mem_r_en_o = r_en_i;
      assign ext_mem_r_addr_o = r_addr_i;
      assign r_data_o = ext_mem_r_data_i;
    end
  endgenerate
  
endmodule
