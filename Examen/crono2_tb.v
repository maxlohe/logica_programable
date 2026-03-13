

module crono2_tb();

reg CLOCK_50;
reg [3:0] SW;
reg [1:0] KEY;
wire [0:6] HEX0;
wire [0:6] HEX1;
wire [0:6] HEX2;
wire [0:6] HEX3;
wire [0:6] HEX4;



crono2 DUT(
    .CLOCK_50(CLOCK_50),
    .SW(SW),
    .KEY(KEY),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4)
);


always #10 CLOCK_50 = ~CLOCK_50;


initial begin

CLOCK_50 = 0;
SW = 4'b0000;
KEY = 2'b11;

#100 KEY[1] = 0;

#100 KEY[1] = 1;

#100 SW[0] = 1;


#5000000;


SW[0] = 0;

#500000;


SW[0] = 1;

#5000000;

$stop;

end

endmodule