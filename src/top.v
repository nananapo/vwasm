module Top (
  input wire clk
);

reg [7:0]  inst_mem [4095:0];
reg [31:0] data_mem [4095:0];
reg [31:0] func_table [31:0];

initial begin
	$readmemh("../test/42.wasm", inst_mem);
end

localparam CPU_STATE_INIT			= 8'd0;
localparam CPU_STATE_ERROR			= 8'd1;
localparam CPU_STATE_VALIDATE_MAGIC	= 8'd2;

reg cpu_state [7:0] = CPU_STATE_INIT;

reg [31:0] inst_addr = 0;
reg [31:0] inst      = 0;

reg [31:0] clock_count = 0;

always @(posedge clk) begin
	if (cpu_state == CPU_STATE_INIT) begin
		cpu_state <= CPU_STATE_VALIDATE_MAGIC;
		inst_addr <= 0;
	end else if (cpu_state == CPU_STATE_VALIDATE_MAGIC) begin
		if (inst == 32'h0061736d) begin

32'h01000000
		end
	end
end


endmodule
