/**
  Module name: sha256_core_pif
  Author: PTrujillo
  Date: Jan25
  Description: Computes SHA256 of byte array. Input limited to 52 bytes. Parallel input.
  Version: 1.0
  History:
    1.0 - Module created
**/

module sha256_core_pif (
  input wire aclk, 
  input wire aresetn, 

  /* input data channel */
  input wire [31:0] string_w0,
  input wire [31:0] string_w1,
  input wire [31:0] string_w2,
  input wire [31:0] string_w3,
  input wire [31:0] string_w4,
  input wire [31:0] string_w5,
  input wire [31:0] string_w6,
  input wire [31:0] string_w7,
  input wire [31:0] string_w8,
  input wire [31:0] string_w9,
  input wire [31:0] string_w10,
  input wire [31:0] string_w11,
  input wire [31:0] string_w12,
  input wire [31:0] string_w13,
  input wire string_dv,
  output wire string_ready,
  input wire [7:0] string_size,
  
  /* output data channel */
  output reg sha256_dv,
  output reg [255:0] sha256_data
);

  localparam h0 = 32'b01101010000010011110011001100111;
  localparam h1 = 32'b10111011011001111010111010000101;
  localparam h2 = 32'b00111100011011101111001101110010;
  localparam h3 = 32'b10100101010011111111010100111010;
  localparam h4 = 32'b01010001000011100101001001111111;
  localparam h5 = 32'b10011011000001010110100010001100;
  localparam h6 = 32'b00011111100000111101100110101011;
  localparam h7 = 32'b01011011111000001100110100011001;

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

  reg [31:0] w_array [0:63];
  reg [31:0] w_index;
  wire [31:0] w_index_1;
  reg string_dv_reg;
  wire [31:0] theta0;
  wire [31:0] theta1;

  reg [6:0] round;
  wire [31:0] k_round;

  reg [31:0] a_reg;
  reg [31:0] b_reg;
  reg [31:0] c_reg;
  reg [31:0] d_reg;
  reg [31:0] e_reg;
  reg [31:0] f_reg;
  reg [31:0] g_reg;
  reg [31:0] h_reg;

  wire [31:0] temp1;
  wire [31:0] temp2;
  wire [31:0] sum0;
  wire [31:0] sum1;
  wire [31:0] choice;
  wire [31:0] majority;

  integer i;

  assign w_index_1 = w_index + 32'd8; // DEBUG

  /* create the message chunk. Limited to 52 bytes */
  always @(posedge aclk)
    if (!aresetn || (round == 7'd65)) begin
      w_index <= 32'd0;
      for (i=0; i < 63; i=i+1) begin
        w_array[i] <= 32'd0;
      end
      string_dv_reg <= 1'b0;
    end
    else begin

      if (string_dv && !string_dv_reg) begin
        string_dv_reg <= 1'b1; /* data received */

        w_array[0] <= string_w0;
        w_array[1] <= string_w1;
        w_array[2] <= string_w2;
        w_array[3] <= string_w3;
        w_array[4] <= string_w4;
        w_array[5] <= string_w5;
        w_array[6] <= string_w6;
        w_array[7] <= string_w7;
        w_array[8] <= string_w8;
        w_array[9] <= string_w9;
        w_array[10] <= string_w10;
        w_array[11] <= string_w11;
        w_array[12] <= string_w12;
        w_array[13] <= string_w13;
        w_array[14] <= 32'd0;
        w_array[15] <= {21'd0, string_size,3'd0};
        w_index <= 16;
      end
      else if (string_dv_reg && (w_index < 32'd64)) begin
        w_array[w_index] <= w_array[w_index-16] + theta0 + w_array[w_index-7] + theta1;
        w_index <= w_index + 32'd1;

      end
    end

  assign string_ready = !string_dv_reg;

  assign theta0 = {w_array[w_index-15][6:0], w_array[w_index-15][31:7]} ^ {w_array[w_index-15][17:0], w_array[w_index-15][31:18]} ^ {3'b000, w_array[w_index-15][31:3]};
  assign theta1 = {w_array[w_index-2][16:0], w_array[w_index-2][31:17]} ^ {w_array[w_index-2][18:0], w_array[w_index-2][31:19]} ^ {10'b0000000000, w_array[w_index-2][31:10]};
  
  assign sum0 = {a_reg[1:0], a_reg[31:2]} ^ {a_reg[12:0], a_reg[31:13]} ^ {a_reg[21:0], a_reg [31:22]};
  assign sum1 = {e_reg[5:0], e_reg[31:6]} ^ {e_reg[10:0], e_reg[31:11]} ^ {e_reg[24:0], e_reg[31:25]};
  assign choice = (e_reg & f_reg) ^ (~e_reg & g_reg);
  assign majority = (a_reg & b_reg) ^ (a_reg & c_reg) ^ (b_reg & c_reg);

  assign temp1  = h_reg + sum1 + choice + k_round + w_array[round[5:0]];
  assign temp2 = sum0 + majority;

  always @(posedge aclk) 
    if (!aresetn || (!string_dv_reg)) begin
      round <= 7'd0;
      a_reg <= h0;
      b_reg <= h1; 
      c_reg <= h2; 
      d_reg <= h3; 
      e_reg <= h4; 
      f_reg <= h5; 
      g_reg <= h6; 
      h_reg <= h7; 

      sha256_dv <= 1'b0;
    end
    else  
      if (round < 64) begin
        a_reg <= temp1 + temp2;
        b_reg <= a_reg; 
        c_reg <= b_reg; 
        d_reg <= c_reg; 
        e_reg <= d_reg + temp1; 
        f_reg <= e_reg; 
        g_reg <= f_reg; 
        h_reg <= g_reg; 

        round <= round + 7'd1;
      end
      else if (round == 64) begin /* sending hash through AXI4 Stream */
        sha256_data <= {a_reg+h0, b_reg+h1, c_reg+h2, d_reg+h3, e_reg+h4, f_reg+h5, g_reg+h6, h_reg+h7};
        sha256_dv <= 1'b1;
        round <= 65;
      end
      else if (round == 65)
        sha256_dv <= 1'b0;

  /* return K according round */
  assign k_round = (round == 7'd0)? k0:
                    (round == 7'd1)? k1:
                    (round == 7'd2)? k2:
                    (round == 7'd3)? k3:
                    (round == 7'd4)? k4:
                    (round == 7'd5)? k5:
                    (round == 7'd6)? k6:
                    (round == 7'd7)? k7:
                    (round == 7'd8)? k8:
                    (round == 7'd9)? k9:
                    (round == 7'd10)? k10:
                    (round == 7'd11)? k11:
                    (round == 7'd12)? k12:
                    (round == 7'd13)? k13:
                    (round == 7'd14)? k14:
                    (round == 7'd15)? k15:
                    (round == 7'd16)? k16:
                    (round == 7'd17)? k17:
                    (round == 7'd18)? k18:
                    (round == 7'd19)? k19:
                    (round == 7'd20)? k20:
                    (round == 7'd21)? k21:
                    (round == 7'd22)? k22:
                    (round == 7'd23)? k23:
                    (round == 7'd24)? k24:
                    (round == 7'd25)? k25:
                    (round == 7'd26)? k26:
                    (round == 7'd27)? k27:
                    (round == 7'd28)? k28:
                    (round == 7'd29)? k29:
                    (round == 7'd30)? k30:
                    (round == 7'd31)? k31:
                    (round == 7'd32)? k32:
                    (round == 7'd33)? k33:
                    (round == 7'd34)? k34:
                    (round == 7'd35)? k35:
                    (round == 7'd36)? k36:
                    (round == 7'd37)? k37:
                    (round == 7'd38)? k38:
                    (round == 7'd39)? k39:
                    (round == 7'd40)? k40:
                    (round == 7'd41)? k41:
                    (round == 7'd42)? k42:
                    (round == 7'd43)? k43:
                    (round == 7'd44)? k44:
                    (round == 7'd45)? k45:
                    (round == 7'd46)? k46:
                    (round == 7'd47)? k47:
                    (round == 7'd48)? k48:
                    (round == 7'd49)? k49:
                    (round == 7'd50)? k50:
                    (round == 7'd51)? k51:
                    (round == 7'd52)? k52:
                    (round == 7'd53)? k53:
                    (round == 7'd54)? k54:
                    (round == 7'd55)? k55:
                    (round == 7'd56)? k56:
                    (round == 7'd57)? k57:
                    (round == 7'd58)? k58:
                    (round == 7'd59)? k59:
                    (round == 7'd60)? k60:
                    (round == 7'd61)? k61:
                    (round == 7'd62)? k62:
                    k63;

endmodule
