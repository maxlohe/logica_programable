/*

1) Cronómetro en VerilogObjetivo:Diseñar un sistema en Verilog que:
1. Reciba un número de entrada mediante los switches.
2. Al activar una señal de start, calcule la sumatoria desde 0 hasta el número ingresado.
3. Muestre el resultado de la sumatoria en una salida, como LEDs o displays de 7segmentos.
*/


module crono(
input CLOCK_50,
input [3:0] SW,
input [1:0] KEY,

output [0:6] HEX0,
output [0:6] HEX1,
output [0:6] HEX2,
output [0:0] LEDR
);

// maximo 4 bits de entrada
// numero maximo en dec 15
// la suma maxima de 15 = 128 (8bits)




wire start=~KEY[0];
wire rst=~KEY[1];
reg enable;

wire [3:0] uni, dec, cen;
reg [7:0] count;
reg [7:0] suma;
reg [0:0] iniciado;
reg [7:0] copia;
reg [7:0] salida;
wire [7:0] numero= SW[3:0];

initial begin
count<=0;
suma<=0;
copia<=0;
salida<=0;
enable<=0;
iniciado<=0;

end

always @(*)
begin
	if(start)
	iniciado<=1;
end


always @(posedge CLOCK_50)
begin
	if(rst) begin
		count<=0;
		suma<=0;
		copia<=0;
		salida<=0;
		enable<=0;

	end
	else 
		if(iniciado && count<=numero) begin
			count<=count+1;
			suma<=suma+count;
			
			
		end
		if(count>numero) begin
			salida<=suma;
		end
	end




assign uni = salida % 10;
assign dec = (salida / 10) % 10;
assign cen = (salida / 100) % 10;


Lab2 d0 (.bcd_in(uni), .bcd_out(HEX0));
Lab2 d1 (.bcd_in(dec), .bcd_out(HEX1));
Lab2 d2 (.bcd_in(cen), .bcd_out(HEX2));

assign LEDR[0]=enable;

endmodule
