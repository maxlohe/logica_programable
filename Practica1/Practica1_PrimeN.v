

//DETERMINAR SI UN NUMERO DE 4 BITS ES PRIMO

module Practica1_PrimeN(
    input [3:0] SW,
    output reg LED
);

	always @(*) begin
		case(SW)
			4'd2: LED=1;
			4'd3: LED=1;
			4'd5: LED=1;
			4'd7: LED=1;
			4'd11: LED=1;
			4'd13: LED=1;
			default: LED=0;
		endcase
	end
	endmodule
		
