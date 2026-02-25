

// un contador que llegue a 100 mediante el clk div
// la salida del clk div, es un bcd_in a un display
// si rst=1 count=0
// si load=1 count será data_in
// si updown=1 count será count-1
// else= count=count+1
// si llega a 0 en updown pasa a 100
//data in es un sw array

module Practica3(
    input clk,   
    input rst,  
	 input load,
	 input updown,
	 input  [6:0] datain, //es un numero en binario
    output [6:0] unidades,
    output [6:0] decenas,
	 output [6:0] centenas);

    wire clk_div;
    reg [6:0] cuenta; 
	 
wire [3:0] un;
wire [3:0] de;
wire [3:0] ce;
	 
    clk_divider #(.FREQ(1)) divisor (
        .clk(clk),
        .rst(rst),
        .clk_div(clk_div)
    );

    
    always @(posedge clk_div or posedge rst ) begin
		if (rst) 
			cuenta <= 7'd0;
		else if (load)
			cuenta <= datain;
		else if (updown & (cuenta == 7'd0))
			cuenta <= 7'd100;
		else if (updown)
			cuenta<=cuenta-7'd1;
		else if (cuenta == 7'd100)
			cuenta <= 7'd0;
		else
			cuenta <= cuenta + 7'd1;		
    end

 
assign un = cuenta % 10;
assign de = (cuenta / 10) % 10;
assign ce = (cuenta / 100) % 10;
	 
  

   
    Lab2 dec_unidades (
        .bcd_in(un),
        .bcd_out(unidades)
    );

    Lab2 dec_decenas (
        .bcd_in(de),
        .bcd_out(decenas)
    );
	 
	 Lab2 dec_centenas (
        .bcd_in(ce),
        .bcd_out(centenas)
    );
	 


endmodule


