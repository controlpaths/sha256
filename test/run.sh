iverilog -o testbench.vvp -s sha256_core_tb ../test/sha256_manager_tb.sv ../src/sha256_manager.v ../src/sha256_core_pif.v
vvp -l sim_log testbench.vvp
rm testbench.vvp