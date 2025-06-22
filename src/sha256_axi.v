/**
  Module name: sha256_axi
	Description: AXI interface for the sha256 manager
  Author: P.Trujillo
  Date: Abr25
  Revision: 1.0
  History: 
    1.0: Module created
**/

`default_nettype none

`define S_AXI_DATA_WIDTH 32
`define	S_AXI_ADDR_WIDTH 16 /* 9 parameters needed x 4 bytes */

module sha256_axi (
	input wire s_axi_aclk, 
	input wire s_axi_aresetn, 

	/* address write if */
  input wire [`S_AXI_ADDR_WIDTH - 1:0] s_axi_awaddr ,
  input wire s_axi_awvalid,
	output wire s_axi_awready,

  /* data write if */
	input wire [`S_AXI_DATA_WIDTH-1:0] s_axi_wdata,
	input wire [`S_AXI_DATA_WIDTH/8-1:0] s_axi_wstrb,
	input wire s_axi_wvalid,
  output wire s_axi_wready,

	/* status */
	output wire [1:0] s_axi_bresp,
	output reg s_axi_bvalid,
	input wire s_axi_bready,

	/* address read if */
	input wire [`S_AXI_ADDR_WIDTH - 1:0] s_axi_araddr,
  input  wire s_axi_arvalid,
  output wire s_axi_arready,

	/* data read if */
  output reg [`S_AXI_DATA_WIDTH-1:0] s_axi_rdata,	
  output wire [1:0] s_axi_rresp,
	output reg s_axi_rvalid,
	input wire s_axi_rready,

	/* model configuration registers */
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h0,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h1,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h2,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h3,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h4,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h5,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h6,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_h7,
	output reg [`S_AXI_DATA_WIDTH-1:0] reg_control,
	input wire [`S_AXI_DATA_WIDTH-1:0] reg_result,
	input wire [`S_AXI_DATA_WIDTH-1:0] reg_winner_calculator,
	input wire [`S_AXI_DATA_WIDTH-1:0] reg_r0,
	input wire [`S_AXI_DATA_WIDTH-1:0] reg_r1,
	input wire [`S_AXI_DATA_WIDTH-1:0] reg_r2,
	input wire [`S_AXI_DATA_WIDTH-1:0] reg_r3
);

	localparam ADDR_LSB = 2; /* AXI lite is always 32 bits (32 = 4 bytes) */
	localparam ADDR_MSB = `S_AXI_ADDR_WIDTH-ADDR_LSB; /* AXI lite is always 32 bits (32 = 4 bytes) */

	/**********************************************************************************
	*
	* AXI Registers declaration
	*
	**********************************************************************************/


	/**********************************************************************************
	*
	* AXI internal signals
	*
	**********************************************************************************/

	reg axi_awready; /* write address acceptance */
	wire [ADDR_MSB-1:0] axi_awaddr; /* write address */
	wire [ADDR_MSB-1:0] axi_araddr; /* read address valid */
	wire axi_read_ready; /* read ready */

	/**********************************************************************************
	*
	* Write acceptance.
	*
	**********************************************************************************/

  always @(posedge s_axi_aclk )
    if (!s_axi_aresetn)
      axi_awready <= 1'b0;
    else
      axi_awready <= !axi_awready && (s_axi_awvalid && s_axi_wvalid) && (!s_axi_bvalid || s_axi_bready);
	
	/* Both ready signals are set at the same time */
	assign s_axi_awready = axi_awready;
	assign s_axi_wready = axi_awready;

	/**********************************************************************************
	*
	* Register write
	*
	**********************************************************************************/

	/* set address */
	assign axi_awaddr = s_axi_awaddr[`S_AXI_ADDR_WIDTH-1:ADDR_LSB];

	/* write registers */
	always @(s_axi_aclk)
	if (!s_axi_aresetn) begin
		reg_h0 <= 32'd0;
		reg_h1 <= 32'd0;
		reg_h2 <= 32'd0;
		reg_h3 <= 32'd0;
		reg_h4 <= 32'd0;
		reg_h5 <= 32'd0;
		reg_h6 <= 32'd0;
		reg_h7 <= 32'd0;
		reg_control <= 32'd0;
	end
	else 
		if (axi_awready)
			case(axi_awaddr)
				4'b0000: reg_h0 <= s_axi_wdata;
				4'b0001: reg_h1 <= s_axi_wdata;
				4'b0010: reg_h2 <= s_axi_wdata;
				4'b0011: reg_h3 <= s_axi_wdata;
				4'b0100: reg_h4 <= s_axi_wdata;
				4'b0101: reg_h5 <= s_axi_wdata;
				4'b0110: reg_h6 <= s_axi_wdata;
				4'b0111: reg_h7 <= s_axi_wdata;
				4'b1000: reg_control <= s_axi_wdata;
				default: begin
					reg_h0 <= reg_h0;
					reg_h1 <= reg_h1;
					reg_h2 <= reg_h2;
					reg_h3 <= reg_h3;
					reg_h4 <= reg_h4;
					reg_h5 <= reg_h5;
					reg_h6 <= reg_h6;
					reg_h7 <= reg_h7;
					reg_control <= reg_control;
				end
			endcase

	/**********************************************************************************
	*
	* Register read
	*
	**********************************************************************************/

	assign axi_read_ready = (s_axi_arvalid && s_axi_arready);
	assign axi_araddr = s_axi_araddr[`S_AXI_ADDR_WIDTH-1:ADDR_LSB];

	always @(posedge s_axi_aclk)
		if (!s_axi_aresetn)
			s_axi_rdata <= {`S_AXI_DATA_WIDTH{1'b0}};
		else 
			if (!s_axi_rvalid || s_axi_rready)
				case(axi_araddr)
					4'b0000: s_axi_rdata <= reg_h0;
					4'b0001: s_axi_rdata <= reg_h1;
					4'b0010: s_axi_rdata <= reg_h2;
					4'b0011: s_axi_rdata <= reg_h3;
					4'b0100: s_axi_rdata <= reg_h4;
					4'b0101: s_axi_rdata <= reg_h5;
					4'b0110: s_axi_rdata <= reg_h6;
					4'b0111: s_axi_rdata <= reg_h7;
					4'b1000: s_axi_rdata <= reg_control;
					4'b1001: s_axi_rdata <= reg_result;
					4'b1010: s_axi_rdata <= reg_winner_calculator;
					4'b1011: s_axi_rdata <= reg_r0;
					4'b1100: s_axi_rdata <= reg_r1;
					4'b1101: s_axi_rdata <= reg_r2;
					4'b1110: s_axi_rdata <= reg_r3;
					default: s_axi_rdata <= {`S_AXI_DATA_WIDTH{1'b0}};
				endcase

	/**********************************************************************************
	*
	* AXI information signals
	*
	**********************************************************************************/

	/* force no errors during AXI transactions */
	assign s_axi_bresp = 2'b00;
	assign s_axi_rresp = 2'b00;

	/* s_axi_bvalid is set following any succesful write transaction */
	always @(posedge s_axi_aclk)
		if (!s_axi_aresetn)
			s_axi_bvalid <= 1'b0;
		else 
			if (axi_awready)
				s_axi_bvalid <= 1'b1;
			else if (s_axi_bready)
				s_axi_bvalid <= 1'b0;
	
	/* s_axi_bvalid is set following any succesful read transaction */
	always @(posedge s_axi_aclk)
		if (!s_axi_aresetn)
			s_axi_rvalid <= 1'b0;
		else 
			if (axi_read_ready)
				s_axi_rvalid <= 1'b1;
			else if (s_axi_rready)
				s_axi_rvalid <= 1'b0;

	assign s_axi_arready = !s_axi_rvalid;
	
endmodule
