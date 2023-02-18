module Memory #(
	parameter MEMORY_SIZE = 2048
)(
	input  wire			clk,

	input  wire			cmd_start,
	input  wire			cmd_write,
	input  wire			cmd_ready,

	input  wire [31:0]	addr,
	output reg  [31:0]	rdata,
	output reg			rdata_ready,
	input  wire [31:0]	wdata
);

reg [31:0] data_mem [MEMORY_SIZE-1:0];

localparam STATE_WAIT = 0;
localparam STATE_READ = 1;
localparam STATE_WRITE = 1;

reg [3:0]	state = STATE_WAIT;
reg [31:0]	addr_bup;
reg [31:0]	wdata_bup;

assign cmd_ready = state == STATE_WAIT;

always @(posedge clk) begin
	if (state == STATE_WAIT && cmd_start == 1) begin
		state		<= cmd_write ? STATE_WRITE : STATE_READ;
		addr_bup	<= addr;
		wdata_bup	<= wdata;
		rdata_ready	<= 0;
	end else if (state == STATE_READ) begin
		rdata <= {
			data_mem[addr_bup][7:0],
			data_mem[addr_bup][15:8],
			data_mem[addr_bup][23:16],
			data_mem[addr_bup][31:24]
		};
		rdata_ready <= 1;
		state <= STATE_WAIT;
	end else if (state == STATE_WRITE) begin
		data_mem[addr_bup] = {
			wdata[7:0],
			wdata[15:8],
			wdata[23:16],
			wdata[31:24]
		};
		rdata_ready <= 1;
		state <= STATE_WAIT;
	end
end

endmodule
