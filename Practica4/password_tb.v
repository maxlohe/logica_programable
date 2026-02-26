module password_tb();

    reg        CLOCK_50;
    reg  [9:0] SW;
    reg  [3:0] KEY;
    wire [0:6] HEX0, HEX1, HEX2, HEX3;

    password dut(
        .CLOCK_50(CLOCK_50), 
        .SW(SW),
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    
    initial begin
        CLOCK_50 = 0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        
        SW = 0;
        KEY = 4'b1111; 
        #40;

        
        KEY[0] = 0; 
        #40;
        KEY[0] = 1;
        #40;

        
        repeat(20) begin
            SW[3:0] = $unsigned($random) % 16; 
            #20;
            KEY[1] = 0; // Pulsar 
            #40;
            KEY[1] = 1; // Soltar 
            #40;
        end
       
        
        SW[3:0] = 4'd2; #20; KEY[1] = 0; #40; KEY[1] = 1; #40;
        SW[3:0] = 4'd0; #20; KEY[1] = 0; #40; KEY[1] = 1; #40;
        SW[3:0] = 4'd0; #20; KEY[1] = 0; #40; KEY[1] = 1; #40;
        SW[3:0] = 4'd7; #20; KEY[1] = 0; #40; KEY[1] = 1; #40;

        #100;
        
        
        KEY[0] = 0;
        #40;
        KEY[0] = 1;

        #100;
        $stop;
    end
	 
	initial begin
    $monitor("Tiempo: %t | SW: %d | KEY: %b | Estado: %d | Salida HEX: %h %h %h %h", 
             $time, SW[3:0], KEY[1:0], dut.current, HEX3, HEX2, HEX1, HEX0);
end
endmodule