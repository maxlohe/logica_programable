



module Practica2_tb();

 
    reg [9:0] bcd_in;
    wire [6:0] D1, D2, D3, D4;
    reg [3:0] unidades, decenas, centenas, miles;

  
 Practica2 dut (
        .bcd_in(bcd_in),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4)
    );

  initial begin
        bcd_in = 0;
        unidades = 0;
        decenas = 0;
        centenas = 0;
        miles = 0;
        #10;

        repeat(55) begin 
        bcd_in = $random % 1024; 
      
            unidades = bcd_in % 10;
            decenas  = (bcd_in / 10) % 10;
            centenas = (bcd_in / 100) % 10;
            miles    = (bcd_in / 1000);
            
            #10; 
        end
        
        $stop;
    end
	
	initial
  begin
    $monitor("bcd_in = %b, unidades = %b, decenas = %b, centenas = %b, miles = %b", bcd_in, unidades, decenas, centenas, miles);
  end

  initial
  begin
    $dumpfile("Practica2");
    $dumpvars(0, Practica2_tb);
  end

 endmodule