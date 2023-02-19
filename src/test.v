module test();

  reg clk = 0;

  Top #() t(
    .clk(clk)
  );

  always
    #1 clk = ~clk;

  initial
	#100001 $finish;

  initial begin
    $dumpfile("debug.vcd");
    $dumpvars(0,test);
  end

endmodule
