module Practica2_w (
    input  [9:0] SW,      
    output [0:6] HEX0,    
    output [0:6] HEX1,    
    output [0:6] HEX2,    
    output [0:6] HEX3     
);

    
    
    Practica2 mi_diseno (
        .bcd_in(SW),    
        .D1(HEX0),      
        .D2(HEX1),      
        .D3(HEX2),      
        .D4(HEX3)       
    );

endmodule