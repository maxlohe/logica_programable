
/*1) Cronómetro en Verilog Objetivo: Descripción del problema 
El cronómetro debe cumplir con las siguientes características: 
• Inicia el conteo del tiempo. 
• Detiene el conteo del tiempo. 
• Reinicia el cronómetro a cero. 
• Debe contar en unidades de tiempo (pueden ser segundos, milisegundos) 
• Mostrar el resultado en display de 7 seg. */

module crono2(
    input CLOCK_50,
    input [0:0] SW,  
    input [1:1] KEY, 
    output [0:6] HEX0,
		output [0:6] HEX1,
		output [0:6] HEX2,
		output [0:6] HEX3,
		output [0:6] HEX4
);

    wire rst = ~KEY[1];
    wire senal = SW[0];

    reg [31:0] count; 
    reg [9:0]  cms;    
    reg [6:0]  cs;     

    
    always @(posedge CLOCK_50 or posedge rst) begin
        if (rst) begin
            count <= 0;
            cms <= 0;
            cs <= 0;
        end else if (senal) begin
            if (count >= 49_999) begin 
                count <= 0;
                if (cms >= 999) begin
                    cms <= 0;
                    if (cs >= 99) cs <= 0; 
                    else cs <= cs + 1;
                end else begin
                    cms <= cms + 1;
                end
            end else begin
                count <= count + 1;
            end
        end
    end

    
    wire [3:0] uni_ms = cms % 10;
    wire [3:0] dec_ms = (cms / 10) % 10;
    wire [3:0] cen_ms = (cms / 100) % 10;
    wire [3:0] uni_s  = cs % 10;
    wire [3:0] dec_s  = (cs / 10) % 10;

    
    Lab2 d0 (.bcd_in(uni_ms), .bcd_out(HEX0));
    Lab2 d1 (.bcd_in(dec_ms), .bcd_out(HEX1));
    Lab2 d2 (.bcd_in(cen_ms), .bcd_out(HEX2));
    Lab2 d3 (.bcd_in(uni_s),  .bcd_out(HEX3));
    Lab2 d4 (.bcd_in(dec_s),  .bcd_out(HEX4));

endmodule