

//RECIBE UN NUMERO Y LO TRADUCE A DISPLAYS
module Lab2(
	input [3:0] bcd_in,
	output reg [0:6] bcd_out);
	

	reg [6:0] bcd_ou;
	always @(*)
	begin
	 case(bcd_in)
		4'b0000: bcd_ou=7'b_111_111_0;//0    // se puedo haber escrito: 0: bcd_out=7'b_111_111_0;
		4'b0001: bcd_ou=7'b_011_000_0;//1
		4'b0010: bcd_ou=7'b_110_110_1;//2
		4'b0011: bcd_ou=7'b_111_100_1;//3
		4'b0100: bcd_ou=7'b_011_001_1;//4
		4'b0101: bcd_ou=7'b_101_101_1;//5
		4'b0110: bcd_ou=7'b_101_111_1;//6
		4'b0111: bcd_ou=7'b_111_000_0;//7
		4'b1000: bcd_ou=7'b_111_111_1;//8
		4'b1001: bcd_ou=7'b_111_101_1;//9
		default: bcd_ou = 7'b000_000_0;
		
	endcase
	bcd_out= ~bcd_ou;
	end
	endmodule
		