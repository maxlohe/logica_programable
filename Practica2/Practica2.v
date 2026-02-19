module Practica2 #(
    parameter Nin = 10, 
    parameter Nout = 7
)(
    input [Nin-1:0] bcd_in,
    output [Nout-1:0] D1, D2, D3, D4
);

    wire [3:0] unidades, decenas, centenas, miles;

    
    assign unidades = bcd_in % 10;
    assign decenas  = (bcd_in / 10) % 10;
    assign centenas = (bcd_in / 100) % 10; 
    assign miles    = bcd_in / 1000;

    Lab2 u1 (
        .bcd_in(unidades),
        .bcd_out(D1)
    );
    
    Lab2 u2 (
        .bcd_in(decenas),
        .bcd_out(D2)
    );
    
    Lab2 u3 (
        .bcd_in(centenas),
        .bcd_out(D3)
    );
    
    Lab2 u4 (
        .bcd_in(miles),
        .bcd_out(D4)
    );
    
endmodule