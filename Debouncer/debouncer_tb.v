

module debouncer_tb();

reg CLOCK_50;
reg [1:0] KEY;
wire  LEDR;


debouncer uut (
    .CLOCK_50(CLOCK_50),
    .KEY(KEY),
    .LEDR(LEDR)
);


initial begin
    CLOCK_50 = 0;
    forever #10 CLOCK_50 = ~CLOCK_50;
end


initial begin
    
    
    KEY = 2'b11;  
    #50;
    KEY[0] = 0;  
    #50;
    KEY[0] = 1;   
    
    
    #100;
    
    
    KEY[1] = 0;   // presionar botón
    #100;         // poco tiempo
    KEY[1] = 1;   // soltar
    
    #200;
    
    
    KEY[1] = 0;   
    #1000;        // suficiente tiempo 
    KEY[1] = 1;
    
    #2000;
    
    $stop;        
end

endmodule