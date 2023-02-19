module Top (
  input wire clk
);

reg			mem_inst_cmd_start;
reg			mem_inst_cmd_write;
reg			mem_inst_cmd_ready;
reg [31:0]	mem_inst_addr;
reg [31:0]	mem_inst_rdata;
reg			mem_inst_rdata_ready;
reg [31:0]	mem_inst_wdata;
reg [31:0]	mem_inst_wmask;

reg			cpu_stop_flg= 1;

Memory #(
	.MEMORY_FILE("../test/42.wasm.mem")
) InstMemory (
	.clk(clk),
	.cmd_start(mem_inst_cmd_start),
	.cmd_write(mem_inst_cmd_write),
	.cmd_ready(mem_inst_cmd_ready),
	.addr(mem_inst_addr),
	.rdata(mem_inst_rdata),
	.rdata_ready(mem_inst_rdata_ready),
	.wdata(mem_inst_wdata),
	.wmask(mem_inst_wmask)
);

Core core (
	.clk(clk),
	.stop_flg(cpu_stop_flg),

	.mem_inst_cmd_start(mem_inst_cmd_start),
	.mem_inst_cmd_write(mem_inst_cmd_write),
	.mem_inst_cmd_ready(mem_inst_cmd_ready),
	.mem_inst_addr(mem_inst_addr),
	.mem_inst_rdata(mem_inst_rdata),
	.mem_inst_rdata_ready(mem_inst_rdata_ready),
	.mem_inst_wdata(mem_inst_wdata),
	.mem_inst_wmask(mem_inst_wmask)
);

endmodule