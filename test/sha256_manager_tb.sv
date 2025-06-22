`timescale 1ns/1ns
`define clk_cycle 10

module sha256_core_tb ();

  reg aclk;
  reg aresetn;
  wire [79:0] result_password;
  wire [3:0] winner_calculator;
  integer i;
  reg start;
  wire finish;

  initial begin
    aclk <= 1'b0;
    forever begin
      #(`clk_cycle/2);
      aclk <= ~aclk;
    end
  end

  sha256_manager #(
  .n_calculators(2),
  .max_characters(12)
  ) dut (
  .aclk(aclk), 
  .aresetn(aresetn), 
  .hash(256'hca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb), /* 'a' */
  //.hash(256'hb81cea691b5b1d2c9ba3a915f9dc274eb9da48dcdbfb800faddd01abde7c2ab5), /* 'h' 'A' */
  .start(start),
  .finish(finish),
  .result_password(result_password),
  .winner_calculator(winner_calculator)
  );

  /* test flow */
  initial begin

    $dumpfile ("data.vcd"); // Change filename as appropriate. 
    $dumpvars();
    aresetn <= 1'b0;
    start <= 1'b0;
    #(5*`clk_cycle)
    aresetn <= 1'b1;
    start <= 1'b1;
    #(`clk_cycle);
    start <= 1'b0;

    @(posedge finish);
    #(100*`clk_cycle)
    $finish;
  end

endmodule
