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

  localparam k0 = 32'b01000010100010100010111110011000;
  localparam k1 = 32'b01110001001101110100010010010001;
  localparam k2 = 32'b10110101110000001111101111001111;
  localparam k3 = 32'b11101001101101011101101110100101;
  localparam k4 = 32'b00111001010101101100001001011011;
  localparam k5 = 32'b01011001111100010001000111110001;
  localparam k6 = 32'b10010010001111111000001010100100;
  localparam k7 = 32'b10101011000111000101111011010101;
  localparam k8 = 32'b11011000000001111010101010011000;
  localparam k9 = 32'b00010010100000110101101100000001;
  localparam k10 = 32'b00100100001100011000010110111110;
  localparam k11 = 32'b01010101000011000111110111000011;
  localparam k12 = 32'b01110010101111100101110101110100;
  localparam k13 = 32'b10000000110111101011000111111110;
  localparam k14 = 32'b10011011110111000000011010100111;
  localparam k15 = 32'b11000001100110111111000101110100;
  localparam k16 = 32'b11100100100110110110100111000001;
  localparam k17 = 32'b11101111101111100100011110000110;
  localparam k18 = 32'b00001111110000011001110111000110;
  localparam k19 = 32'b00100100000011001010000111001100;
  localparam k20 = 32'b00101101111010010010110001101111;
  localparam k21 = 32'b01001010011101001000010010101010;
  localparam k22 = 32'b01011100101100001010100111011100;
  localparam k23 = 32'b01110110111110011000100011011010;
  localparam k24 = 32'b10011000001111100101000101010010;
  localparam k25 = 32'b10101000001100011100011001101101;
  localparam k26 = 32'b10110000000000110010011111001000;
  localparam k27 = 32'b10111111010110010111111111000111;
  localparam k28 = 32'b11000110111000000000101111110011;
  localparam k29 = 32'b11010101101001111001000101000111;
  localparam k30 = 32'b00000110110010100110001101010001;
  localparam k31 = 32'b00010100001010010010100101100111;
  localparam k32 = 32'b00100111101101110000101010000101;
  localparam k33 = 32'b00101110000110110010000100111000;
  localparam k34 = 32'b01001101001011000110110111111100;
  localparam k35 = 32'b01010011001110000000110100010011;
  localparam k36 = 32'b01100101000010100111001101010100;
  localparam k37 = 32'b01110110011010100000101010111011;
  localparam k38 = 32'b10000001110000101100100100101110;
  localparam k39 = 32'b10010010011100100010110010000101;
  localparam k40 = 32'b10100010101111111110100010100001;
  localparam k41 = 32'b10101000000110100110011001001011;
  localparam k42 = 32'b11000010010010111000101101110000;
  localparam k43 = 32'b11000111011011000101000110100011;
  localparam k44 = 32'b11010001100100101110100000011001;
  localparam k45 = 32'b11010110100110010000011000100100;
  localparam k46 = 32'b11110100000011100011010110000101;
  localparam k47 = 32'b00010000011010101010000001110000;
  localparam k48 = 32'b00011001101001001100000100010110;
  localparam k49 = 32'b00011110001101110110110000001000;
  localparam k50 = 32'b00100111010010000111011101001100;
  localparam k51 = 32'b00110100101100001011110010110101;
  localparam k52 = 32'b00111001000111000000110010110011;
  localparam k53 = 32'b01001110110110001010101001001010;
  localparam k54 = 32'b01011011100111001100101001001111;
  localparam k55 = 32'b01101000001011100110111111110011;
  localparam k56 = 32'b01110100100011111000001011101110;
  localparam k57 = 32'b01111000101001010110001101101111;
  localparam k58 = 32'b10000100110010000111100000010100;
  localparam k59 = 32'b10001100110001110000001000001000;
  localparam k60 = 32'b10010000101111101111111111111010;
  localparam k61 = 32'b10100100010100000110110011101011;
  localparam k62 = 32'b10111110111110011010001111110111;
  localparam k63 = 32'b11000110011100010111100011110010;

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
  wire [6:0] round [n_calculators-1:0];
  wire [31:0] k_round;
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

          string_dv <= {n_calculators{1'b0}};
          password <= {((max_characters*8)){1'b0}};
        end
        2'b01: begin
          if (|sha256_found) manager_status <= 2'b11;
          else manager_status <= 2'b01;
          
          finish <= 1'b0;
          
          password <= |sha256_dv? password + n_calculators: password;
          string_dv <= string_ready;
        end
        2'b10: begin
          manager_status <= 2'b00;
        end
        2'b11: begin
          if (!start) manager_status <= 2'b00;
          else manager_status <= 2'b11;
          
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
      .round(round[i]),
      .k_round(k_round),
      /* output data channel */
      .sha256_dv(sha256_dv[i]),
      .sha256_data(sha256_data[i])
      );
    end
  endgenerate

  /* return K according round */
  assign k_round = (round[0] == 7'd0)? k0:
                    (round[0] == 7'd1)? k1:
                    (round[0] == 7'd2)? k2:
                    (round[0] == 7'd3)? k3:
                    (round[0] == 7'd4)? k4:
                    (round[0] == 7'd5)? k5:
                    (round[0] == 7'd6)? k6:
                    (round[0] == 7'd7)? k7:
                    (round[0] == 7'd8)? k8:
                    (round[0] == 7'd9)? k9:
                    (round[0] == 7'd10)? k10:
                    (round[0] == 7'd11)? k11:
                    (round[0] == 7'd12)? k12:
                    (round[0] == 7'd13)? k13:
                    (round[0] == 7'd14)? k14:
                    (round[0] == 7'd15)? k15:
                    (round[0] == 7'd16)? k16:
                    (round[0] == 7'd17)? k17:
                    (round[0] == 7'd18)? k18:
                    (round[0] == 7'd19)? k19:
                    (round[0] == 7'd20)? k20:
                    (round[0] == 7'd21)? k21:
                    (round[0] == 7'd22)? k22:
                    (round[0] == 7'd23)? k23:
                    (round[0] == 7'd24)? k24:
                    (round[0] == 7'd25)? k25:
                    (round[0] == 7'd26)? k26:
                    (round[0] == 7'd27)? k27:
                    (round[0] == 7'd28)? k28:
                    (round[0] == 7'd29)? k29:
                    (round[0] == 7'd30)? k30:
                    (round[0] == 7'd31)? k31:
                    (round[0] == 7'd32)? k32:
                    (round[0] == 7'd33)? k33:
                    (round[0] == 7'd34)? k34:
                    (round[0] == 7'd35)? k35:
                    (round[0] == 7'd36)? k36:
                    (round[0] == 7'd37)? k37:
                    (round[0] == 7'd38)? k38:
                    (round[0] == 7'd39)? k39:
                    (round[0] == 7'd40)? k40:
                    (round[0] == 7'd41)? k41:
                    (round[0] == 7'd42)? k42:
                    (round[0] == 7'd43)? k43:
                    (round[0] == 7'd44)? k44:
                    (round[0] == 7'd45)? k45:
                    (round[0] == 7'd46)? k46:
                    (round[0] == 7'd47)? k47:
                    (round[0] == 7'd48)? k48:
                    (round[0] == 7'd49)? k49:
                    (round[0] == 7'd50)? k50:
                    (round[0] == 7'd51)? k51:
                    (round[0] == 7'd52)? k52:
                    (round[0] == 7'd53)? k53:
                    (round[0] == 7'd54)? k54:
                    (round[0] == 7'd55)? k55:
                    (round[0] == 7'd56)? k56:
                    (round[0] == 7'd57)? k57:
                    (round[0] == 7'd58)? k58:
                    (round[0] == 7'd59)? k59:
                    (round[0] == 7'd60)? k60:
                    (round[0] == 7'd61)? k61:
                    (round[0] == 7'd62)? k62:
                    k63;


endmodule
