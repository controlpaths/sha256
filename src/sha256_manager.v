/**
  Module name: sha256_manager
  Author: PTrujillo
  Date: Jan25
  Description: manage the sha256_core_pif to search a configured hash
  Version: 1.0
  History:
    1.0 - Module created
**/

module sha256_manager #(
  parameter n_calculators = 4,
  parameter max_characters = 12
)(
  input wire aclk, 
  input wire aresetn, 

  input wire [255:0] hash,
  input wire start,
  output reg finish,
  output reg [(max_characters*8)-1:0] result_password,
  output reg [n_calculators-1:0] winner_calculator
);

  // localparam initial_char_list = 8'h20; /* space */
  // localparam last_char_list = 8'h7E; /* Equivalency sign - tilde */

  reg [(max_characters*8)-1:0] password;
  wire [(max_characters*8)-1:0] password_n [n_calculators:0];
  wire [31:0] string_w0[n_calculators-1:0];
  wire [31:0] string_w1[n_calculators-1:0];
  wire [31:0] string_w2[n_calculators-1:0];
  wire [31:0] string_w3[n_calculators-1:0];
  wire [31:0] string_w4[n_calculators-1:0];
  wire [31:0] string_w5[n_calculators-1:0];
  wire [31:0] string_w6[n_calculators-1:0];
  wire [31:0] string_w7[n_calculators-1:0];
  wire [31:0] string_w8[n_calculators-1:0];
  wire [31:0] string_w9[n_calculators-1:0];
  wire [31:0] string_w10[n_calculators-1:0];
  wire [31:0] string_w11[n_calculators-1:0];
  wire [31:0] string_w12[n_calculators-1:0];
  wire [31:0] string_w13[n_calculators-1:0];

  reg [n_calculators-1:0] string_dv;
  wire [7:0] string_size [n_calculators:0];
  wire [7:0] string_end_shift [n_calculators:0];
  wire [n_calculators-1:0] string_ready;
  wire [31:0] string_end [n_calculators:0];

  wire [n_calculators-1:0] sha256_dv;
  wire [255:0] sha256_data [n_calculators-1:0];
  wire [n_calculators-1:0] sha256_found;

  reg [1:0] manager_status;

  generate
    for (genvar j = 0; j<=n_calculators-1; j=j+1) begin : gen_calculators_logic
      assign password_n[j] = password + j;
      assign string_size[j] = (password_n[j] > 2**(8*9))? 8'd10:
                              (password_n[j] > 2**(8*8))? 8'd9:
                              (password_n[j] > 2**(8*7))? 8'd8:
                              (password_n[j] > 2**(8*6))? 8'd7:
                              (password_n[j] > 2**(8*5))? 8'd6:
                              (password_n[j] > 2**(8*4))? 8'd5:
                              (password_n[j] > 2**(8*3))? 8'd4:
                              (password_n[j] > 2**(8*2))? 8'd3:
                              (password_n[j] > 2**(8*1))? 8'd2:
                              8'd1;

      assign string_end[j] = 32'h00000080 << (string_end_shift[j]); /* bits [1:0] corresponds with the position within the word */
      assign string_end_shift[j] = 8'd24-({6'b0, string_size[j][1:0]}<<3);
      assign string_w0[j] = (string_size[j][7:2] == 6'd0)? {password_n[j][7:0], password_n[j][15:8], password_n[j][23:16], password_n[j][31:24]} | string_end[j] : {password_n[j][7:0], password_n[j][15:8], password_n[j][23:16], password_n[j][31:24]};
      assign string_w1[j] = (string_size[j][7:2] == 6'd1)? {password_n[j][7+32:32], password_n[j][15+32:8+32], password_n[j][23+32:16+32], password_n[j][31+32:24+32]} | string_end[j] : {password_n[j][7+32:32], password_n[j][15+32:8+32], password_n[j][23+32:16+32], password_n[j][31+32:24+32]};
      assign string_w2[j] = (string_size[j][7:2] == 6'd2)? {password_n[j][7+48:48], password_n[j][15+48:8+48], password_n[j][23+48:16+48], password_n[j][31+48:24+48]} | string_end[j] : {password_n[j][7+48:48], password_n[j][15+48:8+48], password_n[j][23+48:16+48], password_n[j][31+48:24+48]};
      assign string_w3[j] = 32'd0;
      assign string_w4[j] = 32'd0;
      assign string_w5[j] = 32'd0;
      assign string_w6[j] = 32'd0;
      assign string_w7[j] = 32'd0;
      assign string_w8[j] = 32'd0;
      assign string_w9[j] = 32'd0;
      assign string_w10[j] = 32'd0;
      assign string_w11[j] = 32'd0;
      assign string_w12[j] = 32'd0;
      assign string_w13[j] = 32'd0;

      assign sha256_found[j] = (sha256_data[j] == hash)? 1'b1: 1'b0;
    end
  endgenerate

  always @(posedge aclk)
    if (!aresetn) begin
      manager_status <= 2'd0;
      finish <= 1'b0;
      password <= {((max_characters*8)){1'b0}};
      string_dv <= {n_calculators{1'b0}};
    end
    else 
      case (manager_status)
        2'b00: begin
          if (start) manager_status <= 2'b01;
          else manager_status <= 2'b00;

          finish <= 1'b0;
          string_dv <= {n_calculators{1'b0}};
        end
        2'b01: begin
          if (|sha256_found) manager_status <= 2'b11;
          else manager_status <= 2'b01;

          password <= |sha256_dv? password + n_calculators: password;
          string_dv <= string_ready;
        end
        2'b10: begin
          manager_status <= 2'b00;
        end
        2'b11: begin
          manager_status <= 2'b11;
          
          finish <= 1'b1;
          result_password <= password-n_calculators;
          winner_calculator <= sha256_found;
        end
      endcase

  generate
    for (genvar i=0; i<(n_calculators); i=i+1) begin: gen_calculators
      sha256_core_pif hash_calc(
      .aclk(aclk), 
      .aresetn(aresetn), 
      /* input data channel */
      .string_w0(string_w0[i]),
      .string_w1(string_w1[i]),
      .string_w2(string_w2[i]),
      .string_w3(string_w3[i]),
      .string_w4(string_w4[i]),
      .string_w5(string_w5[i]),
      .string_w6(string_w6[i]),
      .string_w7(string_w7[i]),
      .string_w8(string_w8[i]),
      .string_w9(string_w9[i]),
      .string_w10(string_w10[i]),
      .string_w11(string_w11[i]),
      .string_w12(string_w12[i]),
      .string_w13(string_w13[i]),
      .string_dv(string_dv[i]),
      .string_ready(string_ready[i]),
      .string_size(string_size[i]),
      /* output data channel */
      .sha256_dv(sha256_dv[i]),
      .sha256_data(sha256_data[i])
      );
    end
  endgenerate

endmodule
