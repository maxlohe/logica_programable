
//recibe un grado mediante SW, se mapea a un duty value (5% a 10%)
//hay una frecuencia alterada para el clk, mediante un clkdiv(5MHz)
//hay una frecuencua para clk_pwm de 50Hz
// el comparador evalua el valor de count y del valor duty para on u off
// la idea es controlar un servomotor


module pwm(
	input MAX10_CLK1_50,
	input [9:0] SW,
	output [15:0] ARDUINO_IO,
	output [0:6] HEX0,
   output [0:6] HEX1,
   output [0:6] HEX2
);


	wire rst = SW[0];
    wire [7:0] grado_raw = SW[8:1];
    reg [7:0] grado;
    wire [3:0] uni, dec, cen;

	always @(*) begin
        if (grado_raw > 8'd180)
            grado = 8'd180;
        else
            grado = grado_raw;
    end

wire clk_div;
reg [16:0] count = 0;
wire [16:0] duty;
wire arduino;

parameter maxCount=100_000;


clk_divider #(.FREQ (5_000_000)) clkdiv(
	 .clk(MAX10_CLK1_50),
    .rst(rst), //SW 0
    .clk_div(clk_div)
	 );



	 //Como se mapea de duty % a grados
	 //min max
	 assign duty = 5000 + (grado * 5000) / 180;


// contador
always @(posedge clk_div  or posedge rst)
begin
	if(rst) count<=0;
	else if(count>=maxCount) count<=0;
	else count<=count+1;
end

//comparador
assign arduino = (count < duty);
assign ARDUINO_IO[0] = arduino;


//displays
assign uni = grado % 10;
assign dec = (grado / 10) % 10;
assign cen = (grado / 100) % 10;


Lab2 d0 (.bcd_in(uni), .bcd_out(HEX0));
Lab2 d1 (.bcd_in(dec), .bcd_out(HEX1));
Lab2 d2 (.bcd_in(cen), .bcd_out(HEX2));


endmodule

// 2: 5Mhz
// 5/ 10 ms

