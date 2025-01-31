iverilog -o testbench.vvp -s sha256_core_tb ../test/sha256_core_tb.sv ../src/sha256_core.v
vvp -l sim_log testbench.vvp
rm testbench.vvp