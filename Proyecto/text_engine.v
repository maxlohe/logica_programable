module text_engine(
    input [9:0] CounterX,    
    input [9:0] CounterY,
    input [7:0] angulo,     
    output reg [11:0] rom_addr, 
    input [7:0] rom_data,   
    output reg pixel_on     
);

   
    wire [3:0] decenas  = (angulo / 10);
    wire [3:0] unidades = (angulo % 10);

   
    always @(*) begin
        pixel_on = 0;
        rom_addr = 12'b0;

        if (CounterY >= 100 && CounterY < 116 && CounterX >= 100 && CounterX < 108) begin
            rom_addr = {decenas, CounterY[3:0]}; 
            pixel_on = rom_data[~CounterX[2:0]]; 
        end
        
        
        else if (CounterY >= 100 && CounterY < 116 && CounterX >= 108 && CounterX < 116) begin
            rom_addr = {unidades, CounterY[3:0]};
            pixel_on = rom_data[~CounterX[2:0]];
        end
    end
endmodule