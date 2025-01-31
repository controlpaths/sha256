`timescale 1ns/1ns

`define clk_cycle 10

module sha256_core_tb ();


  reg aclk;
  reg aresetn;

  reg s_axis_tvalid;
  reg [3:0] s_axis_tkeep;
  wire s_axis_tready;
  reg [31:0] s_axis_tdata;
  reg s_axis_tlast;

  wire m_axis_tvalid;
  wire [3:0]  m_axis_tkeep;
  reg m_axis_tready;
  wire [31:0] m_axis_tdata;
  wire m_axis_tlast;

  reg [31:0] data_vector [4:0]; 

  integer w_array_0;
  integer w_array_1;
  integer w_array_2;
  integer w_array_3;
  integer w_array_4;
  integer w_array_5;
  integer w_array_6;
  integer w_array_7;
  integer w_array_8;
  integer w_array_9;
  integer w_array_10;
  integer w_array_11;
  integer w_array_12;
  integer w_array_13;
  integer w_array_14;
  integer w_array_15;
  integer w_array_16;
  integer w_array_17;
  integer w_array_18;
  integer w_array_19;
  integer w_array_20;
  integer w_array_21;
  integer w_array_22;
  integer w_array_23;
  integer w_array_24;
  integer w_array_25;
  integer w_array_26;
  integer w_array_27;
  integer w_array_28;
  integer w_array_29;
  integer w_array_30;
  integer w_array_31;
  integer w_array_32;
  integer w_array_33;
  integer w_array_34;
  integer w_array_35;
  integer w_array_36;
  integer w_array_37;
  integer w_array_38;
  integer w_array_39;
  integer w_array_40;
  integer w_array_41;
  integer w_array_42;
  integer w_array_43;
  integer w_array_44;
  integer w_array_45;
  integer w_array_46;
  integer w_array_47;
  integer w_array_48;
  integer w_array_49;
  integer w_array_50;
  integer w_array_51;
  integer w_array_52;
  integer w_array_53;
  integer w_array_54;
  integer w_array_55;
  integer w_array_56;
  integer w_array_57;
  integer w_array_58;
  integer w_array_59;
  integer w_array_60;
  integer w_array_61;
  integer w_array_62;
  integer w_array_63;


  integer i;

  initial begin
    aclk <= 1'b0;
    forever begin
      #(`clk_cycle/2);
      aclk <= ~aclk;
    end
  end

  sha256_core dut (
  .m_axis_aclk(aclk), 
  .m_axis_aresetn(aresetn), 
  /* input data channel */
  .s_axis_tvalid(s_axis_tvalid),
  .s_axis_tkeep(s_axis_tkeep),
  .s_axis_tready(s_axis_tready),
  .s_axis_tdata(s_axis_tdata),
  .s_axis_tlast(s_axis_tlast),
  /* output data channel */
  .m_axis_tvalid(m_axis_tvalid),
  .m_axis_tkeep(m_axis_tkeep),
  .m_axis_tready(m_axis_tready),
  .m_axis_tdata(m_axis_tdata),
  .m_axis_tlast(m_axis_tlast)
  );

  /* test flow */

  initial
    forever begin
      w_array_0 = dut.w_array[0];
      w_array_1 = dut.w_array[1];
      w_array_2 = dut.w_array[2];
      w_array_3 = dut.w_array[3];
      w_array_4 = dut.w_array[4];
      w_array_5 = dut.w_array[5];
      w_array_6 = dut.w_array[6];
      w_array_7 = dut.w_array[7];
      w_array_8 = dut.w_array[8];
      w_array_9 = dut.w_array[9];
      w_array_10 = dut.w_array[10];
      w_array_11 = dut.w_array[11];
      w_array_12 = dut.w_array[12];
      w_array_13 = dut.w_array[13];
      w_array_14 = dut.w_array[14];
      w_array_15 = dut.w_array[15];
      w_array_16 = dut.w_array[16];
      w_array_17 = dut.w_array[17];
      w_array_18 = dut.w_array[18];
      w_array_19 = dut.w_array[19];
      w_array_20 = dut.w_array[20];
      w_array_21 = dut.w_array[21];
      w_array_22 = dut.w_array[22];
      w_array_23 = dut.w_array[23];
      w_array_24 = dut.w_array[24];
      w_array_25 = dut.w_array[25];
      w_array_26 = dut.w_array[26];
      w_array_27 = dut.w_array[27];
      w_array_28 = dut.w_array[28];
      w_array_29 = dut.w_array[29];
      w_array_30 = dut.w_array[30];
      w_array_31 = dut.w_array[31];
      w_array_32 = dut.w_array[32];
      w_array_33 = dut.w_array[33];
      w_array_34 = dut.w_array[34];
      w_array_35 = dut.w_array[35];
      w_array_36 = dut.w_array[36];
      w_array_37 = dut.w_array[37];
      w_array_38 = dut.w_array[38];
      w_array_39 = dut.w_array[39];
      w_array_40 = dut.w_array[40];
      w_array_41 = dut.w_array[41];
      w_array_42 = dut.w_array[42];
      w_array_43 = dut.w_array[43];
      w_array_44 = dut.w_array[44];
      w_array_45 = dut.w_array[45];
      w_array_46 = dut.w_array[46];
      w_array_47 = dut.w_array[47];
      w_array_48 = dut.w_array[48];
      w_array_49 = dut.w_array[49];
      w_array_50 = dut.w_array[50];
      w_array_51 = dut.w_array[51];
      w_array_52 = dut.w_array[52];
      w_array_53 = dut.w_array[53];
      w_array_54 = dut.w_array[54];
      w_array_55 = dut.w_array[55];
      w_array_56 = dut.w_array[56];
      w_array_57 = dut.w_array[57];
      w_array_58 = dut.w_array[58];
      w_array_59 = dut.w_array[59];
      w_array_60 = dut.w_array[60];
      w_array_61 = dut.w_array[61];
      w_array_62 = dut.w_array[62];
      w_array_63 = dut.w_array[63];
      #(`clk_cycle/2);
    end
  initial begin

    $dumpfile ("data.vcd"); // Change filename as appropriate. 
    $dumpvars();

    i = 0;
    // data_vector[0] = 32'd104; /* h */
    // data_vector[1] = 32'd111; /* o */
    // data_vector[2] = 32'd108; /* l */
    // data_vector[3] = 32'd97; /* a */

    data_vector[0] = 32'd97; /* a */
    data_vector[1] = 32'd100; /* d */
    data_vector[2] = 32'd105; /* i */
    data_vector[3] = 32'd111; /* o */
    data_vector[4] = 32'd115; /* s */

    aresetn <= 1'b0;

    s_axis_tvalid <= 1'b0;
    s_axis_tkeep <= 4'b0000;
    s_axis_tdata <= 32'd0;
    s_axis_tlast <= 1'b0;

    m_axis_tready <= 1'b0;

    #(`clk_cycle*4);
    aresetn <= 1'b1;

    // @(posedge s_axis_tready);
    @(posedge aclk);

    s_axis_tvalid <= 1'b1;

    for (i = 0; i<=4; i=i+1) begin
      s_axis_tdata <= data_vector[i];
      if (i==4)
        s_axis_tlast <= 1'b1;

      @(posedge aclk);
      s_axis_tlast <= 1'b0;
    end

    s_axis_tvalid <= 1'b0;

    m_axis_tready <= 1'b1;
    @(posedge m_axis_tvalid);

    @(negedge m_axis_tvalid);
    m_axis_tready <= 1'b0;

    #(200*`clk_cycle);

    $finish;

  end

endmodule