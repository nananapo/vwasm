module Core (
	input wire 			clk,
	input wire			stop_flg,

	output reg			mem_inst_cmd_start,
	output reg			mem_inst_cmd_write,
	input  reg			mem_inst_cmd_ready,
	output reg [31:0]	mem_inst_addr,
	input  reg [31:0]	mem_inst_rdata,
	input  reg			mem_inst_rdata_ready,
	output reg [31:0]	mem_inst_wdata,
	output reg [31:0]	mem_inst_wmask
);

endmodule