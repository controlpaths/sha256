/**
  Module name: sha256_wrapper
  Description: Wrapper for the sha256 manager
  Author: P.Trujillo
  Date: Abr25
  Revision: 1.0
  History: 
    1.0: Module created
**/

`default_nettype none

module sha256_wrapper #(
	parameter n_calculators = 4
)(
	input wire s_axi_aclk,
  input wire s_axi_aresetn,

  /* AXI4 interface */
  /* address write if */
  input wire [31:0] s_axi_awaddr ,
  input wire s_axi_awvalid,
	output wire s_axi_awready,

  /* data write if */
	input wire [31:0] s_axi_wdata,
	input wire [3:0] s_axi_wstrb,
	input wire s_axi_wvalid,
  output wire s_axi_wready,

	/* status */
	output wire [1:0] s_axi_bresp,
	output wire s_axi_bvalid,
	input wire s_axi_bready,

	/* address read if */
	input wire [31:0] s_axi_araddr,
  input  wire s_axi_arvalid,
  output wire s_axi_arready,

	/* data read if */
  output wire [31:0] s_axi_rdata,	
  output wire [1:0] s_axi_rresp,
	output wire s_axi_rvalid,
	input wire s_axi_rready
	
//  /* status outputs */
//  output wire finish,
//  output wire [1:0] status,
//  output wire [255:0] hash,

//  /* debug_outputs */
//  output wire [(12*8)-1:0] password
  );

  wire [31:0] reg_h0;
  wire [31:0] reg_h1;
  wire [31:0] reg_h2;
  wire [31:0] reg_h3;
  wire [31:0] reg_h4;
  wire [31:0] reg_h5;
  wire [31:0] reg_h6;
  wire [31:0] reg_h7;
  wire [31:0] reg_r0;
  wire [31:0] reg_r1;
  wire [31:0] reg_r2;
  wire [31:0] reg_r3;
  wire [31:0] reg_control;
  wire [31:0] reg_result;
  wire [31:0] reg_winner_calculator;
  wire finish;
  
//  /* AXI interface */
//  sha256_axi sha256_axi_inst (
//	.s_axi_aclk(s_axi_aclk), 
//	.s_axi_aresetn(s_axi_aresetn), 
//	/* address write if */
//  .s_axi_awaddr(s_axi_awaddr),
//  .s_axi_awvalid(s_axi_awvalid),
//	.s_axi_awready(s_axi_awready),
//  /* data write if */
//	.s_axi_wdata(s_axi_wdata),
//	.s_axi_wstrb(s_axi_wstrb),
//	.s_axi_wvalid(s_axi_wvalid),
//  .s_axi_wready(s_axi_wready),
//	/* status */
//	.s_axi_bresp(s_axi_bresp),
//	.s_axi_bvalid(s_axi_bvalid),
//	.s_axi_bready(s_axi_bready),
//	/* address read if */
//	.s_axi_araddr(s_axi_araddr),
//  .s_axi_arvalid(s_axi_arvalid),
//  .s_axi_arready(s_axi_arready),
//	/* data read if */
//  .s_axi_rdata(s_axi_rdata),
//  .s_axi_rresp(s_axi_rresp),
//	.s_axi_rvalid(s_axi_rvalid),
//	.s_axi_rready(s_axi_rready),
//	/* model configuration registers */
//	.reg_h0(reg_h0),
//	.reg_h1(reg_h1),
//	.reg_h2(reg_h2),
//	.reg_h3(reg_h3),
//	.reg_h4(reg_h4),
//	.reg_h5(reg_h5),
//	.reg_h6(reg_h6),
//	.reg_h7(reg_h7),
//	.reg_control(reg_control),
//	.reg_result(reg_result),
//  .reg_winner_calculator(reg_winner_calculator),
//	.reg_r0(reg_r0),
//	.reg_r1(reg_r1),
//	.reg_r2(reg_r2),
//	.reg_r3(reg_r3)
//  );

  axi4lite_slave sha256_axi_inst (
  .clk(s_axi_aclk),
  .resetn(s_axi_aresetn),
  .s_axi_awaddr(s_axi_awaddr),
  .s_axi_awvalid(s_axi_awvalid),
  .s_axi_awready(s_axi_awready),
  .s_axi_wdata(s_axi_wdata),
  .s_axi_wstrb(s_axi_wstrb),
  .s_axi_wvalid(s_axi_wvalid),
  .s_axi_wready(s_axi_wready),
  .s_axi_bresp(s_axi_bresp),
  .s_axi_bvalid(s_axi_bvalid),
  .s_axi_bready(s_axi_bready),
  .s_axi_araddr(s_axi_araddr),
  .s_axi_arvalid(s_axi_arvalid),
  .s_axi_arready(s_axi_arready),
  .s_axi_rdata(s_axi_rdata),
  .s_axi_rresp(s_axi_rresp),
  .s_axi_rvalid(s_axi_rvalid),
  .s_axi_rready(s_axi_rready),
  .rw_reg0(reg_h0),
  .rw_reg1(reg_h1),
  .rw_reg2(reg_h2),
  .rw_reg3(reg_h3),
  .rw_reg4(reg_h4),
  .rw_reg5(reg_h5),
  .rw_reg6(reg_h6),
  .rw_reg7(reg_h7),
  .rw_reg8(reg_control),
  .ro_reg0(reg_result),
  .ro_reg1(reg_winner_calculator),
  .ro_reg2(reg_r0),
  .ro_reg3(reg_r1),
  .ro_reg4(reg_r2),
  .ro_reg5(reg_r3)
);

  assign reg_result = {31'd0, finish};

  /* sha256 manager */
  sha256_manager #(
  .n_calculators(n_calculators)
  ) sha256_manager_inst (
  .aclk(s_axi_aclk), 
  .aresetn(s_axi_aresetn), 
  .hash({reg_h0, reg_h1, reg_h2, reg_h3, reg_h4, reg_h5, reg_h6, reg_h7}),
  .start(reg_control[0]),
  .finish(finish),
  .result_password({reg_r0, reg_r1, reg_r2, reg_r3}),
  .winner_calculator(reg_winner_calculator)
  );

//  assign password = sha256_manager_inst.password;
//  assign status = sha256_manager_inst.manager_status;
//  assign hash = {reg_h0, reg_h1, reg_h2, reg_h3, reg_h4, reg_h5, reg_h6, reg_h7};

endmodule
