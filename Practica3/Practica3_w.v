module Practica3_w(
    input         CLOCK_50, 
    input  [3:0]  KEY,      
    input  [9:0]  SW,  
    output [0:6]  HEX0,
    output [0:6]  HEX1,
    output [0:6]  HEX2
);

    wire rst_inv    = ~KEY[0]; 
    wire load_inv   = ~KEY[1];
    wire updown_inv = ~KEY[2];

    Practica3 mi_contador (
        .clk(CLOCK_50),   
        .rst(rst_inv),     
        .load(load_inv),   
        .updown(updown_inv),
        .datain(SW[6:0]),
        
        .unidades(HEX0),  
        .decenas(HEX1),   
        .centenas(HEX2)
    );

endmodule