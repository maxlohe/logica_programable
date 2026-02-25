

module Practica_tb();
   
    reg clk;
    reg rst;
    reg load;
    reg updown;
    reg [6:0] datain;

    
    wire [6:0] unidades;
    wire [6:0] decenas;
    wire [6:0] centenas;

    
    Practica3 DUT (
        .clk(clk),
        .rst(rst),
        .load(load),
        .updown(updown),
        .datain(datain),
        .unidades(unidades),
        .decenas(decenas),
        .centenas(centenas)
    );


 initial begin
    clk = 0;
end

always #5 clk = ~clk;

    
    initial begin 
       
        rst = 0;
        load = 0;
        updown = 0;
        datain = 7'd0;

        // rst
        #10 rst = 1;
        #20 rst = 0;
        
       
        #20;
        load = 1;
        datain = $urandom_range(0,100);
        #20;
        load = 0;

        
        updown = 0;
        #100; 

        
        load = 1;
        datain = 7'd99;
        #20 load = 0;
        #40; //  99-100- 0

        
        #20 updown = 1;
        #100;

        
        load = 1;
        datain = 7'd1;
        #20 load = 0;
        #60; 

        
        #100 $stop;
    end
	 
	
        
        initial begin
    $monitor("T:%0t | R:%b L:%b UD:%b | In:%d | Val:%d | Seg:%b %b %b", 
             $time, rst, load, updown, datain, DUT.cuenta, centenas, decenas, unidades);
end



initial begin
    $dumpfile("practica3.vcd");
    $dumpvars(0, Practica_tb);
end
    
	 
endmodule







	
	
	
	
	
	