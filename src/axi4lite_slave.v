/*
 * Module: axi4lite_slave
 * Author: controlpaths.com
 * Date: 6/21/2025
 * Description: 
 *   This module implements an AXI4-Lite slave interface with 9 read-write (RW) 
 *   registers and 6 read-only (RO) registers. The RW registers are writable 
 *   via the AXI4-Lite interface and accessible externally. The RO registers are 
 *   read-only from the AXI4-Lite interface and their values are driven externally.
 *
 * Features:
 *   - AXI4-Lite protocol compliance
 *   - Individual access to RW and RO registers
 *   - Address decoding for up to 15 registers
 *
 * Register Map:
 *   0x00     | RW Register 0
 *   0x04     | RW Register 1
 *   0x08     | RW Register 2
 *   0x0C     | RW Register 3
 *   0x10     | RW Register 4
 *   0x14     | RW Register 5
 *   0x18     | RW Register 6
 *   0x1C     | RW Register 7
 *   0x20     | RW Register 8
 *   0x24     | RO Register 0
 *   0x28     | RO Register 1
 *   0x2C     | RO Register 2
 *   0x30     | RO Register 3
 *   0x34     | RO Register 4
 *   0x38     | RO Register 5
 */

module axi4lite_slave (
    input wire          clk,
    input wire          resetn,
    input wire [31:0]   s_axi_awaddr,
    input wire          s_axi_awvalid,
    output wire         s_axi_awready,
    input wire [31:0]   s_axi_wdata,
    input wire [3:0]    s_axi_wstrb,
    input wire          s_axi_wvalid,
    output wire         s_axi_wready,
    output wire [1:0]   s_axi_bresp,
    output wire         s_axi_bvalid,
    input wire          s_axi_bready,
    input wire [31:0]   s_axi_araddr,
    input wire          s_axi_arvalid,
    output wire         s_axi_arready,
    output wire [31:0]  s_axi_rdata,
    output wire [1:0]   s_axi_rresp,
    output wire         s_axi_rvalid,
    input wire          s_axi_rready,
    output reg [31:0]   rw_reg0,
    output reg [31:0]   rw_reg1,
    output reg [31:0]   rw_reg2,
    output reg [31:0]   rw_reg3,
    output reg [31:0]   rw_reg4,
    output reg [31:0]   rw_reg5,
    output reg [31:0]   rw_reg6,
    output reg [31:0]   rw_reg7,
    output reg [31:0]   rw_reg8,
    input wire [31:0]   ro_reg0,
    input wire [31:0]   ro_reg1,
    input wire [31:0]   ro_reg2,
    input wire [31:0]   ro_reg3,
    input wire [31:0]   ro_reg4,
    input wire [31:0]   ro_reg5
);

    // Internal signals
    reg [31:0] rdata_reg;
    reg rvalid_reg, bvalid_reg;
    reg s_axi_awready_reg, wready_reg, arready_reg;

    assign s_axi_awready = s_axi_awready_reg;
    assign s_axi_wready = wready_reg;
    assign s_axi_bresp = 2'b00; // OKAY response
    assign s_axi_bvalid = bvalid_reg;
    assign s_axi_arready = arready_reg;
    assign s_axi_rdata = rdata_reg;
    assign s_axi_rresp = 2'b00; // OKAY response
    assign s_axi_rvalid = rvalid_reg;

    // Write address handshake
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            s_axi_awready_reg <= 1'b0;
        end else if (s_axi_awvalid && !s_axi_awready_reg) begin
            s_axi_awready_reg <= 1'b1;
        end else begin
            s_axi_awready_reg <= 1'b0;
        end
    end

    // Write data handshake
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            wready_reg <= 1'b0;
            bvalid_reg <= 1'b0;
        end else if (s_axi_wvalid && !wready_reg) begin
            wready_reg <= 1'b1;
            case (s_axi_awaddr[5:2])
                4'h0: begin
                    if (s_axi_wstrb[0]) rw_reg0[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg0[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg0[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg0[31:24] <= s_axi_wdata[31:24];
                end
                4'h1: begin
                    if (s_axi_wstrb[0]) rw_reg1[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg1[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg1[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg1[31:24] <= s_axi_wdata[31:24];
                end
                4'h2: begin
                    if (s_axi_wstrb[0]) rw_reg2[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg2[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg2[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg2[31:24] <= s_axi_wdata[31:24];
                end
                4'h3: begin
                    if (s_axi_wstrb[0]) rw_reg3[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg3[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg3[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg3[31:24] <= s_axi_wdata[31:24];
                end
                4'h4: begin
                    if (s_axi_wstrb[0]) rw_reg4[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg4[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg4[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg4[31:24] <= s_axi_wdata[31:24];
                end
                4'h5: begin
                    if (s_axi_wstrb[0]) rw_reg5[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg5[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg5[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg5[31:24] <= s_axi_wdata[31:24];
                end
                4'h6: begin
                    if (s_axi_wstrb[0]) rw_reg6[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg6[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg6[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg6[31:24] <= s_axi_wdata[31:24];
                end
                4'h7: begin
                    if (s_axi_wstrb[0]) rw_reg7[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg7[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg7[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg7[31:24] <= s_axi_wdata[31:24];
                end
                4'h8: begin
                    if (s_axi_wstrb[0]) rw_reg8[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) rw_reg8[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) rw_reg8[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) rw_reg8[31:24] <= s_axi_wdata[31:24];
                end
                default: begin
                    // Handle invalid addresses
                end
            endcase
            bvalid_reg <= 1'b1;
        end else if (s_axi_bready && bvalid_reg) begin
            bvalid_reg <= 1'b0;
        end else begin
            wready_reg <= 1'b0;
        end
    end

    // Read address handshake
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            arready_reg <= 1'b0;
            rvalid_reg <= 1'b0;
        end else if (s_axi_arvalid && !arready_reg) begin
            arready_reg <= 1'b1;
            case (s_axi_araddr[5:2])
                4'h0: rdata_reg <= rw_reg0;
                4'h1: rdata_reg <= rw_reg1;
                4'h2: rdata_reg <= rw_reg2;
                4'h3: rdata_reg <= rw_reg3;
                4'h4: rdata_reg <= rw_reg4;
                4'h5: rdata_reg <= rw_reg5;
                4'h6: rdata_reg <= rw_reg6;
                4'h7: rdata_reg <= rw_reg7;
                4'h8: rdata_reg <= rw_reg8;
                4'h9: rdata_reg <= ro_reg0;
                4'ha: rdata_reg <= ro_reg1;
                4'hb: rdata_reg <= ro_reg2;
                4'hc: rdata_reg <= ro_reg3;
                4'hd: rdata_reg <= ro_reg4;
                4'he: rdata_reg <= ro_reg5;
                default: rdata_reg <= 32'h00000000; // Default value
            endcase
            rvalid_reg <= 1'b1;
        end else if (s_axi_rready && rvalid_reg) begin
            rvalid_reg <= 1'b0;
        end else begin
            arready_reg <= 1'b0;
        end
    end

endmodule
