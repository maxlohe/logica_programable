

module Practica1_PrimeN_tb();
reg[3:0] sw;
wire led;

Practica1_PrimeN dut(
	.SW(sw),
	.LED(led)
);

initial begin
		sw=4'd0; #10; 
      sw=4'd1; #10;
      sw=4'd2; #10;
      sw=4'd3; #10;
      sw=4'd4; #10;
      sw=4'd5; #10;
		sw=4'd6; #10;
      sw=4'd7; #10;
		sw=4'd8; #10;
      sw=4'd9; #10;
		sw=4'd10; #10;
      sw=4'd11; #10;
		sw=4'd12; #10;
      sw=4'd13; #10;
		sw=4'd14; #10;
      sw=4'd15; #10;
		
		$stop;
		$finish;
  end


  initial
  begin
    $monitor("sw = %b, led = %b", sw,led);
  end

  initial
  begin
    $dumpfile("Practica1_PrimeN_tb");
    $dumpvars(0, Practica1_PrimeN_tb);
  end

endmodule 
		