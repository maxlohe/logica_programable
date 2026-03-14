module font_rom(
    input [11:0] addr,  
    output reg [7:0] data 
);
    // Memoria ROM: 4096 posiciones de 8 bits cada una
    reg [7:0] rom [0:4095];

    initial begin
       
        $readmemh("font_rom.hex", rom);
    end

    always @(*) begin
        data = rom[addr];
    end
endmodule