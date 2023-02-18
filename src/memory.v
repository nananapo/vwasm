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

// memory
reg [31:0] data_mem [MEMORY_SIZE-1:0];

// status
localparam STATE_WAIT    = 0;
localparam STATE_READ    = 1;
localparam STATE_WRITE   = 2;

reg [3:0]	state = STATE_WAIT;

// saved input
reg [31:0]	addr_bup;
reg [31:0]	wdata_bup;

// shidted address
wire [31:0] addr_shift = addr_bup >> 2;

assign cmd_ready = state == STATE_WAIT;

// アドレスが4byte alignedでは無い場合用
reg [3:0]	clock_cnt;
reg [31:0]	data_save;
reg [31:0]	data_save2;

always @(posedge clk) begin
	if (state == STATE_WAIT && cmd_start == 1) begin
		state		<= cmd_write ? STATE_WRITE : STATE_READ;
		addr_bup	<= addr;
		wdata_bup	<= wdata;
		clock_cnt	<= 0;
		rdata_ready	<= 0;
	end else if (state == STATE_READ) begin
		if (addr_bup % 4 == 0) begin
			rdata <= {
				data_mem[addr_shift][7:0],
				data_mem[addr_shift][15:8],
				data_mem[addr_shift][23:16],
				data_mem[addr_shift][31:24]
			};
			rdata_ready <= 1;
			state <= STATE_WAIT;
		end else begin
			if (clock_cnt == 0) begin
				data_save <= data_mem[addr_shift];
				clock_cnt <= clock_cnt + 1;
			end else begin
				rdata <= {
					addr_bup % 4 == 1 ? {
							data_mem[addr_shift][31:24],
							data_save[31:8]
						} :
					addr_bup % 4 == 2 ? {
							data_mem[addr_shift][23:16],
							data_mem[addr_shift][31:24],
							data_save[31:16]
						} :
					{
						data_mem[addr_shift][15:8],
						data_mem[addr_shift][23:16],
						data_mem[addr_shift][31:24],
						data_save[31:24]
					}
				};
				rdata_ready <= 1;
				state <= STATE_WAIT;	
			end
		end
	end else if (state == STATE_WRITE) begin
		if (addr_bup % 4 == 0) begin
			data_mem[addr_shift] = {
				wdata[7:0],
				wdata[15:8],
				wdata[23:16],
				wdata[31:24]
			};
			rdata_ready <= 1;
			state <= STATE_WAIT;
		end else begin
			if (clock_cnt == 0) begin
				data_save <= data_mem[addr_shift];
				clock_cnt <= clock_cnt + 1;
			end else if (clock_cnt == 1) begin
				data_save2 <= data_mem[addr_shift + 1];
				clock_cnt <= clock_cnt + 1;
			end else if (clock_cnt == 2) begin
				data_mem[addr_shift] <= {
					addr_bup == 1 ?
						{data_save[31:24], wdata_bup[7:0], wdata_bup[15:8], wdata_bup[23:16]} : 
					addr_bup == 2 ?
						{data_save[31:16], wdata_bup[7:0], wdata_bup[15:8]} : 
					{data_save[31:8], wdata_bup[7:0]}
				};
				clock_cnt <= clock_cnt + 1;
			end else begin
				data_mem[addr_shift + 1] <= {
					addr_bup == 1 ?
						{wdata_bup[31:24], data_save2[23:0]} : 
					addr_bup == 2 ?
						{wdata_bup[31:24], wdata_bup[23:16], data_save2[15:0]} : 
					{wdata_bup[31:24], wdata_bup[23:16], wdata_bup[15:8], data_save2[7:0]}
				};
				clock_cnt <= clock_cnt + 1;
			end
		end
	end
end
endmodule
