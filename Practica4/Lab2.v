

module Lab2(
	input [4:0] bcd_in,
	output reg [0:6] bcd_out);


	reg [6:0] bcd_ou;
	always @(*)
	begin
	 case(bcd_in)
		0: bcd_ou=7'b_111_111_0;//0    // se puedo haber escrito: 0: bcd_out=7'b_111_111_0;
		1: bcd_ou=7'b_011_000_0;//1
		2: bcd_ou=7'b_110_110_1;//2
		3: bcd_ou=7'b_111_100_1;//3
		4: bcd_ou=7'b_011_001_1;//4
		5: bcd_ou=7'b_101_101_0;//5
		6: bcd_ou=7'b_101_111_1;//6
		7: bcd_ou=7'b_111_000_0;//7
		8: bcd_ou=7'b_111_111_1;//8
		9: bcd_ou=7'b_111_101_1;//9
		
		10: bcd_ou=7'b_001_111_1;//b
		11: bcd_ou=7'b_111_011_1;//a
		12: bcd_ou=7'b_011_110_1;//d
		
		13: bcd_ou=7'b_111_101_1;//g
		14: bcd_ou=7'b_111_111_0;//o
		15: bcd_ou=7'b_000_000_0;//null
		
		
		default: bcd_ou = 7'b000_000_0;

	endcase
	bcd_out= ~bcd_ou;
	end
	endmodule